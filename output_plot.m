% output_plot.m


x0=xs(1,:)'
for ii = 1:size(z,2)
    ax(ii) = subplot(size(z,2),1,ii, 'Parent', handles.outputs);
    plot(time,z(:,ii), '-b', 'Linewidth', 1.5);hold on;
    plot(time,y(:,ii), '--r', 'Linewidth', 1.5);
    ylabel(['{\it ' outputs(ii,:) ' }']);
    grid on;
if ii == size(z,2)
    xlabel('{\it Time (s)}');
elseif ii == 1
    legend('Measured', 'Model');
end
    axes(ax(ii));hold on,plot(time(1),x0(ii),'r.','LineWidth',2,'MarkerSize',14),hold off;
end
