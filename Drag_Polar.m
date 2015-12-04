function [CD0, K, C_Lmax] = Drag_Polar(c_f, Swet_Sref, A, e)
%[CD0, K, C_Lmax] = Drag_Polar(c_f, Swet_Sref, A, e)
C_Lmax = 2.3;
CD0 =  Swet_Sref* c_f;
K = 1./(pi*A*e);

