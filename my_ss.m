function dsname = my_ss(type)
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

%
%  Longitudinal short period approximation.
%

if strcmp(type, 'SPPO')  % SPPO state space representation 
    dsname = 'my_sppo';
elseif strcmp(type, 'long')  % Global Longitudinal dynamics state space representation
    dsname = 'my_long';
elseif strcmp(type, 'dutch')  % Dutch Roll state space representation
    dsname = 'my_dutch';
elseif strcmp(type, 'roll')  % Roll Mode state space representation
    dsname = 'my_roll';
elseif strcmp(type, 'lat')  % Global Lateral state space representation
    dsname = 'my_lat';
end
        
           
return
