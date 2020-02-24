% Elec 4700
% Assignment 2
% 100977279
% 23rd feduary 2020

clear all
close all

Wid = 30;
len = 45; 
% Electrostatic potential in a rectangle
% using the finite difference method for solving electrostatic potential
% for wid and len


Gmatrix = sparse((Wid * len), (Wid * len));
F = zeros((Wid*len),1);
Vmatrix = zeros(Wid,len); 

vo = 1;

nx = 45;
ny = 30;
G = sparse(nx*ny,ny*nx);
B =  zeros((nx*ny),1);

for i=1:nx
    for j=1:ny
        n = j + (i-1)*ny;
        if i==1
            B(n,1)=1;
            G(n,n)=1;
        elseif i==nx
            B(n,1)=0;
            G(n,n)=1;
        else
       
        nxm = (i-2)*ny + j;
        nxp = i*ny + j;
        nym = (i-1)*ny + j-1;
        nyp = (i-1)*ny + j+1;
       
        G(n,n) = -4;
        G(n, nxm) = 1;
        G(n, nxp) = 1;
        G(n, nym) = 1;
        G(n, nyp) = 1;
         
        end
    end  
end
V=G\B;
for i=1:nx
    for j=1:ny
        n = j + (i-1)*ny;
        
            map(i,j) = V(n,1);
    
    end
end

figure (1);
surf(map)

% V = Gmatrix\F;
% figure (2);
% Vmatrix = zeros(len, Wid);


% for i = 1:len
% 
%     for j = 1:Wid
%         n = j + (i - 1) * Wid;
%         Vmatrix(i, j) = V(n);
%     end
% end
%    
% mesh(Vmatrix);
% colorbar; 
% xlabel('y Direction')
% ylabel('x Direction')







% question 1b
len = 45; 
wid = 30; 
Gmatrix = sparse(len*wid, wid*len);
F = zeros(len*wid,1);
map = @(i,j) j + (i - 1)*wid;
for i=1:len
    
    for j=1:wid
        n = map(i,j);
        lenm = map(i-1,j);
        lenp = map(i+1,j);
        widm = map(i,j-1);
        widp = map(i,j+1);
        
      
        if i == 1
            Gmatrix(n,:) = 0;
            Gmatrix(n,n) = 1;
            F(n) = 1;
    
        elseif i == len
            Gmatrix(n,:) = 0;
            Gmatrix(n,n) = 1;
            F(n) = 1;
        elseif j == 1
           Gmatrix(n,:) = 0;
           Gmatrix(n,n) = 1;
            F(n) = 0;
        elseif j == wid
            Gmatrix(n,:) = 0;
            Gmatrix(n,n) = 1;
            F(n) = 0;
        else
            Gmatrix(n,:) = 0;
            Gmatrix(n,n) = -4;
            Gmatrix(n,lenm) = 1;
            Gmatrix(n,lenp) = 1;
            Gmatrix(n,widm) = 1;
            Gmatrix(n,widp) = 1;
        end
    end
end


Z = Gmatrix\F ;

% Setting up a surf plot
surfs = zeros(len,wid);
for i = 1:len
    for j = 1:wid
        n = map(i,j);
        surfs (i,j) = Z(n);
    end
end

%Plot
figure(3)
mesh(surfs)
title('Electrostatic Potential in Rectangular in numerical');



zone = zeros(45, 30);
a = 45;
b = 15;
W = linspace(-15,15,30);
l = linspace(0,45,45);
[x, y] = meshgrid(W, l);
for n = 1:2:1000
    
    zone = (zone + (4 * vo/pi) .* (cosh((n * pi * x)/a) .* sin((n * pi * y)/a)) ./ (n * cosh((n * pi * b)/a)));
    figure(4);
    mesh(zone);
    title('Electrostatic Potential in Rectangular in analytical');

    
 end
           
