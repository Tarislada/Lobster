function [ ] = drawmap( map, axis_limit, c_axis_limit )
%hitmap�� �׸���.

%% �׷����� ����
if isempty(axis_limit)
    ax_x = 160 : 580;
    ax_y = 110 : 350;
else
    ax_x = axis_limit(1) : axis_limit(2);
    ax_y = axis_limit(3) : axis_limit(4);
end
figure;
surf(ax_x,ax_y,map', 'EdgeColor','none');
colormap jet
caxis(c_axis_limit); 
colorbar;
end

