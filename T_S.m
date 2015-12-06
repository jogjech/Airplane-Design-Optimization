clear
clc
%T_S plot
S = 200:20:700;%m^2
InputFile
close all
A = 9;
lamda = 0.15;
Sweep_LE = 35;
for index = 1:10
    for i = 1:length(S)
        S_ref = S(i);
        [ t, w ,wf] = T0_iteration(0.25,W0_guess,S_ref,index,A,lamda,Sweep_LE);
        T0(i,index) = t;
        W0(i,index) = w;
        Wf(i,index) = wf;
    end
end

figure(1)
hold on
plot(S,T0(:,1),S,T0(:,2),S,T0(:,3),S,T0(:,4),S,T0(:,5),S,T0(:,6),S,T0(:,7),S,T0(:,8),S,T0(:,9),S,T0(:,10),S,10.026e+05*ones(length(S),1),'LineWidth',2)
xlabel('S_{ref} [m^2]')
ylabel('Takeoff Thrust [N]')
title('T-S Plot')
T_COC = 2*10^5:5*10^3:1.5*10^6;
disp('mei ka 1')
tol = 1;

for i = 1:length(S)
    for j = 1: length(T_COC)
        W0_old = 0;
        W0 = T_COC(j)*4;
        while (abs(W0 - W0_old) > tol)    
            W0_old = W0;
            %call Tail_Sizing
            [S_ht,S_vt] = Tail_Sizing(S(i),L_fus,D_fus,A);
            %call Drag Polar
            [CD0, K, CL_max] = Drag_Polar(c_f, Swet_Sref, A, e);
            %call Empty_Weight
            [We] = Empty_WeightIII(W0,T_COC(j),S(i),L_fus,D_fus,S_ht,S_vt,c_f,Swet_Sref,A,e,lamda,Sweep_LE);
            %call Fuel Weight
            [Wf] = Fuel_Weight(CD0, K, CL_max, W0, T_COC(j), S(i));
            %call MTOW iteration (get W0)
            [W0]  = MTOW(Wf,We);
        end
        
        cost(i,j) = COC(T_COC(j),W0,Wf);
    end
end


disp('mei ka 2')
contour(S,T_COC,cost',10,'LineWidth',2);
colorbar
legend('Take off','Climb_{1st}','Climb_{2nd}','Climb_{3rd}','Climb_{4th}','Climb_{5th}','Climb_{6th}','Cruise','Ceiling','Manuver','Thrust limit','COC contour','Our Design');