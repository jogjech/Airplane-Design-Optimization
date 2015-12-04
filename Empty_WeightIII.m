function [W_e] = Empty_WeightIII(W_0,T_0,S_ref,L_fus,D_fus,S_ht,S_vt,c_f,Swet_Sref,A,e)
	%[We] = Empty_WeightIII(W_o,T_o,S_ref,L_fus,D_fus,S_ht,S_vt,c_f,Swet_Sref,A,e)
   
    %Constants=============================================================
    W_0 = W_0 /9.81;%kg        %Convert Newtons to kg
    lamda = 0.15;  %Taper Ratio
    t_c = 0.14;     %Thickness to chord ratio for sc20714 airfoil
    Sweep_LE = 35;%deg  %Leading edge sweep
    Sweep_c_4 = atan(tand(Sweep_LE)-((1-lamda)/(A*(1+lamda))))*(180/pi);%deg   %Quarter chord sweep
    b = (S_ref*A)^0.5;%m       %Span
    C_root = (2*S_ref)/(b*(1+lamda));%m    %Root chord
    C_root = C_root *3.28084;%ft           %Root chord 
    b = b*3.28084;%ft  %Conversion to ft
    c_7 = C_root*(1 - ((1-lamda)/(b/2))*0.07*(b/2));%ft    %Chord length at 7% half span
    c_29 = C_root*(1 - ((1-lamda)/(b/2))*0.29*(b/2));%ft   %Chord length at 29% half span
    c_76 = C_root*(1 - ((1-lamda)/(b/2))*0.76*(b/2));%ft   %Chord length at 76% half span
    %======================================================================
    %Main
        %Engine Weight
        %ENGLISH UNIT SECTION
        T_0 = T_0 * 0.224808942443;%lbs                     %Convert N's of thrust to lbs 
        T_0 = T_0 / 2;%lbs                                  %Single Engine Thrust
        W_eng_dry = 0.521*(T_0)^0.9;%lbs                    % Compute the engine dry weight
        W_eng_oil = 0.082*(T_0)^0.65;%lbs                   % Compute the engine oil weight 
        W_eng_rev = 0.034*(T_0);%lbs                        % Compute the thrust reverser weight 
        W_eng_control = 0.26*(T_0)^0.5;%lbs                 % Compute engine control weight 
        W_eng_start = 9.33*(W_eng_dry/1000)^1.078;%lbs      % Compute the engine start weight;
        W_engine = W_eng_dry + W_eng_oil + W_eng_rev + W_eng_control + W_eng_start;%lbs  %Total Engine Weight
        W_engine2 = W_engine * 2 ;%lbs                       %Weight of two engines
        %START OF SI UNITS
        W_engine2 = W_engine2 * 0.453592;%kg                %Convert lbs to kg  


        %Fuselage Weight
        %IMPORTANT NOTE: IF TAIL SECTION OR COCKPIT LENGTH CHANGE THE
        %CONSTANTS S_wetcocktail AND L_cocktail NEED TO BE RECALCULATED.
        %SEE DAKOTA'S ANALYSIS TO CALCULATE NEW CONSTANTS!
        S_wetcocktail = 569.8324096;%m^2            %Constant wetted area of tail section of fuselage and cockpit                              
        L_cocktail = 23.95;%m                       %Consant length of cockpit and tail section
        L_cabin = L_fus - L_cocktail;%m             %Length of cabin
        S_wetcabin = 2*pi*(D_fus/2)*L_cabin;%m^2    %Wetted area of cabin
        S_wetfuse = S_wetcabin + S_wetcocktail;%m^2 %Wetted area of fuselage
        W_fuse = 24 * S_wetfuse;%kg                  %Weight estimation of fuselage
        
        %Tail Weight
            %Horizontal Stabilizer
            W_ht = 27 * S_ht;%kg                  %Weight of horizontal stabilizer
                
            %Vertical Stabilizer
            W_vt = 27 * S_vt;%kg                  %Weight of vertical stabilizer
            
         %Wing Weight
         %ENGLISH UNIT SECTION
         N_limpos = 2.5;                                          %Positive limit load
         N_z = 1.5*N_limpos;                                   %Ultimate limit load
         
         %IMPORTANT NOTE: IF THE WING CONTROL SURFACE PERCENTAGES CHANGE
         %THE CONSTANTS NEED TO BE UPDATED
         S_flap = ((0.71*b/2)-(0.07*b/2))*(0.30*c_7)*2;%ft^2           %Flap area
         S_slat = ((0.86*b/2)-(0.29*b/2))*(0.05*c_29)*2;%ft^2          %Slat area
         S_ail = ((0.98*b/2)-(0.76*b/2))*(0.30*c_76)*2;%ft^2           %Aileron area
         S_csw = S_flap + S_slat + S_ail;%ft^2                         %Control surface area
         %=================================================================
         W_0 = W_0 * 2.20462;%lbs                 %Converts kg to lbs
         S_ref = S_ref *10.7639;%ft^2              %Converts m^2 to ft^2
         W_wing = 0.0051 * ((W_0 * N_z)^0.557)*(S_ref^0.649)*(A^0.5)*(t_c^-0.4)*((1+lamda)^0.1)*((cosd(Sweep_c_4))^-1)*S_csw^0.1;%lbs    %Wing Weight
    
         %START OF SI UNITS
         W_0 = W_0 * 0.453592;%kg                %Converts lbs to kg
         S_ref = S_ref * 0.09290313;%m^2         %Converts m^2 to ft^2
         W_wing = W_wing * 0.453592;%kg          %Converts lbs to kg
          
         %Landing Gear
         W_gear = 0.043 * W_0;%kg                 %Weight of landing gear
         
         %All Else Empty
         W_allemp = 0.17 * W_0;%kg                %Weight of "All Else Empty" (Important Interior Equipment)
         
%Empty Weight without trapped fuel
W_e = W_engine2 + W_fuse + W_ht + W_vt + W_wing + W_gear + W_allemp;%kg   %Sum of all components

Wcrew=8407.14;%N
Wpayload=166808.31;%N

% %Estimated Available Fuel Weight
% W_f = W_0 - Wcrew/9.81 - Wpayload/9.81 - W_e;%kg                      %Fuel weight
% 
% %Trapped Fuel and Oil
% W_trap = 0.005 * W_f;%kg                 %Weight of trapped fuel and oil
% 
% %Total empty weight with trapped fuel
% W_e = W_e + W_trap;%kg                    %Empty weight                             

%Empty Weight Fraction
%We_W0 = W_e / W_0;
W_e = W_e * 9.81;

end