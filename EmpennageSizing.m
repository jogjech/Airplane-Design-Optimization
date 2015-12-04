%Homework 6
TR = 0.15;                                  %Taper ratio of wing
C_r = 10.85;                                %Root chord length
c = (2/3).*((1+TR+TR.^2)/(1+TR)).*C_r;      %Mean Aero chord length of wing
L_fus = 71.0;                             %Length of Fuselage
b_w = 56.12;                               %Wing Span (m^2)
S_w = 350;                              %Wing Reference Area
%=============================================
%Vertical Stabilizer
L_vt = 0.5 * L_fus;                           %Distance between Wing AC and Vertical Stablizer AC

C_vt = 0.09;                               %Vertical Volume Coefficient

S_vt = (C_vt*b_w*S_w)./L_vt;               %Vertical Stabilizer Reference Area

ARv = 1.20;                                  %Aspect Ratio
TRv = 0.5;                                  %Taper Ratio

C_rv = (2./(1+TRv)).*(S_vt./ARv).^0.5;        %Root Chord
C_tv = C_rv.*TRv;                             %Tip Chord
alphav = 33;                                  %Quarter chord sweep (33-53 degrees)
b_v = (ARv.*S_vt)^0.5;                      %Vertical Stabilizer Span
theta_v = (atand((1./tand(90-alphav))+((1./(4.*(ARv.*S_vt).^0.5)).*C_rv.*(1-TRv))));               %Leading edge sweep
c_v = (2/3).*((1+TRv+TRv.^2)/(1+TRv)).*C_rv;   %Mean Aero chord (MAC) length of vertical stabilizer
y_v = (b_v./3).*((1+2.*TRv)./(1+TRv));          %Spanwise location of MAC
long_v = y_v.*tand(theta_v)+c_v./4;              %Location of MAC in longitudinal direction
%=============================================
%Horizontal Stabilizer
C_ht = 1;                                  %Horizontal Volume Coefficient
L_ht = 0.55 * L_fus;                           %Distance between Wing AC and Horizontal Stablizer AC
S_ht = (C_ht*c*S_w)./L_ht;               %Horizontal Stabilizer Reference Area

ARh = 1.6;                                  %Aspect Ratio
TRh = 0.62;                                 %Taper Ratio

C_rh = (2./(1+TRh)).*(S_ht./ARh).^0.5;        %Root Chord
C_th = C_rh.*TRh;                             %Tip Chord
alphah = 18;                                  %Quarter chord sweep (18-37 degrees)
b_h = (ARh.*S_ht)^0.5;                      %Horizontal Stabilizer Span
theta_h = ((atand((1./tand(90-alphah))+((1./(2.*(ARh.*S_ht).^0.5)).*C_rh.*(1-TRh)))));               %Leading edge sweep
c_h = (2/3).*((1+TRh+TRh.^2)/(1+TRh)).*C_rh;   %Mean Aero chord length of Horizontal stabilizer
y_h = (b_h./6).*((1+2.*TRh)./(1+TRh));          %Spanwise location of MAC
long_h = y_h.*tand(theta_h)+c_h./4;              %Location of MAC in longitudinal direction


















