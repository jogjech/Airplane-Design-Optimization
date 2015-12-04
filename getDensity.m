function [rho] = getDensity(h)
%[rho] = getDensity(h), in SI unit
format long;
if h >= 0 && h <= 11000
    t = 15 - 0.0065* h;
    p = 101325*((t+273)/(288))^-(9.81/287/-0.0065);
    rho=p/287/(t+273);
else
    t = -56.5;
    p = 22590*exp(-(9.81/287/(-56.5+273))*(h-11000));
    rho=p/287/(t+273);
end
end
