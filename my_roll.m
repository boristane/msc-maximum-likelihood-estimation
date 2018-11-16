function [y,x,A,B,C,D] = my_roll(p,u,t,x0,c)
%
%  MY_ROLL  Time-domain roll mode state-space model file.  
%
%  Usage: [y,x,A,B,C,D] = tlonssd(p,u,t,x0,c,type);
%
%  Description:
%
%    Model file for roll mode state-space
%    dynamic model in the timen. 
%
%  Input:
%
%    p = parameter vector.
%    u = input vector or matrix.
%    t = time vector.
%   x0 = initial state vector.
%    c = vector of constants.
%
%  Output:
%
%         y = model output vector or matrix time history.
%         x = model state vector or matrix time history.
%   A,B,C,D = system matrices.
%
%

%
%    Calls:
%      lsims.m
%
%    Author:  Boris Tane
%
%    Crated on 20 June 2015
%    Last modified on 20 June 2015
%
%


    % x = [p phi]'  u = [aileron rudder]'   y = [p phi]'  
        A=[p(1),0;...
           1,0];
        B=[p(2),p(3);...
           0,0];
        [ns,ni]=size(B);
        C=eye(2,2);
        [no,ns]=size(C);
        D=zeros(no,ni);
[y,x]=lsims(A,B,C,D,u,t,x0);
        
           
return
