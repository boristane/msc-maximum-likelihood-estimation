%%
numFig = 1;
flight_frequency = [6.23 6.89 10.62];
flight_damping = [0.097 0.139 0.381];
lin_frequency = [7.92 3.81 9.25];
lin_damping = [0.057 0.085 0.163];
sysID_frequency = [6.81 5.65 6.66];
sysID_damping = [0.203 0.306 0.000003];
CG = [4 5 14];

figure('Units','normalized',...
           'Position',[.43 .14 .56 .75],...
           'Color',[0.8 0.8 0.8],...
           'Name',['Figure ' num2str(numFig)],...
           'NumberTitle','off',...
           'Tag','Fig1');
       
subplot(2,1,1)
plot(CG, flight_frequency, 'k*','LineWidth',1.5,'MarkerSize',8,'MarkerFaceColor','k'); hold on;
plot(CG, lin_frequency, 'bs','LineWidth',1.5,'MarkerSize',8,'MarkerFaceColor','b'); hold on;
plot(CG, sysID_frequency, 'ro','LineWidth',1.5,'MarkerSize',8); hold off;
xlim([3 15]);
grid on;
ylabel('\omega_d {\it (rad/s)}');
xlabel('{\it EAS (m/s)}')
legend('Flight Test', 'Lin Model', 'Sys ID Model');
subplot(2,1,2)
plot(CG, flight_damping, 'k*','LineWidth',1.5,'MarkerSize',8,'MarkerFaceColor','k'); hold on;
plot(CG, lin_damping, 'bs','LineWidth',1.5,'MarkerSize',8,'MarkerFaceColor','b'); hold on;
plot(CG, sysID_damping, 'ro','LineWidth',1.5,'MarkerSize',8); hold off;
xlim([3 15]);
ylim([0 1]);
grid on;
ylabel('\zeta_d');
xlabel('{\it EAS (m/s)}')
