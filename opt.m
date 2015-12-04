%Optimization



%X = ['S' 'AR' 'TR' 'sweep']

fun = @optfun;
x0 = [500,9,0.15,35];
% lb = [300 7 0.1 30];
% ub = [1000 11 0.2 40];
% [x,fval] = fmincon(fun,x0,[],[],[],[],lb,ub);
x = patternsearch(fun,x0)