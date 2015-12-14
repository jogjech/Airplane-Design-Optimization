%
% Weight Estimation Function, the only inputs of this funciton should be the
% thrust and and Surface Area of the Wing 
%

function [W0,W_f] = TotalWeight(S_wing,T0)
T0 = T0/2;
S_wing = S_wing * 10.76; %conv m^2 to ft^2
T0 = T0 * 0.22; %conv n to lbf
W_crew = 9*(175+30);%lb
W_payload = 125*(175+30);%lb
W0 = 700000;                     % the initial guess of our weight
tolerance = 0.05;                 % Define the convergence of the loop
W_eng_dry = 0.521*(T0)^0.9;       % Compute the engine dry weight
W_eng_oil = 0.082*(T0)^0.65;      % Compute the engine oil weight 
W_eng_rev = 0.034*(T0);           % Compute the thrust reverser weight 
W_eng_control = 0.26*(T0)^0.5;    % Compute engine control weight 
W_eng_start = 9.33*(W_eng_dry/1000)^1.078;    % Compute the engine start weight;
W_engine = W_eng_dry + W_eng_oil + W_eng_rev + W_eng_control + W_eng_start;

S_fuse = 11797.25;                % the unit is ft^2
S_ht = 1746.87502*2.0;            % the exposed area of the horizontal tail
S_vt = 1144.85;
W_fuse = 5*S_fuse;
W_ht = 5.5*S_ht;
W_wing = 10*S_wing*2.0;           % by multiplying by 2.2, we convert the reference area to the wet area
W_vt = 5.5*S_vt;

%% Fuel Fraction Computation 
%data input and revized here
mCruise=0.83;                           %The cruise Mach Number
aCruise = 973.1;                        % ft/s at
ftPerNm=6076.1;            
secsPerHr=3600; 
V_c=mCruise*aCruise/ftPerNm*secsPerHr;  % Cruise Speed 

L_D_c=15;                               %Optimal Lift Drag Ratio Cruise
cj_c=0.45;                              %Optimal Fuel Consumption Cruise
L_D_l=18;                               %Optimal Lift Drag Ratio Loiter
cj_l=0.4;                               %Optimal Fuel Consumption Loiter
R=9534/1.15;                            %Total Flight Distance in nautical miles
Rcm = R - 64 - 100;                     %Total Cruise Distance
Rcrev = 200 - 64 - 100;                 %200nm reserve minus reserve climb and descent%
E_l=1/6;        % Loiter Enduracne %hr
W1_W0=0.99;     %Warmup
W2_W1=0.99;     %Taxi
W3_W2=0.995;    %Takeoff
W4_W3=0.98;     %Climb
W4r_W3r=0.98;   %Climb Reserve
W5_W4=exp(-Rcm*cj_c/(L_D_c*V_c));   %Cruise
W5r_W4r=exp(-Rcrev*cj_c/(L_D_c*V_c));   %Reserve Cruise
W6_W5=1/exp((E_l/L_D_l)*cj_l);          %Loiter
W7_W6=0.99;     %Descent
W7r_W6r=0.99;   %Descent Reserve
W8_W7=0.992;    %Landing

convergence = 0;

while convergence == 0;
% Compute the fuel fraction
Mff = W1_W0*W2_W1*W3_W2*W4_W3*W5_W4*W6_W5*W7_W6*W8_W7*W5r_W4r*W7r_W6r*W4r_W3r;
Wf_W0 =1-Mff;           
Wf_W0 = 1.005*Wf_W0;    %Fuel Fraction with 0.5% trapped fuel

W_f = Wf_W0*W0;         % Compute the fuel weight
W_lg = 0.043*W0;        % Compute the landing gear weight
W_xtra = 0.17*W0;       % Compute the extra Weight

W0_new = 2*W_engine + W_wing + W_ht + W_vt + W_fuse + W_xtra + W_lg + W_f + W_payload + W_crew;

if abs(W0_new - W0)<= tolerance;
    convergence = 1;
end

W0 = W0_new;

end
W0 = W0 * 4.45;
W_f = W_f * 4.45;
end
   
    
