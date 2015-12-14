function T_W = Design_Diagram(W0_Sref,CD0,K,CLmax,M,Index)
%           /\                    /\                %W0_Sref Wingloading
%          /  \                  /  \               %CD0     Inital Drag Coefficience 
%         /    \                /    \              %K       K~
%        /      \              /      \             %CLmax   Max Lift Coefficience 
%       /        \            /        \            %SFL     Total Runway Length
%      /          \          /          \           %M       Mach Number
%     /            \        /            \          %Index   1:Takeoff Line
%    /              \      /              \         %        2-7: CLimbing Lines
%   /                \    /                \        %        8:Cruise
%  /                  \  /                  \       %        9:Ceiling
% /                    \/                    \      %        10:Maneuver
InputFile;                                        %Call InputFile
% Some important Constants
BFL = s_FL;
W0_Sref = W0_Sref*0.02088;                        %WingLoad lbf/ft^2
aCruise = 973.1;                                  %ft/s, air speed at 35000 ft
ftPerNm = 6076.1;                                 %convert coefficient from ft to m
secsPerHr = 3600;                                 %convert coefficient from hour to second
KTF=1.68781;                                      %convert coefficient from knot to ft/s
rho_TO = 2.239e-3;                                %slug/ft^3, air density at Newwark altitude
rho_SL = 2.377e-3;                                %slug/ft^3, air density at sea level
rho_L = 2.309e-3;                                 %slug/ft^3, air density at Singapore
rho_CR = 7.38e-4;                                 %slug/ft^3, air density at 35000ft
V_c = M*aCruise/ftPerNm*secsPerHr;                %Cruise Speed 
nz=1.5;                                           %Load factor
WingLoad = W0_Sref;
TW=zeros(1,10);
CL_maxTO=CLmax/1.18;
CL_maxL=CL_maxTO/0.8;
CL_maxCr=1.8;
KTF=1.68781;
V_c=KTF*V_c;                                    %ft/s^2

%Takeoff                                       % Length of the Runway
    TW(1)=WingLoad/(BFL/37.5*(rho_TO/rho_SL)*CL_maxTO);
% 
% %Landing 
%     WL_S=(0.6*BFL-1000)/80*(rho_L/rho_SL)*CL_maxL/0.65;
    

%Climbing
    N = 2;                                            %Number of engines
    G=[1.2 0 2.4 1.2 3.2 2.1]*0.01;
    ks=[1.2 1.15 1.2 1.25 1.3 1.5];
    CL_maxClimb=[CL_maxTO CL_maxTO CL_maxTO CL_maxCr CL_maxL 0.85*CL_maxL];
    W_WTO=[1 1 1 1 0.65 0.65];
    CD0_climb = CD0+ [0.010 0.025 0.010 0 0.07 0.07];
    TW_climb=ks.^2./CL_maxClimb.*CD0_climb+CL_maxClimb.*K./(ks.^2)+G;
    TW(2:7)=TW_climb.*W_WTO*(N/(N-1))/0.8;
    
%Cruising          
    q=rho_CR*V_c^2/2;     
    TW(8)=(q./WingLoad)*CD0+(WingLoad/q)*K(4);

%Ceiling
    TW(9)=0.001+2*sqrt(CD0*K(4));
    
%Maneuver
    TW(10)=(q./WingLoad)*CD0+nz^2*(WingLoad/q)*K(4);

%Choose Output    
T_W=TW(Index);
end