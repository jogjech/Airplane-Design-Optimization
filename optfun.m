function [ cost ] = optfun(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
InputFile
    S_ref = x(1);
    
    A = x(2);
    lamda = x(3);
    Sweep_LE = x(4);
    
    [t0, w0, wf] = T0_iteration( 0.25, W0_guess ,S_ref,1,A,lamda,Sweep_LE);
    cost = COC(t0, w0, wf);
    

end

