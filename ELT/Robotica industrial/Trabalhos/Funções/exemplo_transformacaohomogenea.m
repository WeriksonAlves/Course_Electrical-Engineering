%% Exemplo de transforma��es homog�neas
clear % limpa as vari�veis da mem�ria
close all % fecha todas as figuras
syms theta phi psi dx dy dz % atribui vari�veis simb�licas a serem substitu�das por n�meros

% transforma��o Rotx
TX = [1    0        0       0;
      0 cos(phi) -sin(phi)  0;
      0 sin(phi)  cos(phi)  0;
      0    0        0       1];

% transforma��o Roty
TY = [cos(theta) 0 sin(theta) 0;
          0      1     0      0;
     -sin(theta) 0 cos(theta) 0;
          0      0     0      1];
 
% transforma��o Rotz
TZ = [cos(psi) -sin(psi) 0 0;
      sin(psi)  cos(psi) 0 0;
         0         0     1 0;
         0         0     0 1];


% transforma��o de dist�ncia/deslocamento  
Td = [1 0 0 dx;
      0 1 0 dy;
      0 0 1 dz;
      0 0 0  1];

% conjunto de pontos para formar um trap�zio
x0 = [-1  1 .5 -.5 -1;
      -1 -1  1  1 -1 ;
       1  1  1  1  1 ;
       1  1  1  1  1 ];

clf % limpa a figura
plot3(x0(1,:),x0(2,:),x0(3,:)) % plota figura com pontos x0
hold on; xlabel('x'); ylabel('y');zlabel('z')
x1 = subs(Td,[dx dy dz],[5 0 8])*subs(TZ,psi,pi/2)*subs(TX,phi,0)*x0; % realiza transforma��o
plot3(x1(1,:),x1(2,:),x1(3,:)) % plota figura com pontos x1
grid on % adiciona grid � figura
axis equal 
