function [S_ht,S_vt] = Tail_Sizing(S_ref,L_fus,D_fus,A)
%[S_ht,S_vt] = Tail_Sizing(S_ref,L_fus,D_fus)
    InputFile
%Constants 
    %Tail sizing Constants
    b_w = sqrt(A*S_ref);%m^2                    %Wing Span 
    C_vt = 0.09;                                %Vertical Volume Coefficient
    C_ht = 1;                                   %Horizontal Volume Coefficient
    TR = 0.15;                                  %Taper ratio of wing
    C_r = 12.54;%m                              %Root chord length
    c = (2/3).*((1+TR+TR.^2)/(1+TR)).*C_r;%m    %Mean aerodynamic chord length of wing




InputFile
%Vertical Stabilizer
L_vt = 0.45 * L_fus;                           %Distance between Wing AC and Vertical Stablizer AC
S_vt = (C_vt*b_w*S_ref)./L_vt;               %Vertical Stabilizer Reference Area

%Horizontal Stabilizer

L_ht = 0.5 * L_fus;                           %Distance between Wing AC and Horizontal Stablizer AC
S_ht = (C_ht*c*S_ref)./L_ht;               %Horizontal Stabilizer Reference Area


end
