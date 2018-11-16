%scriptname: pixhawk_post_processing.m 
%This scrit is to processs the data from the pixhawk

% Original code by Boris Tane : 10 June 2015
% Last modified by Boris Tane : 17 June 2015

clc;
numFig = 1;

%% Directory Management
disp('Directory Management');
dir.main = '/home/boris/Documents/MScIRP/MLE/PostProcessing';
dir.MATdata = [dir.main '/data'];
mkdir('data');
dir.images = [dir.main '/images'];
mkdir('images');
dir.rawData = [dir.main '/RawData'];
filename = '2015-07-09 15-21-46 3.bin.log-71546.mat';
basename = 'lol';

%% Import Data
movefile('PX4RawReading.m',dir.rawData);
cd(dir.rawData);
[raw] = PX4RawReading(filename);
movefile('PX4RawReading.m',dir.main);
cd(dir.main);

header = {'Time (s)', '\phi (deg)', '\theta (deg)', '\psi (deg)', ...
    'p (deg/s)', 'q (deg/s)', 'r (deg/s)', 'a_x (m/s^2)', 'a_y (m/s^2)',...
    'a_z (m/s^2)', 'V_e (m/s)', 'H_p (m)', 'T (C)', 'P (Pa)', ...
    '\delta_a (deg)', '\delta_e (deg)', '\delta_r (deg)', '\tau (%)'};

A = [raw.att.time, raw.att.phi, raw.att.theta, raw.att.psi, raw.rate.p, ...
    raw.rate.q, raw.rate.r, raw.acc.a_x, raw.acc.a_y, raw.acc.a_z, ...
    raw.air.airspeed, raw.air.Hp, raw.air.Temp, raw.air.Pressure, ...
    raw.controls.aileron, raw.controls.elevator, raw.controls.rudder, ...
    raw.controls.throttle];
%%

figure(numFig)
numFig = numFig + 1;
for ii = 2:4
    subplot(3,1,ii-1)
    plot(A(:,1),A(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 4
        xlabel(['{\it ' header{1} '}']);
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 5:7
    subplot(3,1,ii-4)
    plot(A(:,1),A(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 7
        xlabel(['{\it ' header{1} '}']);
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 8:10
    subplot(3,1,ii-7)
    plot(A(:,1),A(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 10
        xlabel(['{\it ' header{1} '}']);
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 11:14
    subplot(4,1,ii-10)
    plot(A(:,1),A(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 14
        xlabel(['{\it ' header{1} '}']);
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 15:18
    subplot(4,1,ii-14)
    plot(A(:,1),A(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 18
        xlabel(['{\it ' header{1} '}']);
    end
end

%% Filtering 

basename = [basename '_filtered'];
numsamples = numel(A(:,1));
[b a] = butter(2, 0.01, 'low'); % filter

for ii = 2:numel(header)
    X_mags(:,ii) = abs(fft(A(:,ii)));
    X_fil(:,ii) = filter(b,a, A(:,ii));
end
X_fil(:,1) = A(:,1);

figure(numFig)
numFig = numFig + 1;
for ii = 2:4
    subplot(3,1,ii-1)
    plot(A(:,1),A(:,ii),'LineWidth',1.5); hold on;
    plot(A(:,1),X_fil(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 4
        xlabel(['{\it ' header{1} '}']);
        legend('data', 'filtered data');
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 5:7
    subplot(3,1,ii-4)
    plot(A(:,1),A(:,ii),'LineWidth',1.5); hold on;
    plot(A(:,1),X_fil(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 7
        xlabel(['{\it ' header{1} '}']);
        legend('data', 'filtered data');
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 8:10
    subplot(3,1,ii-7)
    plot(A(:,1),A(:,ii),'LineWidth',1.5); hold on;
    plot(A(:,1),X_fil(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 10
        xlabel(['{\it ' header{1} '}']);
        legend('data', 'filtered data');
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 11:14
    subplot(4,1,ii-10)
    plot(A(:,1),A(:,ii),'LineWidth',1.5); hold on;
    plot(A(:,1),X_fil(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 14
        xlabel(['{\it ' header{1} '}']);
        legend('data', 'filtered data');
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 15:18
    subplot(4,1,ii-14)
    plot(A(:,1),A(:,ii),'LineWidth',1.5); hold on;
    plot(A(:,1),X_fil(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 18
        xlabel(['{\it ' header{1} '}']);
        legend('data', 'filtered data');
    end
end

%% .csv write

headerline = 'Time (s), phi (deg), theta (deg), psi (deg), p (deg/s), q (deg/s), r (deg/s), ax (m/s^2), ay (m/s^2), az (m/s^2), Ve (m/s), Hp (m), T (C), P (Pa), aileron (deg), elevator (deg), rudder (deg), throttle (percentage) \n';
fid = fopen([basename '.csv'], 'w');
fprintf(fid, headerline);
fclose(fid);

dlmwrite([basename '.csv'], X_fil, '-append', 'precision', '%.6f', 'delimiter', '\t');

%% Select test

testname = 'SPPO';
interval = [60,90];
time = A(:,1);
hh = find(time==interval(1));
hh1 = find(time==interval(2));

X_test = X_fil(hh:hh1,:); 
X_test(:,1) = X_test(:,1) - interval(1);

figure(numFig)
numFig = numFig + 1;
for ii = 2:4
    subplot(3,1,ii-1)
    plot(X_test(:,1),X_test(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 4
        xlabel(['{\it ' header{1} '}']);
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 5:7
    subplot(3,1,ii-4)
    plot(X_test(:,1),X_test(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 7
        xlabel(['{\it ' header{1} '}']);
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 8:10
    subplot(3,1,ii-7)
    plot(X_test(:,1),X_test(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 10
        xlabel(['{\it ' header{1} '}']);
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 11:14
    subplot(4,1,ii-10)
    plot(X_test(:,1),X_test(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 14
        xlabel(['{\it ' header{1} '}']);
    end
end

figure(numFig)
numFig = numFig + 1;
for ii = 15:18
    subplot(4,1,ii-14)
    plot(X_test(:,1),X_test(:,ii),'LineWidth',1.5);
    grid on; ylabel(['{\it ' header{ii} '}']);
    if ii == 18
        xlabel(['{\it ' header{1} '}']);
    end
end

%% write test.csv

basename = [basename '_' testname];
headerline = 'Time (s), phi (deg), theta (deg), psi (deg), p (deg/s), q (deg/s), r (deg/s), ax (m/s^2), ay (m/s^2), az (m/s^2), Ve (m/s), Hp (m), T (C), P (Pa), aileron (deg), elevator (deg), rudder (deg), throttle (percentage) \n';
fid = fopen([basename '.csv'], 'w');
fprintf(fid, headerline);
fclose(fid);

dlmwrite([basename '.csv'], X_test, '-append', 'precision', '%.6f', 'delimiter', '\t');


