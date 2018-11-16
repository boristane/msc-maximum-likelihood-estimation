function [raw] = PX4RawReading(fileName) 
%PX4RAWREADING reads the data from the .mat file exported by Mission
%Planer and writes it in a .csv file.
%
%   FILENAME >> The name of the file to read
%   BASENAME >> Basename of the .csv file
%   RAW >> Structure of the Raw Data
%
%   [RAW] = ftReading(FILENAME, BASENAME) 
%
% Original code by Boris Tane : 17 June 2015
% Last modified by Boris Tane : 07 July 2015

load(fileName);

%%Import Attitudes
raw.att.time = (ATT(:,2)-ATT(1,2))/1000;            % seconds (s)                     
raw.att.phi = rad2deg(ATT(:,4)/100);                             % degrees (°)
raw.att.theta = rad2deg(ATT(:,6)/100);                           % degrees (°)
raw.att.psi = rad2deg(ATT(:,8)/100);                             % degrees (°)

%%Import Rotational Rates
raw.rate.time = (IMU(:,2)-IMU(1,2))/1000;            % seconds (s) 
raw.rate.p = IMU(:,3);                                   % deg/second (°/s) 
raw.rate.q = IMU(:,4);                                   % deg/second (°/s) 
raw.rate.r = IMU(:,5);                                   % deg/second (°/s) 

%%Import Accelerations
raw.acc.time = (IMU(:,2)-IMU(1,2))/1000;            % seconds (s) 
raw.acc.a_x = IMU(:,6);                             % m/second^2 (m/s^2) 
raw.acc.a_y = IMU(:,7);                             % m/second^2 (m/s^2) 
raw.acc.a_z = IMU(:,8);                             % m/second^2 (m/s^2) 

%%Import Air Data
raw.air.time = (ARSP(2:end,2)-ARSP(2,2))/1000;          % seconds (s) 
raw.air.airspeed = ARSP(2:end,3);                       % metre/second (m/s)
temp = (BARO(:,2)-BARO(1,2))/1000;
raw.air.Hp = BARO(:,3);
raw.air.Temp = BARO(:,5);                           % Degree Celcius (°C)
raw.air.Pressure = BARO(:,4);                       % Pascal (Pa)

%%Import PWM inputs
raw.pwm.time = (RCOU(:,2)-RCOU(1,2))/1000;          % seconds (s) 
raw.pwm.aileron = RCOU(:,3);                            % pwm signal
raw.pwm.elevator = RCOU(:,4);                           % pwm signal
raw.pwm.throttle = RCOU(:,5);                           % pwm signal
raw.pwm.rudder = RCOU(:,6);                             % pwm signal

%% Convert the pwm to angles 

% Coeficients of the linear fit from pwm to deflection angles and throttle
% percentage
aileron = [-0.066 97.86];
elevator = [-0.047 72.55];
throttle = [0.102 -103.02];
rudder = [0.057 -83.40];

raw.controls.time = raw.pwm.time;                                           % seconds (s)
raw.controls.aileron = aileron(1)*raw.pwm.aileron + aileron(2);             % deg (°)
raw.controls.elevator = elevator(1)*raw.pwm.elevator + elevator(2);         % deg (°)
raw.controls.throttle = throttle(1)*raw.pwm.throttle + throttle(2);         % \%
raw.controls.rudder = rudder(1)*raw.pwm.rudder + rudder(2);                 % deg (°)

%% Interpolate the air data, the pwm and the controls as they are at lower frequency

% Air Data
raw.air.airspeed = interp1(raw.air.time, raw.air.airspeed, raw.att.time,'linear','extrap');
raw.air.Hp = interp1(temp, raw.air.Hp, raw.att.time,'linear','extrap');
raw.air.Temp = interp1(temp, raw.air.Temp, raw.att.time,'linear','extrap');
raw.air.Pressure = interp1(temp, raw.air.Pressure, raw.att.time,'linear','extrap');

% PWM inputs
raw.pwm.aileron = interp1(raw.pwm.time, raw.pwm.aileron, raw.att.time,'linear','extrap');
raw.pwm.elevator = interp1(raw.pwm.time, raw.pwm.elevator, raw.att.time,'linear','extrap');
raw.pwm.throttle = interp1(raw.pwm.time, raw.pwm.throttle, raw.att.time,'linear','extrap');
raw.pwm.rudder = interp1(raw.pwm.time, raw.pwm.rudder, raw.att.time,'linear','extrap');

% Controls

raw.controls.aileron = interp1(raw.controls.time, raw.controls.aileron, raw.att.time,'linear','extrap');
raw.controls.elevator = interp1(raw.controls.time, raw.controls.elevator, raw.att.time,'linear','extrap');
raw.controls.throttle = interp1(raw.controls.time, raw.controls.throttle, raw.att.time,'linear','extrap');
raw.controls.rudder = interp1(raw.controls.time, raw.controls.rudder, raw.att.time,'linear','extrap');

% Copy the times for them to all match
raw.air.time = raw.att.time;
raw.pwm.time = raw.att.time;
raw.controls.time = raw.att.time;

%% output the .csv

% Create the header in this order
% Time (s), phi (deg), theta (deg), psi (deg), p (deg/s), q (deg/s), r
% (deg/s), ax (deg/s^2), ay (deg/s^2), az (deg/s^2), Ve (m/s), Hp (m),
% T (C), P (Pa), aileron (deg), elevator (deg), rudder (deg), throttle (%)

% headerline = 'Time (s), phi (deg), theta (deg), psi (deg), p (deg/s), q (deg/s), r (deg/s), ax (m/s^2), ay (m/s^2), az (m/s^2), Ve (m/s), Hp (m), T (C), P (Pa), aileron (deg), elevator (deg), rudder (deg), throttle (percentage) \n';
% fid = fopen(basename, 'w');
% fprintf(fid, headerline);
% fclose(fid);
% 
% A = [raw.att.time, raw.att.phi, raw.att.theta, raw.att.psi, raw.rate.p, raw.rate.q, raw.rate.r, raw.acc.a_x, raw.acc.a_y, raw.acc.a_z, raw.air.airspeed, raw.air.Hp, raw.air.Temp, raw.air.Pressure, raw.controls.aileron, raw.controls.elevator, raw.controls.rudder, raw.controls.throttle];
% dlmwrite(basename, A, '-append', 'precision', '%.6f', 'delimiter', '\t');


