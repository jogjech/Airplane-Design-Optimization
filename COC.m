function COST = COC(T,W0,Wf)
%%Constants
T = T * 0.22;
W0 = W0 * 0.22;
Wf = Wf * 0.22;
b_year1 = 1995;
b_year2 = 1989;
b_year3 = 1999;
t_year = 2015;   
n_crew = 4;      %# crew
t_b = 17.83;     %block time [h]
%t_b = 19;     %block time [h]
n_attd = 10;      %# of attd
%Wf = 377030; %fuel weight in lb
P_f = 6;
rho_f = 6.7;   %lb/gallon
R = 8290.435;
IR_a = 0.02;
C_aircraft = 243000000; %does this need to be refined?
FH = t_b;
C_eng = 24000000;
N_eng = 2; %GE 90
R_L = 27.24;

%% Cost crew and attendants
%CEF caLculation
b_CEF1 = 5.17053 + 0.104981 * (b_year1 - 2006);
b_CEF2 = 5.17053 + 0.104981 * (b_year2 - 2006);
b_CEF3 = 5.17053 + 0.104981 * (b_year3 - 2006);
t_CEF = 5.17053 + 0.104981 * (t_year - 2006);
CEF1 = t_CEF/b_CEF1;
CEF2 = t_CEF/b_CEF2;
CEF3 = t_CEF/b_CEF3;
K = 6.5;
AF = 1.6;
%Crew
C_crew = n_crew*(440+0.532*(W0/1000))*CEF1*t_b;
%C_crew = AF * (K*(W0)^0.4*t_b)*CEF3;
%Attendants
C_attd = 60*n_attd*(CEF1)*(t_b);

%% Fuel and Oil
% Fuel (JP-4)
C_fuel = 1.02*Wf*P_f/rho_f;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Oil
%C_oil = 1.02*W_oil*P_oil/rho_oil;

%% Airport and Navigation Fees
%Airport fees
C_airport = 1.5*((W0-Wf)/1000)*CEF1; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Navigation fees
C_navigation = 0.5*CEF2*(1.852*R/t_b)*sqrt(0.00045359237*W0/50);

%% Insurance
U_annual = 1.5*10^3*(3.4546*t_b+2.994-(12.289*t_b^2-5.6626*t_b+8.964)^0.5);
C_insurance = (IR_a*C_aircraft/U_annual)*t_b;

%% Aircraft Maintenance
mc_FH = 3.3*(C_aircraft/10^6)+10.2+(58*C_eng/10^6-19)*N_eng;
C_maintenance = mc_FH*17.83;
%% Engine Maintenance
C_ML = (0.645+(0.05*T/10^4))*(0.566+0.434/t_b)*R_L;
C_MM = (25+(18*T/10^4))*(0.62 +0.38/t_b)*CEF1;
C_enginemaintenance = N_eng*(C_ML+C_MM)*t_b;
% %% FInancing
% C_unit = C_aircraft;
% n = 20;
% pf = 0.01;
% qf = 1 + pf;
% Rf = (1/n)*(n*pf*qf^n/(qf^n-1)-1);
% C_financial = (Rf*C_unit/U_annual)*t_b;
COST = C_fuel+C_enginemaintenance+C_maintenance+C_navigation+C_airport+C_crew+C_attd;
end