% Trabalho de Laborat�rio de M�quinas 2 - ELT 367
% Integrantes:
    % Werikson Alves 96708
    % Hiago Batista 96704

% Primeira Quest�o - Em uma m�quina  s�ncrona faz-se o  ensaio em vazio e 
% de curto-circuito para obter as suas curvas caracter�sticas em vazio e de
% curto-circuito, curvas estas necess�rias para determinar a rela��o de 
% curto-circuito, o valor da reat�ncia s�ncrona e outros par�metros. Dos 
% dados obtidos da m�quina s�ncrona do laborat�rio de m�quinas el�tricas, 
% conforme tabela abaixo, fa�a um programa de computador para plotar a 
% curva de satura��o em vazio, a linha de entreferro e a caracter�stica de 
% curto circuito. Usando a fun��o polinomial, �polifit do Matlab, a curva 
% caracter�stica em vazio pode ter uma aproxima��o muito boa. A partir dos
% gr�ficos determine, a rela��o de curto-circuito, o valor da reat�ncia 
% s�ncrona saturada e n�o saturada em p.u e em ohms. Os dados de placa da 
% m�quina s�o:  2 KVA, 230 V, 5 A, 1800 RPM, fator de pot�ncia = 0,8 
% indutivo, liga��o estrela e do campo 220 V, 0,6 A.

close all; clear all; clc;

% Dados de placa: 
             % Liga��o em estrela
S = 2e3;     %Potencia aparente
VT_L = 230;  %Tens�o terminal de linha
IA = 5;      %Corrente de armadura
w = 1800;    %Velocidade RPM
FP = 0.8;    %Fator de potenica atrasado
Ef = 220;    %Tens�o de campo
If = 0.6;    %Corrente de campo

% Dados de ensaio a vazio
Vazio_If = [0,0.01,0.02,0.03,0.04,0.05,0.08,0.1,0.15,0.21,0.25,0.3,0.35,0.4,0.45,0.5];
Vazio_EA = [8,21,35.4,40.2,46.2,61.5,88,105.5,140.5,172,190,208,222,233,244,253];
Vazio = [Vazio_If; Vazio_EA];

% Dados do entreferro
Linha_If = [0,0.01,0.02,0.03,0.04,0.05,0.08,0.1,0.15];
Linha_EA = [8,21,35.4,40.2,46.2,61.5,88,105.5,140.5];
Linha = [Linha_If; Linha_EA];

% Dados de ensaio em curto
Curto_If = [0,0.01,0.03,0.04,0.05,0.08,0.1,0.15,0.21,0.25,0.3,0.35];
Curto_IA = [0,0.41,0.62,0.84,0.98,1.45,1.73,2.6,3.47,4.13,4.89,5.68];
Curto = [Curto_If; Curto_IA];

% Determina��o das curva de satura��o em vazio, a linha de entreferro e a caracter�stica de curto circuito.
figure(1)
title('Caracter�sticas da M�quina')
%subplot(3,1,1);
hold on %Congela o grafico
plot(Vazio(1,:),Vazio(2,:),'*')
p1 = polyfit(Vazio(1,:),Vazio(2,:),3); %Encontra os coeficientes do polinomio de grau 2
x = 0:0.001:0.6; %Define um novo vetor x (com discretiza��o muito pequena)
y1 = polyval(p1,x); %Resolve o polinomio nos pontos do novo vetor x
plot(x,y1,'red--') %Plota o polinomio ajustado com linha tracejada
ylabel('Tens�o de Campo (V)', 'linewidth', 2)
legend('Satura��o em vazio')
xlabel('Corrente de Campo (A)', 'linewidth', 2)
grid on
axis([0 .6 0 300])

%subplot(3,1,2);
hold on %Congela o grafico
plot(Linha(1,:),Linha(2,:),'*')
p2 = polyfit(Linha(1,:),Linha(2,:),1); %Encontra os coeficientes do polinomio de grau 2
y2 = polyval(p2,x); %Resolve o polinomio nos pontos do novo vetor x
plot(x,y2,'k-') %Plota o polinomio ajustado com linha tracejada
ylabel('Tens�o de Campo (V)', 'linewidth', 2)
legend('Linha de entreferro')
xlabel('Corrente de Campo (A)', 'linewidth', 2)
grid on
axis([0 .6 0 300])

%subplot(3,1,3);
hold on %Congela o grafico
yyaxis right
plot(Curto(1,:),Curto(2,:),'*')
p3 = polyfit(Curto(1,:),Curto(2,:),1); %Encontra os coeficientes do polinomio de grau 2
y3 = polyval(p3,x); %Resolve o polinomio nos pontos do novo vetor x
plot(x,y3,'m -.') %Plota o polinomio ajustado com linha tracejada
ylabel('Corrente de Armadura (A)', 'linewidth', 2)
legend('Caracter�stica de curto circuito')
xlabel('Corrente de Campo (A)', 'linewidth', 2)
grid on
axis([0 .6 0 20])

%  LEGENDA mag
legend('Satura��o em vazio','','Linha de entreferro','','Caracter�stica de curto circuito','')
h = findobj(gcf, 'type', 'line');
set(h,'linewidth',1);

%A rela��o de curto-circuito de um gerador � definida como a raz�o entre a 
%corrente de campo requerida para a tens�o nominal a vazio e a corrente de
%campo requerida para a corrente nominal de armadura em curto-circuito.

Ia = 5;
x1 = (Ia-p3(2))/p3(1); 
fprintf('Da curva de curto, para Ia = %d A',Ia)
fprintf('\ntemos que: If = %f A \n',x1)
syms x2
Ea = 230;
x3 = solve(Ea == p1(1)*x2^3 + p1(2)*x2^2 + p1(3)*x2 + p1(4),x2);
fprintf('Da curva em vazio, para Ea = %d V',Ea)
fprintf('\ntemos que: If = %f A \n',x3(1))

If_para_EA_nominal = 0.3840; % => EA = 230  
If_para_IA_nominal = 0.3057; % => IA = 5  
IA_para_EA_nominal = 6.2530 % => EA = 230
Relacao_de_CC = If_para_EA_nominal/If_para_IA_nominal

%O valor da reat�ncia s�ncrona saturada em pu � o inverso do valor da
%rela��o de curto circuito.

Xs_pu = inv(Relacao_de_CC)
Xs_ohns = Xs_pu *((VT_L^2)/S)

%O valor da reat�ncia s�ncrona n�o saturada em pu pode ser encontrada
%simplesmente dividindo-se a EA por uma corrente de campo obtida na regi�o 
%linear (linha de entreferro) da curva CAV.

Xns_ohns = VT_L/(sqrt(3)*IA_para_EA_nominal)
Xns_pu = Xns_ohns/((VT_L^2)/S)

