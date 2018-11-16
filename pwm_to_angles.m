%pwm_to_angles.m

close all
tn2 = 2;

%% Rudder

rudder.h = [-0.7 -0.5 0 0.5 1];
rudder.c = 2.4;
rudder.angle = atand(rudder.h/rudder.c);
rudder.pwm = [1180 1300 1520 1620 1920];
rudder.angle = [rudder.angle, -22.16 -16.29 -11.52 -7.00 2.45 9.19 21.13 23.72];
rudder.pwm = [rudder.pwm, 1055 1181 1243 1331 1480 1604 1737 1889];
%linear fit
[rudder.pwm rudder.angle beta0 beta1 deltab0 deltab1 outlinersIndex R2] =  linearFit(rudder.pwm, rudder.angle, tn2);
y = beta1*rudder.pwm + beta0;
R2
%plots
figure(1)
plot(rudder.pwm, rudder.angle, 'r*'); hold on
plot(rudder.pwm, y, 'b', 'LineWidth', 1.5);
grid on; ylabel('{\it \delta_r (deg)}'); xlabel('{\it PWM signal (ns)}'); title('{\bf Rudder}');
legend('Experiemtal Data', ['y = ' num2str(beta1,'%3.3f') '*x + (' num2str(beta0,'%3.2f') ')'], 'Location', 'SE');

%% Aileron 

aileron.h = -[0 1.4 0.5 -1.5 -0.6];
aileron.c = 3;
aileron.angle = atand(aileron.h/aileron.c);
aileron.pwm = [1516 1890 1600 1130 1360];
aileron.angle = [aileron.angle, 29.23 25.01 17.58 12.34 8.85 0.12 -8.75 -14.06 -19.59 -25.12];
aileron.pwm = [aileron.pwm, 1051 1098 1203 1298 1328 1464 1597 1696 1801 1884];
%linear fit
[aileron.pwm aileron.angle beta0 beta1 deltab0 deltab1 outlinersIndex R2] =  linearFit(aileron.pwm, aileron.angle, tn2);
y = beta1*aileron.pwm + beta0;
R2
figure(2)
plot(aileron.pwm, aileron.angle, 'r*');hold on
plot(aileron.pwm, y, 'b', 'LineWidth', 1.5);
grid on; ylabel('{\it \delta_a (deg)}'); xlabel('{\it PWM signal (ns)}'); title('{\bf Aileron}');
legend('Experiemtal Data', ['y = ' num2str(beta1,'%3.3f') '*x + (' num2str(beta0,'%3.2f') ')'], 'Location', 'NE');

%% Elevator 

elevator.h = [0 0.9 -1.4 0.7 -0.5];
elevator.c = 3.5;
elevator.angle = atand(elevator.h/elevator.c);
elevator.pwm = [1530 1120 1910 1230 1695];
elevator.angle = [elevator.angle, 23.63 21.61 17.57 11.67 1.99 -3.79 -5.66 -9.49 -15.49];
elevator.pwm = [elevator.pwm, 1055 1121 1200 1305 1474 1616 1684 1756 1889];
%linear fit
[elevator.pwm elevator.angle beta0 beta1 deltab0 deltab1 outlinersIndex R2] =  linearFit(elevator.pwm, elevator.angle, tn2);
y = beta1*elevator.pwm + beta0;
R2
figure(3)
plot(elevator.pwm, elevator.angle, 'r*');hold on
plot(elevator.pwm, y, 'b', 'LineWidth', 1.5);
grid on; ylabel('{\it \delta_e (deg)}'); xlabel('{\it PWM signal (ns)}'); title('{\bf Elevator}');
legend('Experiemtal Data', ['y = ' num2str(beta1,'%3.3f') '*x + (' num2str(beta0,'%3.2f') ')'], 'Location', 'NE');

%% Throttle

throttle.deflection = [10 15 12 18 20 25 30 40 51 60 0 9];
throttle.pwm = [1106 1152 1130 1192 1216 1262 1312 1410 1516 1590 1008 1100];
%linear fit
[throttle.pwm throttle.deflection beta0 beta1 deltab0 deltab1 outlinersIndex R2] =  linearFit(throttle.pwm, throttle.deflection, tn2);
y = beta1*throttle.pwm + beta0;
R2
figure(4)
plot(throttle.pwm, throttle.deflection, 'r*');hold on
plot(throttle.pwm, y, 'b', 'LineWidth', 1.5);
grid on; ylabel('{\it \tau (%)}'); xlabel('{\it PWM signal (ns)}'); title('{\bf Throttle}');
legend('Experiemtal Data', ['y = ' num2str(beta1,'%3.3f') '*x + (' num2str(beta0,'%3.2f') ')'], 'Location', 'SE');
