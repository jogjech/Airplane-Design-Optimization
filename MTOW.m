function [W0]  = MTOW(Wf,We)
% [W0,Wf]  = MTOWiteration(We_W0, Wf_W0), this function is used to find the
% optimal output of maximum takeoff weight through iteration 
    Wcrew=8407.14;%N
    Wpayload=166808.31;%N
    
%     W0 =(Wcrew+Wpayload)/(1-Wf_W0-We_W0);    % calculate the estimated weight in kg
%     (1-Wf_W0-We_W0)
%     Wf = W0*Wf_W0;                           % calculate the output fuel weight for the COC function in kg
    W0 = Wcrew + Wpayload + Wf + We;
end 
