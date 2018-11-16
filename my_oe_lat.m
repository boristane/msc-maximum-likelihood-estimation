%
%  OE_LON_DEMO  Demonstrates longitudinal output-error parameter estimation in the time domain. 
%
%  Usage: oe_lon_demo;
%
%  Description:
%
%    Demonstrates output-error maximum likelihood 
%    parameter estimation for linearized  
%    longitudinal dynamics using flight test data
%    from the NASA Twin Otter aircraft.  
%
%  Input:
%
%    None
%
%  Output:
%
%    graphics:
%      2D plots
%

%
%    Calls:
%      xsmep.m
%      deriv.m
%      oe.m
%      model_disp.m
%      tlonssd.m
%      m_colores.m
%      damps.m
%
%    Author:  Eugene A. Morelli
%    Edited by: Boris Tane
%
%    History:  
%      19 Jan 2001 - Created and debugged, EAM.
%      27 Aug 2002 - Updated and corrected, EAM.
%      04 Jul 2015 - 
%
%  Copyright (C) 2006  Eugene A. Morelli
%
%  This program carries no warranty, not even the implied 
%  warranty of merchantability or fitness for a particular purpose.  
%
%
fprintf('\n\n Output Error Maximum Likelihood')
fprintf('\n estimation, the variables are : \n')
states,
outputs,
inputs,
%
%  Assemble the inputs and outputs.
%
% % % % % % z=[fdata(:,[4,6])*pi/180,fdata(:,13)];
% % % % % % u=[fdata(:,14)*pi/180,ones(length(t),1)];
%
%  Set up figure window.
%
% FgH=figure('Units','normalized',...
%            'Position',[.453 .221 .542 .685],...
%            'Color',[0.8 0.8 0.8],...
%            'Name','Output-Error Parameter Estimation',...
%            'NumberTitle','off');

fprintf('\n\n\n Initial conditions are determined from smoothed ')
fprintf('\n measured values, using program xsmep.m: \n ')
xs=xsmep(z(:,[1:size(states,1)]),2.0,dt);
x0=xs(1,:)';
fprintf('\n\n Now estimate the model parameters ')
fprintf('\n using program oe.m.  ')
fprintf('\n\n Starting output error parameter estimation program oe ...\n')
dsname = my_ss(type);
[y,p,crb,rr,itercnt]=oe(dsname,p0,u,t,x0,c,z);
serr=sqrt(diag(crb));
perr=zeros(numel(p),1);
  for j=1:numel(p),
    if p(j)~=0
      perr(j)=100*serr(j)./abs(p(j));
    else
      perr(j)=serr(j);
    end
  end

%
%  Show modeling results, omitting 
%  the bias parameters.
%%
clc
diary('example')
diary on;
fprintf('\n\n Number of iterations: %i', itercnt);
fprintf('\n\n The Cramer Rao bound matrix is: ')
crb
indx=1:numel(p0);
fprintf('\n\n The parameter estimation results are:  ')
model_disp(p(indx),serr(indx),[],[],pnames(indx));



fprintf('\n\n Identified system matrices A and B are: \n')
[y,x,A,B,C,D] = eval([dsname,'(p,u,t,x0,c)']);
A,B,
fprintf('\n\n Eigenvalues of A are: \n')
damp(A)
clear ans;
clear *H;
fprintf('\n\n\n End of demonstration \n\n')
diary off;
console_text=fileread('example');
set(handles.console,'Max',size(console_text,2));
set(handles.console,'string',console_text);
clear console_text;
delete('example');

return
