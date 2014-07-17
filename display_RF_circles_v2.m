function [mean_spks rF]=display_RF_circles_v2(Rdata,azimuth ,elevation, stim_pos ,stim_ind , stim_on, stim_off)
%given results from find_RF_circles, will display a raster plot organized
%by stimulus location, followed by a plot of sp/s as a function of
%elevation and azimuth

n=length(Rdata);

for i=1:n
    x=cell2mat(Rdata(i));
    if ~isempty(x)

    r(i,:)=x(2,:);
    end
end
t=x(1,:)./1000;
Fs=1/t(2);

ps_bin=.02;
ps_dur=(t(end)+.2)/ps_bin;
ps_neg=.2/ps_bin;

rF=batchhighpassFilter(r,300,Fs);

E=batch_threshSpikes(rF,3.5,Fs);

[stim_ind_sort sort_index]=sort(stim_ind);
size(E)
size(sort_index)
E_sort = E(sort_index);

stim_pos_sort=stim_pos(stim_ind_sort,:);

a=length(azimuth);
e=length(elevation);

az=stim_pos_sort(1,1);
el=stim_pos_sort(1,2);

fa=find(azimuth==az);
fe=find(elevation==el);

displayEvents(E_sort)
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

spr=figure;hold on;set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
pst=figure;hold on;set(gcf, 'Position', get(0,'Screensize')); subplot(e,a,1)% Maximize figure.

rast=figure;
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
subplot(e,a,1)
title(['Az=' num2str(az) ' El=' num2str(el)]);
hold on
j=1;

for i=1:n
    if stim_pos_sort(i,1)~=az||stim_pos_sort(i,2)~=el;%if azimuth or elevation have changed, switch subplot
                    ax=axis;ax(1)=-.2;ax(2)=t(end);axis(ax);

        spike_rate(fe,fa)={sp};
        figure(spr)
        scatter(ones(size(sp)).*fa+(fe-1)*a,sp);
        scatter(fa+(fe-1)*a,mean(sp),'*');
        xlabels(fa+fe-1)={['Az =' num2str(az) ' El=' num2str(el)]};
        azlabels(fa)={num2str(az)};
        ellabels(fe)={num2str(el)};
        mean_spks(fe,fa)=mean(sp);
        ax=axis;ax(1)=-.2;ax(2)=t(end);axis(ax);

        
        figure(pst)
        subplot(e,a,fa+(fe-1)*a)
        plot(-.2:ps_bin:t(end)-ps_bin,mean(ps));
        title(['Az =' num2str(az) ' El =' num2str(el)]);
        ax=axis;ax(1)=-.2;ax(2)=t(end);ax(3)=0;ax(4)=350;axis(ax);
        clear ps
        
        figure(rast)
        az=stim_pos_sort(i,1);
        el=stim_pos_sort(i,2);
        fa=find(azimuth==az);
        fe=find(elevation==el);
        subplot(e,a,fa+(fe-1)*a)
        title(['Az=' num2str(az) ' El=' num2str(el)]);
        hold on
        j=1;
        
    end
    scatter(E_sort(i).spk-stim_on(i),ones(size(E_sort(i).spk)).*i,'k');%plot raster
    x=E_sort(i).spk-stim_on(i);

    
    for k=1:ps_dur %find psth
        psa=x>(k-1-ps_neg)*ps_bin;
        psb=x<(k-ps_neg)*ps_bin;
        psc=psa+psb;
        ps(j,k)=length(find(psc==2))/ps_bin;
    end
    
    s=E_sort(i).spk;%find spike rate
    s1=s>stim_on(i);
    s2=s<stim_off(i)+.1;
    s3=s1+s2;
    sb=s<stim_on(i);
    sp(j)=(length(find(s3))./((stim_off(i)+.1)-stim_on(i)))-(length(find(sb))/stim_on(i));%calculate spikes per second
    %     length(find(s3))
    %     length(find(sb))
    %     (stim_off(i)+.2)-stim_on(i)
    %     length(find(s3))./((stim_off(i)+.2)-stim_on(i))
    j=j+1;
end
                    ax=axis;ax(1)=-.2;ax(2)=t(end);axis(ax);

spike_rate(fe,fa)={sp};
figure(spr)
scatter(ones(size(sp)).*fa+(fe-1)*a,sp);
scatter(fa+(fe-1)*a,mean(sp),'*');
xlabels(fa+fe-1)={['Az =' num2str(az) ' El=' num2str(el)]};
azlabels(fa)={num2str(az)};
ellabels(fe)={num2str(el)};
mean_spks(fe,fa)=mean(sp);

figure(pst)
subplot(e,a,fa+(fe-1)*a)
        plot(-.2:ps_bin:t(end)-ps_bin,mean(ps));
        ax=axis;ax(1)=-.2;ax(2)=t(end);ax(3)=0;ax(4)=350;axis(ax);
title(['Az =' num2str(az) ' El =' num2str(el)]);
clear ps

figure(spr)

set(gca,'XTick',[1:length(xlabels)])
set(gca,'XTickLabel',xlabels)

figure
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
% flipdim(flipdim(mean_spks,1),2);flipdim(azlabels,2);flipdim(ellabels,2);
flipdim(mean_spks,1);flipdim(ellabels,2);
imagesc(flipdim(mean_spks,1));
set(gca,'XTick',[1:length(azlabels)])
set(gca,'XTickLabel',azlabels)
set(gca,'YTick',[1:length(ellabels)])
set(gca,'YTickLabel',flipdim(ellabels,2))
c=colorbar;
set(get(c,'Ylabel'),'String','spikes/second')


