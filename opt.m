%Optimization



%X = ['S' 'AR' 'TR' 'sweep']

fun = @optfun;
x0 = [450,9,0.15,35];
lb = [300 7 0.1 30];
ub = [1000 11 0.2 40];

S = 100:500;
A = 9;
lamda = 0.15;
Sweep_LE = 35;

for i = 1:length(S)
    InputFile
    [t0, w0, wf] = T0_iteration( 0.25, W0_guess ,S(i),1,A,lamda,Sweep_LE);
    cost(i) = COC(t0, w0, wf);
    MTOW(i) = w0;
%     if (t0 >   9.72e+05)
%         cost(i) = 0;
%     end
end
figure(1)
subplot(4,2,1)
plot(S,cost,'LineWidth',2)
xlabel('S_{ref} [m^2]')
ylabel('cost [US dollar]')
title('S_{ref} Trade Study')
subplot(4,2,2)
plot(S,MTOW,'LineWidth',2)
xlabel('S_{ref} [m^2]')
ylabel('MTOW [kg]')
title('S_{ref} Trade Study')
%[x,fval] = patternsearch(fun,x0,[],[],[],[],lb,ub);
S = 468.23;
A = 5:0.2:20;
lamda = 0.15;
Sweep_LE = 35;

for i = 1:length(A)
    InputFile
    [t0, w0, wf] = T0_iteration( 0.25, W0_guess ,S,1,A(i),lamda,Sweep_LE);
    cost2(i) = COC(t0, w0, wf);
    MTOW2(i) = w0;
%     if (t0 >   9.72e+05)
%         cost2(i) = 0;
%     end
end
subplot(4,2,3)
plot(A,cost2,'LineWidth',2)
xlabel('Aspect Ratio')
ylabel('cost [US dollar]')
title('Aspect Ratio Trade Study')
subplot(4,2,4)
plot(A,MTOW2,'LineWidth',2)
xlabel('Aspect Ratio')
ylabel('MTOW [kg]')
title('Aspect Ratio Trade Study')

S = 468.23;
A = 9;
lamda = 0.15;
Sweep_LE = 25:40;

for i = 1:length(Sweep_LE)
    InputFile
    [t0, w0, wf] = T0_iteration( 0.25, W0_guess ,S,1,A,lamda,Sweep_LE(i));
    cost3(i) = COC(t0, w0, wf);
    MTOW3(i) = w0;
%     if (t0 >   9.72e+05)
%         cost2(i) = 0;
%     end
end
subplot(4,2,7)
plot(Sweep_LE,cost3,'LineWidth',2)
xlabel('Leading Edge Sweep Angle [deg]')
ylabel('cost [US dollar]')
title('Sweep Angle Trade Study')

subplot(4,2,8)
plot(Sweep_LE,MTOW3,'LineWidth',2)
xlabel('Leading Edge Sweep Angle [deg]')
ylabel('MTOW [kg]')
title('Sweep Angle Trade Study')
S = 468.23;
A = 9;
lamda = 0.1:0.001:0.2;
Sweep_LE = 35;

for i = 1:length(lamda)
    InputFile
    [t0, w0, wf] = T0_iteration( 0.25, W0_guess ,S,1,A,lamda(i),Sweep_LE);
    cost4(i) = COC(t0, w0, wf);
    MTOW4(i) = w0;
%     if (t0 >   9.72e+05)
%         cost2(i) = 0;
%     end
end
subplot(4,2,5)
plot(lamda,cost4,'LineWidth',2)
xlabel('Taper Ratio')
ylabel('cost [US dollar]')
title('Taper Ratio Trade Study')
subplot(4,2,6)
plot(lamda,MTOW4,'LineWidth',2)
xlabel('Taper Ratio')
ylabel('MTOW [kg]')
title('Taper Ratio Trade Study')