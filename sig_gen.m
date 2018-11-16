%Signal Generation - sig_gen.m

close all;
clear all;
clc

shorttime = 0:0.01:10;
%% Longitudinal Signals

%sppo
[u_sppo, time] = gensig('square', 1, shorttime(end), 0.01);
hh = find(time==1);
hh1 = find(time==1.5);
u_sppo(1:hh) = 0;
u_sppo(hh:hh1) = 1;
u_sppo(hh1:end) = 0;



%phugoid
[u_phugoid, time] = gensig('square', 4, shorttime(end), 0.01);
hh = find(time==1);
hh1 = find(time==3);
u_phugoid(1:hh) = 0;
u_phugoid(hh:hh1) = 1;
u_phugoid(hh1:end) = 0;



%3-2-1-1
[u_custom, time] = gensig('square', 2, shorttime(end), 0.01);
gg = find(time==1);
hh1 = find(time==4);
hh2 = find(time==6);
hh3 = find(time==7);
hh4 = find(time==8);

u_custom(gg:hh1) = 1;
u_custom(hh1:hh2) = -1;
u_custom(hh2:hh3) = 1;
u_custom(hh3:hh4) = -1;
u_custom(hh4:end) = 0;


t = time;
FgH=figure('Units','normalized',...
           'Position',[.453 .221 .542 .685]);
%
%  Axes for plotting.
%
AxH=axes('Box','on',...
         'Units','normalized',...
         'Position',[.15 .15 .9 .8],...
         'XGrid','on', 'YGrid','on');
subplot(3,1,1),plot(t,u_sppo, 'Linewidth',1.5),grid on;ylabel('\delta_e (deg)');
axis([0 10 -2 2]); title('{\bf SPPO}');
subplot(3,1,2),plot(t,u_phugoid, 'Linewidth',1.5),grid on;ylabel('\delta_e (deg)');
axis([0 10 -2 2]); title('{\bf Phugoid}');
subplot(3,1,3),plot(t,u_custom, 'Linewidth',1.5),grid on;ylabel('\delta_e (deg)'),xlabel('Time (s)');
axis([0 10 -2 2]); title('{\bf 3-2-1-1}');

%% Lateral Signals

%dutch
[u_dutch, time] = gensig('square', 0.5, shorttime(end), 0.01);
hh = find(time==1);
hh1 = find(time==3);
aa = find(time==1.5);
aa1 = find(time==1.75);
aa2 = find(time==2);
aa3 = find(time==2.25);
aa4 = find(time==2.5);
aa5 = find(time==2.75);
u_dutch(1:hh) = 0;
u_dutch(hh1:end) = 0;
u_dutch(aa:aa1) = -1;
u_dutch(aa2:aa3) = -1;
u_dutch(aa4:aa5) = -1;


%roll
[u_roll, time] = gensig('square', 4, shorttime(end), 0.01);
hh = find(time==1);
hh1 = find(time==2);
u_roll(1:hh) = 0;
u_roll(hh:hh1) = 1;
u_roll(hh1:end) = 0;



%3-2-1-1
[u_custom, time] = gensig('square', 2, shorttime(end), 0.01);
gg = find(time==1);
hh1 = find(time==4);
hh2 = find(time==6);
hh3 = find(time==7);
hh4 = find(time==8);

u_custom(gg:hh1) = 1;
u_custom(hh1:hh2) = -1;
u_custom(hh2:hh3) = 1;
u_custom(hh3:hh4) = -1;
u_custom(hh4:end) = 0;


t = time;
FgH=figure('Units','normalized',...
           'Position',[.453 .221 .542 .685]);
%
%  Axes for plotting.
%
AxH=axes('Box','on',...
         'Units','normalized',...
         'Position',[.15 .15 .9 .8],...
         'XGrid','on', 'YGrid','on');
subplot(3,1,1),plot(t,u_dutch, 'Linewidth',1.5),grid on;ylabel('\delta_r (deg)');
axis([0 10 -2 2]); title('{\bf Dutch Roll}');
subplot(3,1,2),plot(t,u_roll, 'Linewidth',1.5),grid on;ylabel('\delta_a (deg)');
axis([0 10 -2 2]); title('{\bf Roll Mode}');
subplot(3,1,3),plot(t,u_custom, 'Linewidth',1.5),grid on;ylabel('\delta_a (deg)'),xlabel('Time (s)');
axis([0 10 -2 2]); title('{\bf 3-2-1-1}');
