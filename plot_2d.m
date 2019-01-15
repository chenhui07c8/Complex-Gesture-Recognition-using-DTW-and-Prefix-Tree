% this function works as plotting two dimensional data with changing color
% from blue to red.

% size is the boundary of plotted figure
function plot_2d(x,y,size)
    g_len = length(x);
    figure;
    for i =1:g_len
        plot(x(i),y(i),'o','Color',[i/g_len,0,1-i/g_len]);hold on;
    end
    % axis([-90,90,-90,90])  
    axis([-size,size,-size,size]);
end
