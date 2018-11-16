% residuals_plot.m

for ii = 1:size(y,2)
    ax(ii) = subplot(size(y,2),1,ii, 'Parent', handles.residuals);
    plot(ax(ii),time,z(:,ii)-y(:,ii), '-k', 'Linewidth',1.5);
    ylabel(['{\it ' outputs(ii,:) ' }']);
    grid on;
if ii == size(y,2)
    xlabel('{\it Time (s)}');
end
end
