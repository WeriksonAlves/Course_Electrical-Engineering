%%
% C�digo para projeto do controlador por avan�o de fase
% Autor: Deus est� vendo
%
%O suposto controlador ser�:
    % Gc = Kc * ( (T1s + 1)/(T1s + gama) )((T2s + 1)/(T2s + 1/beta)) com 0 < alfa < 1
    % Gav = Kat *( (s + Z)/(s + P) )
% Cosidera��es:
    % alfa  Atenua��o
    % cor   De +5� a +12�  
    % Gc   Controlador por atraso e avan�o de fase
    % GcG   FT de MA do sistema compensado
    % G1    Sistema com o ganho ajustado, mas n�o compensado
    % K3    Abrevia��o de Kat*beta
    % Ka    Constante do erro acelera��o
    % Kc   Ganho do controlador
    % Kp    Constante do erro est�tico
    % Kv    Constante do erro velocidade
    % MF    Margem de fase
    % MG    Margem de ganho
    % P1    Polo do controlador de avan�o
    % Z1    Zero do controlador de avan�o
    % P2    Polo do controlador de atraso
    % Z2    Zero do controlador de atraso
%% Parametros iniciais
clear; close all; clc; syms x positive; 
    % FT de MA
        num_G = 1;
        den1 = [1 1 0];
        den2 = [1 4];
        den_G = conv(den1,den2);
        %den_G = poly([-6 -21]);
        G = tf(num_G,den_G);
        

    %Margens
        MF = 50;
        MG = 10;
        Kp = 0; %N�o usado ainda
        Kv = 0; %N�o usado ainda
        Ka = 0; %N�o usado ainda
        cor= 5;
        K3 = 1;
        Kc = 40;
        G1 = Kc*G;
        eqnfase = -90*pi/180 - atan(x/1) - atan(x/4);%-atan(x/4);
        eqnmod = Kc/(x*sqrt(1^2+x^2)*sqrt(4^2+x^2));%*sqrt(4^2+x^2));

fprintf('Para uma MF inicial de %d� e uma MG inicial de %d.',MF,MG);
[Gm,Fm,WcF,WcG] = margin(G1);
GmdB = 20*log10(Gm);
display('Valores para Sistema com o ganho ajustado, mas n�o compensado: ');
fprintf('\nG1 tem margem de fase de %f� em %f rad/s.',Fm,WcG);
fprintf('\nG1 tem margem de modulo de %f em %f rad/s.',GmdB,WcF);

% Calculando Wng e beta
Wng = solve(eqnfase == -pi,x,'PrincipalValue', true)
Wcsimp = input('\n Insira o valor simplificado de Wng: ');
phi = MF + cor;
beta = (1 + sin(phi*pi/180))/(1 - sin(phi*pi/180));

% P=(Wng, -20*log10|G1(jw)|)
Py = -20*log10(subs(eqnmod,Wng))
Pysimp = input('\n Insira o valor simplificado do ponto P nas ordenadas: ');
P = [Wcsimp,Pysimp];
b = P(2)- 20*log10(P(1)); %ax + b = y
y = -20*log10(K3);

% Calculando o polo e o zero do coontrolador
Z2 = Wcsimp/10;
P2 = Z2/beta;
P1 = 10^((0 - b)/20);
Z1 = 10^((y - b)/20);

% Montando Gc
Gc = K3 * tf([1 Z1],[1 P1]) * tf([1 Z2],[1 P2])
GcG = Gc*G

w = logspace(-2,5,100);
bode(G,w);
grid on
hold on

bode(GcG,w);
grid on
title('Diagrama de Bode: Compara��o entre G(s) e GcG(s)')
legend('[G(s)]','[GcG(s)]');

[Gm1,Fm1,WcF1,WcG1] = margin(GcG);
Gm1dB = 20*log10(Gm1);

fprintf('\n O valor do Zero de avan�o(Z1) � %d.\n O valor do Polo de avan�o (P1) � %f.',Z1,P1);
fprintf('\n O valor do Zero de atraso(Z2) � %d.\n O valor do Polo de atraso (P2) � %f.',Z2,P2);
fprintf('\n O valor do ganho (Kc) � %f.',Kc);
display('\n Valores para Sistema com o ganho ajustado e compensado: ');
fprintf('\n G1 tem margem de fase de %f� em %f rad/s.',Fm1,WcG1);
fprintf('\n G1 tem margem de modulo de %f dB em %f rad/s.',Gm1dB,WcF1);
