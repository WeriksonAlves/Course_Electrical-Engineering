%%
% C�digo para projeto do controlador por avan�o de fase
% Autor: Z� pequeno 1
%
%O suposto controlador ser�:
    % Gav = Kav * alfa * ( (Ts + 1)/(T alfa s + 1) ) com 0 < alfa < 1
    % Gav = Kav *( (s + Z)/(s + P) )
% Cosidera��es:
    % alfa  Atenua��o
    % cor   De +5� a +12�  
    % Gav   Controlador por avan�o de fase
    % GcG   FT de MA do sistema compensado
    % G1    Sistema com o ganho ajustado, mas n�o compensado
    % K1    Abrevia��o de Kav*alfa
    % Ka    Constante do erro acelera��o
    % Kav   Ganho do controlador
    % Kp    Constante do erro est�tico
    % Kv    Constante do erro velocidade
    % MF    Margem de fase
    % MG    Margem de ganho
    % P1    Polo do controlador de avan�o
    % Z1    Zero do controlador de avan�o

%% Parametros iniciais
clear; close all; clc; syms x positive; 
    % FT de MA
        num_G = 1;
        %den1 = [1 1 0];
        %den2 = [0.1 1];
        %den_G = conv(den1,den2);
        den_G = poly([0 -1]);
        G = tf(num_G,den_G);
       
    %Margens
        MF = 50; % Completar eqn corretamente
        MG = 8;  % Completar eqn corretamente
        Kp = 0;                                           %N�o usado ainda
        Kv = 0;                                           %N�o usado ainda
        Ka = 0;                                           %N�o usado ainda
        cor= 5;  % Completar eqn corretamente
        K1 = 10;  % Completar eqn corretamente
        Kc = 50;
        G1 = Kc*G;
        eqnfase = -90*pi/180 - atan(x/1);   % Completar eqn corretamente
        eqnmod = Kc/(x*sqrt(1^2+x^2)); % Completar eqn corretamente

fprintf('Para uma MF inicial de %d� e uma MG inicial de %d.',MF,MG)  
[Gm,Fm,WcF,WcG] = margin(G1);
GmdB = 20*log10(Gm);
display('Valores para Sistema com o ganho ajustado, mas n�o compensado: ');
fprintf('\nG1 tem margem de fase de %f� em %f rad/s.',Fm,WcG);
fprintf('\nG1 tem margem de modulo de %f em %f rad/s.',GmdB,WcF);

phi = MF - Fm + cor; %Graus
alfa = (1 - sin(phi*pi/180))/(1 + sin(phi*pi/180));
modG1 = -20*log10(1/sqrt(alfa));
Wc = solve(20*log10(eqnmod)==modG1,x,'PrincipalValue', true)
Wcsimp = input('\n Insira o valor simplificado de Wc: ');

% Calculando o polo e o zero do coontrolador
Z = Wcsimp*sqrt(alfa);
P = Wcsimp/sqrt(alfa);
Kav = K1/alfa;

% Montando Gc
Gc = Kav * tf([1 Z],[1 P])
GcG =Gc*G

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

fprintf('\n O valor do Zero de avan�o(Z1) � %d.\n O valor do Polo de avan�o (P1) � %f.',Z,P);
fprintf('\n O valor do ganho (Kc) � %g.',Kav);
fprintf('\n Valores para Sistema com o ganho ajustado e compensado: ');
fprintf('\n G1 tem margem de fase de %f� em %f rad/s.',Fm1,WcG1);
fprintf('\n G1 tem margem de modulo de %f dB em %f rad/s.',Gm1dB,WcF1);
