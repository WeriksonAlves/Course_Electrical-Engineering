% Trabalho de Laborat�rio de M�quinas 2 - ELT 367
% Integrantes:
    % Werikson Alves 96708
    % Hiago Batista 96704
    
% Terceira Quest�o � No laborat�rio foi feito o ensaio para a determina��o 
% das reat�ncias s�ncronas de eixo direto e de eixo em quadratura, conforme
% tabela abaixo. Fa�a um programa de computador que possibilite tra�ar um 
% conjunto de curvas  da pot�ncia em p.u em fun��o do �ngulo de pot�ncia, 
% admitindo que a tens�o da rede  e  a tens�o de excita��o sejam  de  1,0 
% p.u. Com base no programa obt�m-se os gr�ficos:

clear all; close all; clc;

Wr = 1778; % velocidade do rotor
V_max = 59;
V_min = 58; 
Imaximo = [1.48 1.2 1.36]; % correntes máximas por fase
Iminimo = [1.15 1.14 1.16]; % correntes minimas por fase
I_max = sum(Imaximo)/3; % corrente maxima (média dos valores de fase)
I_min = sum(Iminimo)/3; % corrente minima (média dos valores de fase)

Sb = 2e3; % potencia aparente
Vb = 230; % tensão terminal de linha 
Zb = Vb^2/Sb; % impedância base

Xd = (V_max/I_min)/Zb; % reatância de eixo direto em pu
Xq = (V_min/I_max)/Zb; % reatância em quadratura em pu
Xbar = 0.1; % impedância da linha 

delta = linspace(0, pi, 100); % ângulo delta de 0 a 180°

Vt = 1; % valor em pu
Ef = Vt;

Pf  = Vt* Ef.*sin(delta)/Xd ; % Pot�ncia devido a excitação de campo
Pr  = (Vt^2*(Xd - Xq).*sin(2.*delta))/(2*Xd*Xq); % Pot�ncia devido a relutância

P = Pf + Pr; % Potencia ativa 

% a) gerador ligado na rede elétrica
% plotagem 
figure(1)
plot(delta,P, 'LineWidth',2.0)
hold on
plot(delta,Pf,'k','LineWidth',2.0)
plot(delta,Pr,'r','LineWidth',2.0)
grid on
title ('Gerador ligado na rede el�trica','Fontsize',18)
xlabel('�ngulo \delta','Fontsize',20)
ylabel('Pot�ncia','Fontsize',20')
legend('Pot. Ativa resultante','Pot. devido excitação','Pot. devido relutância','Fontsize',14)

% b) Gerador ligado na rede el�trica por meio de um barramento de 0,1 pu
Xq = (V_min/I_max)/Zb; % reatância em quadratura
Xd = (V_max/I_min)/Zb; % reatância de eixo direto 
Xbar = 0.1; 

Pfb = Vt* Ef.*sin(delta)/(Xd + Xbar); % Pot�ncia devido a excitação de campo
Prb = (Vt^2*(Xd - Xq +Xbar).*sin(2.*delta))/(2*Xd*(Xq + Xbar)); % Pot�ncia devido a relutância

Pb= Pfb + Prb;

figure(2)
plot(delta,Pb, 'LineWidth',2.0)
hold on
plot(delta,Pfb,'k','LineWidth',2.0)
plot(delta,Prb,'r','LineWidth',2.0)
grid on
title ('Gerador ligado na rede el�trica por meio de um barramento de 0,1 pu','Fontsize',18)
xlabel('�ngulo \delta','Fontsize',20)
ylabel('Pot�ncia','Fontsize',20')
legend('Pot. Ativa resultante','Pot. devido excitação','Pot. devido relutância','Fontsize',14)

% c)  gerador ligado diretamente na rede onde Xd = Xq
Xq = (V_min/I_max)/Zb; % reatância em quadratura
Xd = Xq; % reatância de eixo direto 

Pfc = Vt* Ef.*sin(delta)/Xd ; % Pot�ncia devido a excitação de campo
Prc = (Vt^2*(Xd - Xq).*sin(2.*delta))/(2*Xd*Xq); % Pot�ncia devido a relutância

Pc = Pfc + Prc; % Pot�ncia resultante
% plotagem 
figure(3)
plot(delta,Pc, 'LineWidth',2.0)
hold on
plot(delta,Pfc,'k','LineWidth',2.0)
plot(delta,Prc,'r','LineWidth',2.0)
grid on
title ('Gerador ligado diretamente na rede com Xd = Xq','Fontsize',25)
xlabel('�ngulo \delta','Fontsize',20)
ylabel('Pot�ncia','Fontsize',20')
legend('Pot. Ativa resultante','Pot. devido excitação','Pot. devido relutância','Fontsize',14)

% d) gerador ligado a rede por meio de um barramento de 0.1 pu e Xd = Xq

Xq = (V_min/I_max)/Zb; % reatância em quadratura
Xd = Xq; % reatância de eixo direto 
Xbar = 0.1; 

Pfd = Vt* Ef.*sin(delta)/(Xd + Xbar); % Pot�ncia devido a excitação de campo
Prd = (Vt^2*(Xd - Xq +Xbar).*sin(2.*delta))/(2*Xd*(Xq + Xbar)); % Pot�ncia devido a relutância

Pd = Pfd + Prd;

figure(4)
plot(delta,Pd, 'LineWidth',2.0)
hold on
plot(delta,Pfd,'k','LineWidth',2.0)
plot(delta,Prd,'r','LineWidth',2.0)
grid on
title ('Gerador ligado na rede el�trica por meio de um barramento de 0,1 pu e Xd = Xq','Fontsize',25)
xlabel('�ngulo \delta','Fontsize',20)
ylabel('Pot�ncia','Fontsize',20')
legend('Pot. Ativa resultante','Pot. devido excitação','Pot. devido relutância','Fontsize',14)
