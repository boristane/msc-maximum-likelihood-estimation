% input_plot.m

for ii = 1:size(u,2)
    ax(ii) = subplot(size(u,2),1,ii, 'Parent', handles.inputs);
    plot(ax(ii),time,u(:,ii), '-b', 'Linewidth', 1.5);
    ylabel(['{\it ' inputs(ii,:) ' }']);
    grid on;
if ii == size(u,2)
    xlabel('{\it Time (s)}');
end
end
