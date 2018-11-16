function [y,x,A,B,C,D] = my_dutch(p,u,t,x0,c)
%
%  TLONSSD  Time-domain longitudinal state-space model file.  
%
%  Usage: [y,x,A,B,C,D] = tlonssd(p,u,t,x0,c,type);
%
%  Description:
%
%    Model file for longitudinal state-space
%    dynamic model in the time domain. 
%
%  Input:
%
%    p = parameter vector.
%    u = input vector or matrix.
%    t = time vector.
%   x0 = initial state vector.
%    c = vector of constants.
%    type = name of the aircraft mode. 
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
%    Author:  Eugene A. Morelli
%    Edited by: Boris Tane
%
%    History:  
%      11 May 1995 - Created and debugged, EAM.
%      03 Feb 2006 - Changed c(1) definition, EAM.
%      04 Jul 2015 - Included other modes than the longitudinal
%
%  Copyright (C) 2006  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%

%
%  Longitudinal short period approximation.
%


    % x = [v r]'  u = [aileron rudder]'   y = [v r]'  
        A=[p(1),p(2);...
           p(5),p(6)];
        B=[p(3),p(4);...
           p(7),p(8)];
        [ns,ni]=size(B);
        C=eye(2,2);
        [no,ns]=size(C);
        D=zeros(no,ni); 
[y,x]=lsims(A,B,C,D,u,t,x0);    
           
return
