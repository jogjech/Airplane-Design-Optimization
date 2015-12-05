%Input needed
InputFile;
c_bar = 8.0753; %(m)Chord length of wing MAC
c_bar_vs = 7.77715; %(m)Chord length of vertical stabilizer MAC
c_bar_hs = 4.3114; %(m)Chord length of horizontal stabilizer MAC
L_fus = 71.244; %(m)Length of fuselage
D_fus = 5.45; %(m) Diameter of fuselage
L_nace = 7.29; %(m)Length of nacelle
D_nace = 3.429; %(m)Diameter of nacelle

t_c = 0.15; %(m)Max thickness of wing airfoil
t_c_hs = 0.12; %(m)Max thickness of horizontal stabilizer wing
t_c_vs = 0.12; %(m)Max thickness of vertical stabilizer wing

x_c = 0.37; %Chordwise location of max thickness of wing
x_c_hs = 0.3; %Chordwise location of max thickness of horizontal stabilizer
x_c_vs = 0.3; %Chordwise location of max thickness of vertical stabilizer


C_root_wing = 11.88; %(m)Root chord
TR_wing = 0.15;     %Taper Ratio
C_tip_wing = TR_wing*C_root_wing; %(m)Tip chord
b_2_wing = 61.48/2;  %(m) Span
LE_sweep_wing = 35; %(deg)Leading edge sweep
c_4_sweep_wing = (tand(LE_sweep_wing) - ((1 - TR_wing)/(A*(1+TR_wing))))*(180/3.14159);

C_root_hs = 5.23; %(m)Root chord
TR_hs = 0.62; %Taper Ratio
C_tip_hs = TR_hs*C_root_hs; %(m)Tip chord
b_2_hs = 21.17/2; %(m) Span
LE_sweep_hs = 27.17; %(deg)Leading edge sweep

C_root_vs = 10; %(m)Root chord
TR_vs = 0.5; %Taper Ratio
C_tip_vs = TR_vs*C_root_vs; %(m)Tip chord
b_2_vs = 9.0; %(m) Span
LE_sweep_vs = 38.25; %(deg)Leading edge sweep

sweep_max = atan(((tand(LE_sweep_wing)*b_2_wing)+C_tip_wing*x_c - C_root_wing*x_c)/b_2_wing)*(180/3.14159); %(deg)Sweep angle of max line thickness
sweep_max_hs = atan(((tand(LE_sweep_hs)*b_2_hs)+C_tip_hs*x_c_hs - C_root_hs*x_c_hs)/b_2_hs)*(180/3.14159); %(deg)Sweep angle of max line of thickness horizontal stabilizer
sweep_max_vs = atan(((tand(LE_sweep_vs)*b_2_vs)+C_tip_vs*x_c_vs - C_root_vs*x_c_vs)/b_2_vs)*(180/3.14159); %(deg)Sweep angle of max line of thickness vertical stabilizer

S_wetwing = 866.368; %(m^2)Wetted area of wing assuming 8.1% of total wing wetted area is convered by fuselage

S_weths = 193.664; %(m^2)Wetted area of horizontal stabilizer
S_wetvs = 146.711; %(m^2)Wetted area of vertical stabilizer

        S_wetcocktail = 569.8324096;%m^2            %Constant wetted area of tail section of fuselage and cockpit                              
        L_cocktail = 23.95;%m                       %Consant length of cockpit and tail section
        L_cabin = L_fus - L_cocktail;%m             %Length of cabin
        S_wetcabin = 2*pi*(D_fus/2)*L_cabin;%m^2    %Wetted area of cabin
        S_wetfuse = S_wetcabin + S_wetcocktail;%m^2 %Wetted area of fuselage
        
S_wetnace = 194.0023; %(m^2)Wetted area of nacelles

v_t = 0; %(m/s)Velocity at takeoff
v_c = 0; %(m/s)Velocity during cruise
v_l = 0; %(m/s)Velocity at landing


[CD0, K, C_Lmax] = Drag_Polar(c_f, Swet_Sref, A, e);    %Get Preliminary Drag Polar results
[W_f,v_t,v_c,v_l] = Fuel_Weight(CD0, K, C_Lmax, W0_guess, T0_guess, S_ref); %Get takeoff, cruise and landing speed.

A_max = 23.33; %(m^2)Maximum area of fuselage
u = .124529; %(rad)Refer to page 18 of Aerodynamic Refinement slides
S_ref = 420; %(m^2)Reference area of wing
Q = 1.1; %Interference factor for nacelle on wing slide 16 of aerodynamic refinement slides

%Wing (Takeoff, Cruise, and Landing)
[Cf_lam_t, Cf_tur_t, Cf_lam_c, Cf_tur_c, Cf_lam_l, Cf_tur_l] = SkinFrictionCoeffecient(c_bar,v_t,v_c,v_l);
[FF_wing_t,FF_wing_c,FF_wing_l, FF_fuse, FF_nace] = FormFactors(t_c, x_c, sweep_max, v_t, v_c, v_l,L_fus, D_fus, L_nace,D_nace);
Cd_0_wing_t = ((Cf_lam_t*FF_wing_t*Q*(S_wetwing * 0.10)) + (Cf_tur_t*FF_wing_t*Q*(S_wetwing * 0.90)));
Cd_0_wing_c = ((Cf_lam_c*FF_wing_c*Q*(S_wetwing * 0.10)) + (Cf_tur_c*FF_wing_c*Q*(S_wetwing * 0.90)));
Cd_0_wing_l = ((Cf_lam_l*FF_wing_l*Q*(S_wetwing * 0.10)) + (Cf_tur_l*FF_wing_l*Q*(S_wetwing * 0.90)));

%Fuselage (Takeoff, Cruise, and Landing)
[Cf_lam_t, Cf_tur_t, Cf_lam_c, Cf_tur_c, Cf_lam_l, Cf_tur_l] = SkinFrictionCoeffecient(L_fus,v_t,v_c,v_l);
Cd_0_fuse_t = ((Cf_lam_t*FF_fuse*1*(S_wetfuse * 0.05)) + (Cf_tur_t*FF_fuse*1*(S_wetfuse * 0.95)));
Cd_0_fuse_c = ((Cf_lam_c*FF_fuse*1*(S_wetfuse * 0.05)) + (Cf_tur_c*FF_fuse*1*(S_wetfuse * 0.95)));
Cd_0_fuse_l = ((Cf_lam_l*FF_fuse*1*(S_wetfuse * 0.05)) + (Cf_tur_l*FF_fuse*1*(S_wetfuse * 0.95)));

%Horizontal Stabilizer (Takeoff, Cruise, and Landing)
[FF_hs_t,FF_hs_c,FF_hs_l, FF_fuse, FF_nace] = FormFactors(t_c_hs, x_c_hs, sweep_max_hs, v_t, v_c, v_l,L_fus, D_fus, L_nace,D_nace);
[Cf_lam_t, Cf_tur_t, Cf_lam_c, Cf_tur_c, Cf_lam_l, Cf_tur_l] = SkinFrictionCoeffecient(c_bar_hs,v_t,v_c,v_l);
Cd_0_hs_t = ((Cf_lam_t*FF_hs_t*1.05*(S_weths * 0.10)) + (Cf_tur_t*FF_hs_t*1.05*(S_weths * 0.90)));
Cd_0_hs_c = ((Cf_lam_c*FF_hs_c*1.05*(S_weths * 0.10)) + (Cf_tur_c*FF_hs_c*1.05*(S_weths * 0.90)));
Cd_0_hs_l = ((Cf_lam_l*FF_hs_l*1.05*(S_weths * 0.10)) + (Cf_tur_l*FF_hs_l*1.05*(S_weths * 0.90)));

%Verticle Stabilizer (Takeoff, Cruise, and Landing)
[FF_vs_t,FF_vs_c,FF_vs_l, FF_fuse, FF_nace] = FormFactors(t_c_vs, x_c_vs, sweep_max_vs, v_t, v_c, v_l,L_fus, D_fus, L_nace,D_nace);
[Cf_lam_t, Cf_tur_t, Cf_lam_c, Cf_tur_c, Cf_lam_l, Cf_tur_l] = SkinFrictionCoeffecient(c_bar_vs,v_t,v_c,v_l);
Cd_0_vs_t = ((Cf_lam_t*FF_vs_t*1.05*(S_wetvs * 0.10)) + (Cf_tur_t*FF_vs_t*1.05*(S_wetvs * 0.90)));
Cd_0_vs_c = ((Cf_lam_c*FF_vs_c*1.05*(S_wetvs * 0.10)) + (Cf_tur_c*FF_vs_c*1.05*(S_wetvs * 0.90)));
Cd_0_vs_l = ((Cf_lam_l*FF_vs_l*1.05*(S_wetvs * 0.10)) + (Cf_tur_l*FF_vs_l*1.05*(S_wetvs * 0.90)));

%Nacelles (Takeoff, Cruise, and Landing)
[Cf_lam_t, Cf_tur_t, Cf_lam_c, Cf_tur_c, Cf_lam_l, Cf_tur_l] = SkinFrictionCoeffecient(L_nace,v_t,v_c,v_l);
Cd_0_nace_t = ((Cf_lam_t*FF_nace*1.3*(S_wetnace * 0.05)) + (Cf_tur_t*FF_nace*1*(S_wetnace * 0.95)));
Cd_0_nace_c = ((Cf_lam_c*FF_nace*1.3*(S_wetnace * 0.05)) + (Cf_tur_c*FF_nace*1*(S_wetnace * 0.95)));
Cd_0_nace_l = ((Cf_lam_l*FF_nace*1.3*(S_wetnace * 0.05)) + (Cf_tur_l*FF_nace*1*(S_wetnace * 0.95)));


%Missing Form Drag
    %Fuselage Upsweep
    D_q_fuse = 3.83 * u^2.5 *A_max;
    Cd_gear = .015; %Only on takeoff and landing
    Cd_mc = D_q_fuse/S_ref; %Cruise
    Cd_mtl = (D_q_fuse/S_ref + Cd_gear); %Takeoff and landing

%Cruise Wave Drag for Zero-Lift
M_dd = (0.95/cosd(c_4_sweep_wing))-(t_c/(cosd(c_4_sweep_wing)^2)); %Drag Divergent Mach Number
M_crit = M_dd - (0.1/80)^(1/3);  %Critical Mach Number
Cd_wave = 20*(M - M_crit)^4;
    
%Takeoff Parasitic Drag
Cd_0_t = ((Cd_0_wing_t + Cd_0_fuse_t + Cd_0_hs_t + Cd_0_vs_t + Cd_0_nace_t)/S_ref) + Cd_mtl;

%Cruise Parasitic Drag
Cd_0_c = ((Cd_0_wing_c + Cd_0_fuse_c + Cd_0_hs_c + Cd_0_vs_c + Cd_0_nace_c)/S_ref) + Cd_mc + Cd_wave;

%Landing Parasitic Drag
Cd_0_l = ((Cd_0_wing_l + Cd_0_fuse_l + Cd_0_hs_l + Cd_0_vs_l + Cd_0_nace_l)/S_ref) + Cd_mtl;



%Leak and Protuberance Drag Included for total drag
Cd_0_t = Cd_0_t + (Cd_0_t*0.02);    %Takeoff Total Drag
Cd_0_c = Cd_0_c + (Cd_0_c*0.02);    %Cruise Total Drag
Cd_0_l = Cd_0_l + (Cd_0_l*0.02);    %Landing Total Drag









