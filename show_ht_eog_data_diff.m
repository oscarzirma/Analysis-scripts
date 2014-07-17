function show_ht_eog_data_diff (edata,rdata,dedata,drdata,eogEvents,htEvents)   
% helper function that plots the recorded head tracker data
% Sridhar Devarajan, 02/2011

if isempty(rdata)
    disp('Nothing to show! Apparently no recording happened...')
    return
end

figure(20112); % special figure #
set(gcf, 'position', [200, 50, 900 1300], 'color', [1 1 1])

subplot(321);
plot(edata(1, :), edata(2, :), 'k'); ylabel('01');
hold on;scatter(eogEvents,zeros(size(eogEvents)));
% legend({'01', '02', '01-02'});
box off

rdata(2:4,:) = detrend(rdata(2:4,:)')';
rdata(5:7,:) = detrend(rdata(5:7,:)')';

subplot(323);
plot(rdata(1, :), rdata(2, :), 'k'); ylabel('Az'); hold on;
plot(rdata(1, :), rdata(3, :), 'r'); ylabel('El')
plot(rdata(1, :), rdata(4, :), 'b'); ylabel('Az/El/Ro')
z=zeros(1,length(htEvents(1,:)));
scatter(htEvents(1,:),z,'k')
scatter(htEvents(2,:),z,'r')
scatter(htEvents(3,:),z,'b')

legend({'Az', 'El', 'Ro'});hold off;

subplot(325);
plot(rdata(1, :), rdata(5, :), 'k'); ylabel('x'); hold on;
plot(rdata(1, :), rdata(6, :), 'r'); ylabel('y');
plot(rdata(1, :), rdata(7, :), 'b'); ylabel('x/y/z');
legend({'x', 'y', 'z'});
scatter(htEvents(4,:),z,'k')
scatter(htEvents(5,:),z,'r')
scatter(htEvents(6,:),z,'b')
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

subplot(322);
plot(dedata(1, :), dedata(2, :), 'k'); ylabel('01'); 
% legend({'01', '02', '01-02'});
box off

drdata(2:4,:) = detrend(drdata(2:4,:)')';
drdata(5:7,:) = detrend(drdata(5:7,:)')';

subplot(324);
plot(drdata(1, :), drdata(2, :), 'k'); ylabel('Az'); hold on;
plot(drdata(1, :), drdata(3, :), 'r'); ylabel('El')
plot(drdata(1, :), drdata(4, :), 'b'); ylabel('Az/El/Ro')
legend({'Az', 'El', 'Ro'});hold off;

subplot(326);
plot(drdata(1, :), drdata(5, :), 'k'); ylabel('x'); hold on;
plot(drdata(1, :), drdata(6, :), 'r'); ylabel('y');
plot(drdata(1, :), drdata(7, :), 'b'); ylabel('x/y/z');
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

end