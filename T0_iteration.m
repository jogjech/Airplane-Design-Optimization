function [ T0, W0 ,Wf] = T0_iteration( T0_W0, W0 ,S_ref,index,A,lamda,Sweep_LE)
%function [ T0, W0 ] = T0_iteration( T0_W0, W0 )
InputFile

T0 = T0_W0 * W0;
T0_old = 0;
W0_old = 0;

tol = 100;
i = 0;
while (abs(T0 - T0_old) > tol)    
    T0_old = T0;
    while (abs(W0 - W0_old) > tol)    
        W0_old = W0;
        %call Tail_Sizing
        [S_ht,S_vt] = Tail_Sizing(S_ref,L_fus,D_fus,A);
        %call Drag Polar
        [CD0, K, CL_max] = Drag_Polar(c_f, Swet_Sref, A, e);
        %call Empty_Weight
        [We] = Empty_WeightIII(W0,T0,S_ref,L_fus,D_fus,S_ht,S_vt,c_f,Swet_Sref,A,e,lamda,Sweep_LE);
        %call Fuel Weight
        [Wf] = Fuel_Weight(CD0, K, CL_max, W0, T0, S_ref);
        %call MTOW iteration (get W0)
        [W0]  = MTOW(Wf,We);
%         figure(100)
%         hold on
%         plot(i,real(W0),'*')
%         i=i+1;
    end
    hold off
    %call Wing Loading (use W0_old as input)
    [ W0_Sref ] = Wing_Loading( S_ref,W0);
    %call Design Diagram (get T0_W0)
    T_W = Design_Diagram(W0_Sref,CD0,K,CL_max,M,index);
    T0 = T_W * W0;
    
end

