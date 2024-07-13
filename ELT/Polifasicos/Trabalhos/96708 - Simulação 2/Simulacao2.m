% W�rikson F. de O. Alves - 96708
% Trabalho de Simula��o 2 - ELT492
% Calculo da pot�ncia monof�sica no circuito RC s�rie
%..........................................................................
% Dados iniciais (Monof�sicos)
Vf = 127; % Volts, Tens�o da Fonte RMS
R = 100; % Ohms, Resist�ncia
C = 25e-6; % Faraday, Capacitor
f = 60; % Hertz, Frequ�ncia da Fonte
A1 = 0; % Rad, Fase da Tens�o
W = 2*pi*60; % Rad/s, Frequ�ncia Angular
t = 0:1e-6:0.03; % Intervalo analisado
%..........................................................................
% Corrente (Monof�sico)
Xc = 1/(j*W*C); % Reat�ncia Capacitiva
B1 = atan2(-abs(Xc),R); % Fase da Corrente em rad
Z = abs(R + Xc); % Modulo da Imped�ncia
If = (Vf)/Z; % Valor da corrente RMS
i = (If)*( sqrt(2) )*cos( (W*t) + B1 ); % Corrente em fun��o do tempo
I = 100*(i); % Corrente mutiplicada pelo faor de escala
%..........................................................................
%Tens�o (Monof�sica)
v = ( Vf )*( sqrt(2) )*cos( (W*t) + A1 ); % Vetor tens�o em fun��o do tempo
%..........................................................................
% Pot�ncia ativa instant�nea (Monof�sica)
Pa = v.*i
%..........................................................................
% Pot�ncia media (Monof�sica)
Pm= [ ];
for d = 1 : length(t)
    Pm(d)= (Vf)*(If)*cos(A1 - B1);
end;
%..........................................................................
% Plotagem dos Gr�ficos (Monof�sico)
figure(1);
grid on
hold on
plot(t,v,'r','linewidth',2);
plot(t,I,'m','linewidth',2);
plot(t,Pa,'b','linewidth',2);
plot(t,Pm,'g','linewidth',2);
legend('Tens�o','Corrente (x100)','Pot�ncia Instant�nea','Pot�ncia M�dia');
xlabel('t[s]');
ylabel('V,A,W');
title('Simula��o 2: Gr�fico 1','Fontsize',24);

%..........................................................................
% Dados iniciais, Van est� na refer�ncia, Tens�o (Trif�sico), ABC
Alfa1 = 0*(pi/180);
Alfa2 = -120*(pi/180);
Alfa3 = 120*(pi/180);
Van = (Vf)*( sqrt(2) )*cos( (W*t) + Alfa1);
Vbn = (Vf)*( sqrt(2) )*cos( (W*t) + Alfa2);
Vcn = (Vf)*( sqrt(2) )*cos( (W*t) + Alfa3);
%..........................................................................
% Corrente (Trif�sico), R, C e Z s�o os mesmos
Beta1 = (Alfa1) - (B1);
Beta2 = (Alfa2) - (B1);
Beta3 = (Alfa3) - (B1);
Ia = (If)*( sqrt(2) )*cos((W*t) + Beta1);
Ib = (If)*( sqrt(2) )*cos((W*t) + Beta2);
Ic = (If)*( sqrt(2) )*cos((W*t) + Beta3);
%..........................................................................
% Pot�ncia ativa instant�nea (Trif�sico)
P3 = (Van.*Ia)+(Vbn.*Ib)+(Vcn.*Ic)
%..........................................................................
% Plotagem dos Gr�ficos (Trif�sico)
figure(2)
grid on
hold on
plot(t,Pa,'b','linewidth',2);
plot(t,Pm,'g','linewidth',2);
plot(t,P3,'k','linewidth',2);
legend('Pot�ncia Instant�nea','Pot�ncia M�dia','Pot�ncia Trif�sica');
xlabel('t[s]');
ylabel('W');
title('Simula��o 2: Gr�fico 2','Fontsize',24);