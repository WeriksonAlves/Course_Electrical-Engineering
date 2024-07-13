% Trabalho de M�quinas
% Integrantes:
    % Werikson Alves 96708
    % Hiago Batista 96704
    
% Segunda Quest�o � Uma m�quina s�ncrona se destaca em rela��o as demais 
% pelo fato da sua capacidade de fornecer para a rede el�trica pot�ncia 
% reativa atrasada e adiantada. Na sua opera��o como capacitor s�ncrono ela 
% comporta-se para a rede el�trica como puramente capacitiva ou puramente 
% indutiva, de acordo com a corrente de excita��o do enrolamento de campo. 
% Como capacitor s�ncrono � quando � feito o paralelo do gerador com a rede 
% el�trica ou o barramento. No momento que o disjuntor � fechado ela fica 
% flutuando no barramento, n�o fornecendo praticamente nada de pot�ncia 
% ativa e nada de reativa, comportando-se como uma carga puramente 
% resistiva. Da nona aula pr�tica,  onde foi feita a opera��o  da m�quina 
% s�ncrona com a rede el�trica para que ela funcione como um capacitor 
% s�ncrono, se a mesma deve ser ligada na rede em s�rie com uma reat�ncia 
% de 0,1 p.u, fa�a um programa de computador para tra�ar o gr�fico das 
% tens�o nos terminais do compensador quando a corrente do enrolamento de
% campo � variada entre 0 e 0, 7 A.

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
ZB = Ef^2/S;

%..........................................................................
%Dados da quest�o 1
% Entrada para novo fit da curva em vazio, para estrapolar at� 0,7 A
If_vazio = [0,0.01,0.02,0.03,0.04,0.05,0.08,0.1,0.15,0.21,0.25,0.3,0.35,0.4,0.45,0.5];
Ef_vazio = [8,21,35.4,40.2,46.2,61.5,88,105.5,140.5,172,190,208,222,233,244,253];
Vazio = [If_vazio; Ef_vazio];

% Dados do entreferro
If_Linha = [0,0.01,0.02,0.03,0.04,0.05,0.08,0.1,0.15];
Ef_Linha = [8,21,35.4,40.2,46.2,61.5,88,105.5,140.5];
Linha = [If_Linha; Ef_Linha];

If_curto = [0,0.01,0.03,0.04,0.05,0.08,0.1,0.15,0.21,0.25,0.3,0.35];
Ia_curto = [0,0.41,0.62,0.84,0.98,1.45,1.73,2.6,3.47,4.13,4.89,5.68];
Curto = [If_curto; Ia_curto];

%A rela��o de curto-circuito de um gerador � definida como a raz�o entre a 
%corrente de campo requerida para a tens�o nominal a vazio e a corrente de
%campo requerida para a corrente nominal de armadura em curto-circuito.

If_para_EA_nominal = 0.3850 % => EA = 230  
If_para_IA_nominal = 0.3055 % => IA = 5  
IA_para_EA_nominal = 6.2530 % => EA = 230
Relacao_de_CC = If_para_EA_nominal/If_para_IA_nominal

%O valor da reat�ncia s�ncrona saturada em pu � o inverso do valor da
%rela��o de curto circuito.

Xs_pu = inv(Relacao_de_CC)
X_s = Xs_pu *((VT_L^2)/S)

%O valor da reat�ncia s�ncrona n�o saturada em pu pode ser encontrada
%simplesmente dividindo-se a EA por uma corrente de campo obtida na regi�o 
%linear (linha de entreferro) da curva CAV.

X_ns = VT_L/(sqrt(3)*IA_para_EA_nominal)
Xns_pu = X_ns/((VT_L^2)/S)

%..........................................................................

% Pegando pontos da curva em vazio onde a mesma � mais linear para assim
% gerar a reta do entreferro
for (i=1:8) % at� o 8� ponto � bem linear
    Ip(i)=If_vazio(i);
    Ep(i)=Ef_vazio(i);
end

% Coeficientes A e B da reta de entreferro; f=Ax+B
p = polyfit(Ip,Ep,1);  % com a parte mais linear
f = polyval(p,If_vazio);%calculando pontos da reta de entreferro

% Coeficientes A, B, C e D da curva em vazio; f=Ax�+Bx�+Cx+D
p1 = polyfit(If_vazio,Ef_vazio,5);  % Grau 3 se aproximou bem
f1 = polyval(p1,If_vazio);%calculando pontos da polyfit

% Coeficientes A e B da reta de curto; f=Ax+B
p2 = polyfit(If_curto,Ia_curto,1);  % com a parte mais linear
f2 = polyval(p2,If_curto);%calculando pontos da reta de entreferro

% Coeficientes A, B, C e D da curva em vazio; f=Ax�+Bx�+Cx+D
p3 = polyfit(If_vazio,Ef_vazio,3);  % Grau 3 se aproximou bem

% Entrada do resistor em s�rie com os terminais da m�quina
r = 0.1; % em pu
R = r*ZB; % em ohm


% --------------- Criando matriz para o problema----------------
% Matriz dos dados:
%       coluna 1 => corrente de campo If
%       coluna 2 => tens�o de entreferro
%       coluna 3 => tens�o a vazio
%       coluna 4 => tens�o terminal com Ef = tens�o de entreferro
%       coluna 5 => tens�o terminal com Ef = tens�o a vazio
%       coluna 6 => corrente de armadura Ia 
M = zeros(70,6);

% Coluna da corrente If
for k = 1:70
    M(k,1)=k/100;
end

% Colunas das tens�es de entreferro e caracter�stica a vazio,
% respectivamente
for k = 1:70
    M(k,2) = p(1)*M(k,1)+p(2);
    M(k,3) = p3(1)*M(k,1)^3 + p3(2)*M(k,1)^2 + p3(3)*M(k,1) + p3(4);
end

% Colunas das tens�es terminais
for k = 1:70
    M(k,4) = ( Ef/sqrt(3) - abs( (Ef/sqrt(3) - M(k,2)) / sqrt(R^2 + X_ns^2) )*R )*sqrt(3);
    M(k,5) = ( Ef/sqrt(3) - abs( (Ef/sqrt(3) - M(k,3)) / sqrt(R^2 +  X_s^2) )*R )*sqrt(3);
    M(k,6) = abs((Ef/sqrt(3) - M(k,3)) / sqrt(R^2 +  X_s^2));
end

% Gr�ficos --------------------
figure('Position',  [10, 30, 1300, 650])% fixar tamanho da window

plot( M(:,1),M(:,4),'r','LineWidth',2)
hold on
plot( M(:,1),M(:,5),'b','LineWidth',2)
title ('Vt x If')
xlabel ('Corrente de armadura If (A)')
ylabel ('Tens�o terminal (V)')
grid on

legend( 'Vt - Entreferro','Vt - CAV','location','best')%,'Linha de Entreferro','CAV',)

%saveas (gcf,'2.png');
