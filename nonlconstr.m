function [c,ceq] = nonlconstr(x)
InputFile
BFL = s_FL;
aCruise = 973.1;                                  %ft/s, air speed at 35000 ft
ftPerNm = 6076.1;                                 %convert coefficient from ft to m
secsPerHr = 3600;                                 %convert coefficient from hour to second
KTF=1.68781;                                      %convert coefficient from knot to ft/s
rho_TO = 2.239e-3;                                %slug/ft^3, air density at Newwark altitude
rho_SL = 2.377e-3;                                %slug/ft^3, air density at sea level
rho_L = 2.309e-3;                                 %slug/ft^3, air density at Singapore
rho_CR = 7.38e-4;                                 %slug/ft^3, air density at 35000ft
V_c = M*aCruise/ftPerNm*secsPerHr;                %Cruise Speed 
nz=1.5;                                           %Load factor
TW=zeros(1,10);
CLmax=2.3;
CL_maxTO=CLmax/1.3;
CL_maxL=CL_maxTO/0.8;
CL_maxCr=1.8;
KTF=1.68781;
V_c=KTF*V_c;                      

    S_ref = x(1);
    A = x(2);
    lamda = x(3);
    Sweep_LE = x(4);
    [t0, w0, wf] = T0_iteration( 0.25, W0_guess ,S_ref,1,A,lamda,Sweep_LE);
    
    
    WL_S=(0.6*10000-1000)/80*(rho_L/rho_SL)*CL_maxL/0.77;
    w0_l = 0;
    W_exact = WL_S * 10.76*S_ref*4.45;
    tol = 1e3;
    T0_L = 1e4;
    brk = 0;
    while(abs(w0_l-W_exact)>tol)  
        T0_L = T0_L+10;
        %[w0_l,CD0,K,CL_max,We,Wf] = TSW( S_ref(i), t0 );
        [w0_l,useless] = TotalWeight(S_ref,T0_L);
        if(w0_l>W_exact)
            brk = 1;
            break
        end
    end
    if brk == 1
        T0_L = NaN;
    end
    WingLoad = w0*0.22/S_ref/10.76;
    TW=WingLoad/(BFL/37.5*(rho_TO/rho_SL)*CL_maxTO);
    
    c = [t0-T0_L;
     t0-1.026e6;
     TW-t0/w0];
    
    
    ceq = [];