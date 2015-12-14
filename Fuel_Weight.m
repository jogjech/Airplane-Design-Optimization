function [Wf,V_Takeoff,V_cr,V_Landing] = Fuel_Weight(CD0, K, CLmax, TotalWeight, TakeoffThrust, Sref)
% [Wf,V_Takeoff,V_cr,V_Landing] = Fuel_Weight(CD0, K, CLmax, TotalWeight, TakeoffThrust, Sref), All
% SI unit C - 1 / s, Range - m, Weight and Thrust - N, Sref - m ^ 2;

InputFile


T0 = TakeoffThrust; % N
W0 = TotalWeight; % N
ks = 1.25;
rhos = getDensity(0);
Vstall = sqrt(2 * W0 / (rhos*Sref*CLmax));
% ------------------------------------------Start, warm - up and taxi
C01 = 0.30; % 1 / hr
t01 = 0.25; % hr
W1_W0 = 1 - C01 * t01 * (0.05 * T0 / W0);
% --------------------------------------------------Takeoff
W1 = W1_W0 * W0;
V_Takeoff=sqrt(2 * W0 / (rhos*Sref*CLmax/1.2));
C02 = 0.30; % 1 / hr
t02 = 1 / 60; % hr
W2_W1 = 1 - C02 * t02 * (T0 / W1);
% ----------------------------------------------------Climb
W2 = W1 * W2_W1;
Vclimb = sqrt(W2 / Sref / (3 * rhos * (CD0 + 0.01)) * (T0 / W2 + sqrt((T0 / W2) ^ 2 + 12 * (CD0 + 0.01) * K(1))));
CLclimb = (2 * W2 / (rhos * Vclimb ^ 2 * Sref));
CDclimb = (CD0 + 0.01) + K(1) * CLclimb ^ 2;
Dclimb = (rhos * Vclimb ^ 2 / 2) * Sref * (CD0 + 0.01);
dhe = 4572; % m
W3_W2 = exp(-C*dhe / (Vclimb * (1 - Dclimb / T0)));
Ps = Vclimb * (T0 - Dclimb) / W2;
xclimb = dhe / Ps;
% --------------------------------------------------Climb - Cruise
h_clcr = linspace(4572, 10668, 21);
R_clcr = linspace(0, 118604, 21);
W3 = W2 * W3_W2;
WR = 1;
Wcl = W3;
W4_W3 = 1;
for i = 1 : 20
        Wcl(i + 1) = WR(i) * Wcl(i);
rho_cl = getDensity((h_clcr(i) + h_clcr(i + 1)) / 2);
V_stallcl = sqrt(2 * Wcl(i + 1) / (rho_cl*Sref*CLmax));
V_crcl = ks * V_stallcl;
CL_crcl = 2 * Wcl(i + 1) / (rho_cl * V_crcl ^ 2 * Sref);
LOverD_crcl = CL_crcl / (CD0 + K(4) * CL_crcl ^ 2);
WR(i + 1) = exp(-(R_clcr(i + 1) - R_clcr(i)) * C / (V_crcl*LOverD_crcl));
W4_W3 = W4_W3 * WR(i + 1);
end
W4r_W3r = 0.98;   % Climb Reserve
% ------------------------------------------------ -Cruise
W4 = W4_W3 * W3;
h_cr = 10668; % m
rho_cr = getDensity(h_cr);
R_cr = linspace(118604, R - 185200, 101);
V_cr = M * sqrt(1.4 * 287 * 219);
Wcr = W4;
WR_cr = 1;
W5_W4 = 1;
for i = 1 : 100
        Wcr(i + 1) = WR_cr(i) * Wcr(i);
CL_cr = 2 * Wcr(i + 1) / (rho_cr * V_cr ^ 2 * Sref);
LOverD_cr = CL_cr / (CD0 + K(4) * CL_cr ^ 2);
WR_cr(i + 1) = exp(-(R_cr(i + 1) - R_cr(i)) * C / (V_cr*LOverD_cr));
W5_W4 = W5_W4 * WR_cr(i + 1);
end
% ------------------------------------------------Loiter

W5 = W5_W4 * W4;
Vstallcruise = sqrt(2 * W5/ (getDensity(10668)*Sref*1.8));

C_loiter = 0.4 / 3600; % 1 / s
CL_loiter = sqrt(CD0 / K(4));
CD_loiter = CD0 + K(4) * CL_loiter ^ 2;
LOverD_loiter = CL_loiter / CD_loiter;
W6_W5 = 1 / exp((E*C_loiter / LOverD_loiter));
% ------------------------------------------ -Descent, Descent Reserve,
% Landing
W7_W6 = 0.99;     % Descent
W7r_W6r = 0.99;   % Descent Reserve
W8_W7 = 0.992;    % Landing
W_Landing=W5*W6_W5*W7_W6*W7r_W6r*W8_W7;
V_StallLanding=sqrt(2 * W_Landing / (rhos*Sref*CLmax/0.8/1.2));
V_Landing=1.3*V_StallLanding;
Mff = W1_W0 * W2_W1 * W3_W2 * W4_W3 * W5_W4 * W6_W5 * W7_W6 * W8_W7 * W7r_W6r * W4r_W3r;
Wf_W0 = 1 - Mff;
Wf_W0 = 1.005 * Wf_W0;    % Fuel Fraction with 0.5 % trapped fuel
WfOverW0 = Wf_W0;
Wf = Wf_W0 * W0;
end

