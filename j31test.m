% Test 

header = {'Time (s)', '\phi (deg)', '\theta (deg)', '\psi (deg)', ...
    'p (deg/s)', 'q (deg/s)', 'r (deg/s)', 'a_x (m/s^2)', 'a_y (m/s^2)',...
    'a_z (m/s^2)', 'V_e (m/s)', 'H_p (m)', 'T (C)', 'P (Pa)', ...
    '\delta_a (deg)', '\delta_e (deg)', '\delta_r (deg)', '\tau (%)'};
%% Import Data

temp = importdata(filename);

time = temp.data(:,1);
phi = deg2rad(temp.data(:,2));
theta = deg2rad(temp.data(:,3));
psi = deg2rad(temp.data(:,4));
p = deg2rad(temp.data(:,5));
q = deg2rad(temp.data(:,6));
r = deg2rad(temp.data(:,7));
a_x = temp.data(:,8);
a_y = temp.data(:,9);
a_z = temp.data(:,10);
airspeed = temp.data(:,11);
Hp = temp.data(:,12);
Temp = temp.data(:,13);
Pressure = temp.data(:,14);
aileron = deg2rad(temp.data(:,15));
elevator = deg2rad(temp.data(:,16));
rudder = deg2rad(temp.data(:,17));
throttle = temp.data(:,18);

AoA = theta;
beta = psi;
%aileron = zeros(numel(time),1);
u = (airspeed - mean(airspeed)).*cos(AoA).*cos(beta);
v = (airspeed - mean(airspeed)).*sin(beta);
w = (airspeed - mean(airspeed)).*sin(AoA).*cos(beta);

clear temp

dt = 0.02;
g = 9.81;
%% Data Structure

if strcmp(type, 'SPPO')
    %% Create the data structure

    inputs = zeros(1,16);
    inputs(1,:) = '\delta_e (rad)  ';
    inputs(2,:) = '\tau (%)        ';
    inputs = char(inputs);
    npts = numel(time);
    outputs = zeros(3,11);
    outputs(1,:) = 'w (m/s)    ';
    outputs(2,:) = 'q (rad/s)  ';
    outputs = char(outputs);
    pnames = {'Zw', 'Zq', 'Zde', 'Zt', 'Mw', 'Mq', 'Mde', 'Mt'};
    p0 = [-9.2 8.92 -6.616 0 -13.06 -8.467 -69.63 0];
    p0 = [0 0 0 0 0 0 0 0];
    states = zeros(2,11);
    states(1,:) = 'w (m/s)    ';
    states(2,:) = 'q (rad/s)  ';
    states = char(states);
    t = time;
    z = [w, q];
    %throttle = zeros(numel(aileron),1);
    u = [elevator, throttle];
    
elseif strcmp(type, 'long')
    %% Create the data structure

    inputs = zeros(2,16);
    inputs(1,:) = '\delta_e (rad)  ';
    inputs(2,:) = '\tau (%)        ';
    inputs = char(inputs);
    npts = numel(time);
    outputs = zeros(4,12);
    outputs(1,:) = 'u (m/s)     ';
    outputs(2,:) = 'w (m/s)     ';
    outputs(3,:) = 'q (rad/s)   ';
    outputs(4,:) = '\theta (rad)';
    outputs = char(outputs);
    pnames = {'Xu', 'Xw', 'Xq', 'Xde', 'Xt', 'Zu', 'Ztheta', 'Mu'};
    p0 = [-0.066 0.02625 -0.2728 -1.951 0 -1.427 0 -0.5861];
    %p0 = zeros(8,1);
    states = zeros(4,12);
    states(1,:) = 'u (m/s)     ';
    states(2,:) = 'w (m/s)     ';
    states(3,:) = 'q (rad/s)   ';
    states(4,:) = '\theta (rad)';
    states = char(states);
    t = time;
    z = [u, w, q, theta];
    throttle = 70*ones(numel(aileron),1);
    u = [elevator, throttle];

elseif strcmp(type, 'dutch')
    %% Create the data structure

    inputs = zeros(2,16);
    inputs(1,:) = '\delta_a (rad)  ';
    inputs(2,:) = '\delta_r (rad)  ';
    inputs = char(inputs);
    npts = numel(time);
    outputs = zeros(3,11);
    outputs(1,:) = 'v (m/s)    ';
    outputs(2,:) = 'r (rad/s)  ';
    outputs = char(outputs);
    pnames = {'Yv', 'Yr', 'Yda', 'Ydr', 'Nv', 'Nr', 'Nda', 'Ndr'};
    p0 = [0.048 -9.97 1.759 5.064 2.19 -1.84 -21.35 -10.15];
    %p0 = zeros(8,1);
    states = zeros(2,11);
    states(1,:) = 'v (m/s)    ';
    states(2,:) = 'r (rad/s)  ';
    states = char(states);
    t = time;
    z = [v, r];
    aileron = zeros(numel(aileron),1);
    u = [aileron, rudder];
elseif strcmp(type, 'roll')
    %% Create the data structure

    inputs = zeros(2,16);
    inputs(1,:) = '\delta_a (rad)  ';
    inputs(2,:) = '\delta_r (rad)  ';
    inputs = char(inputs);
    npts = numel(time);
    outputs = zeros(3,11);
    outputs(1,:) = 'p (rad/s)  ';
    outputs(2,:) = '\phi (rad) ';
    outputs = char(outputs);
    pnames = {'Lp', 'Lda', 'Ldr'};
    p0 = [-31.25 4 -217.2];
    states = zeros(2,11);
    states(1,:) = 'p (rad/s)  ';
    states(2,:) = '\phi (rad) ';
    states = char(states);
    t = time;
    z = [p, phi];
    rudder = zeros(numel(aileron),1);
    u = [aileron, rudder];
    elseif strcmp(type, 'lat')
    %% Create the data structure
    
    inputs = zeros(2,16);
    inputs(1,:) = '\delta_a (rad)  ';
    inputs(2,:) = '\delta_r (rad)  ';
    inputs = char(inputs);
    npts = numel(time);
    outputs = zeros(5,11);
    outputs(1,:) = 'v (m/s)    ';
    outputs(2,:) = 'p (rad/s)  ';
    outputs(3,:) = 'r (rad/s)  ';
    outputs(4,:) = '\phi (rad) ';
    outputs(5,:) = '\psi (rad) ';
    outputs = char(outputs);
    pnames = {'Yp', 'Lv', 'Lr', 'Np'};
    p0 = [0.5372 -16.57 7.226 1];
    %p0 = [0 0 0 0];
    states = zeros(5,11);
    states(1,:) = 'v (m/s)    ';
    states(2,:) = 'p (rad/s)  ';
    states(3,:) = 'r (rad/s)  ';
    states(4,:) = '\phi (rad) ';
    states(5,:) = '\psi (rad) ';
    states = char(states);
    t = time;
    z = [v, p, r, phi, psi];
    rudder = zeros(numel(aileron),1);
    u = [aileron, rudder];
end

