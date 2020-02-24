

L = 75;
W = 50;
Gmatrix = sparse((W * L), (W * L));
F = zeros(1,(W*L));
vo = 1;

% conductivity Values 
condout = 1; %Conductivity outside the boxes   
condin = 10e-2; %Conductivity inside the boxes  
inner1 = [(L* 1/4), (L * 2.5/4), 0, (W * 1.5/4)];%top box region
inner2 = [(L * 1/4), (L * 2.5/4),  W, (W * 3/4)];%bottom box region


    
    
  for i = 1:1:L

    for j = 1:1:W
        
        k = j + (i - 1) * W;
        nym = j + ((i - 1)-1)*W;
        nyp = j + ((i + 1)-1)*W;
        nxm = (j-1) + (i - 1)*W;
        nxp = (j+1) + (i - 1)*W;
        if i == 1
            Gmatrix(k, :) = 0;
            Gmatrix(k, k) = 1;
            F(1, k) = 1;
        elseif i == L
            Gmatrix(k, :) = 0;
            Gmatrix(k, k) = 1;
            
        elseif j == 1 && i > 1 && i < L
            
            if i == inner2(1)
                Gmatrix(k, k) = -3;
                Gmatrix(k, nyp) = condin;
                Gmatrix(k, nxp) = condin;
                Gmatrix(k, nxm) = condout;
            
            elseif i == inner2(2)
                Gmatrix(k, k) = -3;
                Gmatrix(k, nyp) = condin;
                Gmatrix(k, nxp) = condout;
                Gmatrix(k, nxm) = condin;
                
            elseif (i > inner2(1) && i < inner2(2))
                Gmatrix(k, k) = -3;
                Gmatrix(k, nyp) = condin;
                Gmatrix(k, nxp) = condin;
                Gmatrix(k, nxm) = condin;
            else
                Gmatrix(k, k) = -3;
                Gmatrix(k, nyp) = condout;
                Gmatrix(k, nxp) = condout;
                Gmatrix(k, nxm) = condout;
            end
            
        elseif j == W && i > 1 && i < L
            
            if i == inner2(1)
                Gmatrix(k, k) = -3;
                Gmatrix(k,nym) = condin;
                Gmatrix(k, nxp) = condin;
                Gmatrix(k, nxm) = condout;
            
            elseif i == inner2(2)
                Gmatrix(k, k) = -3;
                Gmatrix(k, nym) = condin;
                Gmatrix(k, nxp) = condout;
                Gmatrix(k, nxm) = condin;
                
            elseif (i > inner2(1) && i < inner2(2)) 
                Gmatrix(k, k) = -3;
                Gmatrix(k, nym) = condin;
                Gmatrix(k, nxm) = condin;
                Gmatrix(k, nxm) = condin;
            else 
                Gmatrix(k, k) = -3;
                Gmatrix(k, nym) = condout;
                Gmatrix(k, nxp) = condout;
                Gmatrix(k, nxm) = condout;
            end
            
        else
            
            if i == inner2(1) && ((j < inner1(4)) || (j > inner2(4)))
                Gmatrix(k, k) = -4;
                Gmatrix(k, nyp) = condin;
                Gmatrix(k, nym) = condin;
                Gmatrix(k, nxp) = condin;
                Gmatrix(k, nxm) = condout;
            
            elseif i == inner2(2) && ((j < inner1(4)) || (j > inner2(4)))
                Gmatrix(k, k) = -4;
                Gmatrix(k, nyp) = condin;
                Gmatrix(k, nym) = condin;
                Gmatrix(k, nxp) = condout;
                Gmatrix(k, nxm) = condin;
                
            elseif (i > inner2(1) && i < inner2(2) && ((j < inner1(4)) || (j > inner2(4))))
                Gmatrix(k, k) = -4;
                Gmatrix(k, nyp) = condin;
                Gmatrix(k, nym) = condin;
                Gmatrix(k, nxp) = condin;
                Gmatrix(k, nxm) = condin;
            else
                Gmatrix(k, k) = -4;
                Gmatrix(k, nyp) = condout;
                Gmatrix(k, nym) = condout;
                Gmatrix(k, nxp) = condout;
                Gmatrix(k, nxm) = condout;
            end
           
        end
    end
                

  end 
  

cond = ones(L, W);

for i = 1:1:L
    
    for j = 1:1:W
        if(i > inner2(1) && i < inner2(2) && ((j < inner1(4)) || (j > inner2(4))))
            cond(i,j) = 10e-2;
        end
    end
    
end
    
figure(5);
surf(cond);
title('Conductivity Mapping ?(x,y)');


Z = Gmatrix\F';
Vbot = zeros(L,W);
for i = 1:1:L

    for j = 1:1:W
        n = j + (i - 1) * W;
        Vbot(i, j) = Z(n);
    end
end

figure (6);
surf(Vbot);
title('Voltage Map with Bottleneck V(x,y)');

[ElectroY, ElectroX] = gradient(Vbot);
DEN = cond.*gradient(Vbot);

ElectroX = -ElectroX;
ElectroY = -ElectroY;
figure(7)
surf(ElectroX)
title('X Direction of the Electric Field')

figure(8)
surf(ElectroY)
title('Y Direction of the Electric Field')



figure(9)
surf(DEN)
title('Current Density Magnitude plot')
B = 60;
BV = zeros(1, 100);
CV = zeros(1, 200);
for condu = 1:B
  BV(condu) = condin;
  BV = L*CV + W;
  Current = sum(sum(DEN))/(L*W);
  CV(condu) = Current;
  condin = condin + 0.01;    
end

Current = Current * -1
figure(10)
plot(BV, CV);
title('Current vs Conductivity');

figure(11)
plot(Current ,1:L);
title('Current vs mesh size');

figure(12)
plot(Current ,0:0.05:0.8);
title('Current vs  various bottle-necks');


