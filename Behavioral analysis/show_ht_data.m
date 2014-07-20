function show_ht_data (rdata)   
% helper function that plots the recorded head tracker data
% Sridhar Devarajan, 02/2011

if isempty(rdata)
    disp('Nothing to show! Apparently no recording happened...')
    return
end

figure(21210); % special figure #
set(gcf, 'position', [200, 50, 450 650], 'color', [1 1 1])

rdata(2:4,:) = detrend(rdata(2:4,:)')';
rdata(5:7,:) = detrend(rdata(5:7,:)')';

subplot(211);
plot(rdata(1, :), rdata(2, :), 'k'); ylabel('Az'); hold on;
plot(rdata(1, :), rdata(3, :), 'r'); ylabel('El')
plot(rdata(1, :), rdata(4, :), 'b'); ylabel('Az/El/Ro')
legend({'Az', 'El', 'Ro'});

subplot(212);
plot(rdata(1, :), rdata(5, :), 'k'); ylabel('x'); hold on;
plot(rdata(1, :), rdata(6, :), 'r'); ylabel('y');
plot(rdata(1, :), rdata(7, :), 'b'); ylabel('x/y/z');
legend({'x', 'y', 'z'});
% 
% subplot(212);
% plot(rdata(1, :), rdata(5, :), 'k'); ylabel('x'); hold on;
% plot(rdata(1, :), rdata(6, :), 'r'); ylabel('y');
% plot(rdata(1, :), rdata(7, :), 'b'); ylabel('x/y/z');
% legend({'x', 'y', 'z'});

xlabel('Time ms')
hold off; 
box off
%TODO: try this in 3D?

drawnow;