function [Cf_lam_t, Cf_tur_t, Cf_lam_c, Cf_tur_c, Cf_lam_l, Cf_tur_l] = SkinFrictionCoeffecient(l_char,v_t,v_c,v_l)
%[Cf_lam_t, Cf_tur_t, Cf_lam_c, Cf_tur_c, Cf_lam_l, Cf_tur_l] =
%SkinFrictionCoeffecient(l_char,v_t,v_c,v_l) This function takes in
%velocities at takeoff, cruise, and landing and calculates the laminar and
%turbulant skin friction coeffecients for each phase of flight.

%CONSTANTS FOR SUTHERLANDS EQUATION
b = 1.458 * 10^-6; %kg/(m*s*K^1/2)
S = 110.4; %K

%Constants
gamma = 1.4;
R = 287;    %Gas constant J/(kg * K)

%Takeoff
rho_t = 1.225; %kg/m^3
T_t = 288.15; %K
mu_t = (b*T_t^(3/2))/(T_t+S);  %Sutherland Equation for dynamic viscosity
Re_t = (rho_t * v_t * l_char) / mu_t;   %Reynolds number for takeoff
a_t = (gamma * R * T_t)^0.5;       %Speed of sound for takeoff
M_t = v_t / a_t;                %Mach number at takeoff

    %Laminar Flow
    Cf_lam_t = 1.328/ (Re_t);     %Skin friction coefficient for laminar flow
    
    %Turbulent Flow
    Cf_tur_t = 0.455 / ((log10(Re_t)^2.58)*(1+0.144*M_t)^0.65);  %Skin friction coefficient for turbulent flow
    
    
    
    
%Cruise
rho_c = 0.45920252916; %kg/m^3
T_c = 218.92222; %K
mu_c = (b*T_c^(3/2))/(T_c+S);  %Sutherland Equation for dynamic viscosity
Re_c = (rho_c * v_c * l_char) / mu_c;   %Reynolds number for cruise
a_c = (gamma * R * T_c)^0.5;       %Speed of sound for cruise
M_c = v_c / a_c;                %Mach number at cruise

    %Laminar Flow
    Cf_lam_c = 1.328/ (Re_c);     %Skin friction coefficient for laminar flow
    
    %Turbulent Flow
    Cf_tur_c = 0.455 / ((log10(Re_c)^2.58)*(1+0.144*M_c)^0.65);  %Skin friction coefficient for turbulent flow

%Landing
rho_l = 1.225; %kg/m^3
T_l = 288.15; %K
mu_l = (b*T_l^(3/2))/(T_l+S);  %Sutherland Equation for dynamic viscosity
Re_l = (rho_l * v_l * l_char) / mu_l;   %Reynolds number for landing
a_l = (gamma * R * T_l)^0.5;       %Speed of sound for landing
M_l = v_l / a_l;                %Mach number at landing

    %Laminar Flow
    Cf_lam_l = 1.328/ (Re_l);     %Skin friction coefficient for laminar flow
    
    %Turbulent Flow
    Cf_tur_l = 0.455 / ((log10(Re_l)^2.58)*(1+0.144*M_l)^0.65);  %Skin friction coefficient for turbulent flow
end


