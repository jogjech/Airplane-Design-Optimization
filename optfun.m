function [ cost ] = optfun(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    S_ref = x(1);
    A = x(2);
    lamda = x(3);
    Sweep_LE = x(4);
    InputFile
    [t0, w0, wf] = T0_iteration( 0.25, W0_guess ,S_ref,1,A,lamda,Sweep_LE);
    cost = COC(t0, w0, wf);
    if (t0 >   9.72e+05)
        cost = 1e10;
        disp('rr')
    end
    

end

