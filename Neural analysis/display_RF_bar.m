function spike_rate=display_RF_bar(Rdata,azimuth, stim_pos ,stim_ind , stim_on, stim_off)
%given results from find_RF_bar, will display a raster plot organized
%by stimulus location, followed by a plot of sp/s as a function of
%elevation and azimuth

n=length(Rdata);
if azimuth t='Azimuth'; else t='Elevation';end

for i=1:length(Rdata)
    x=cell2mat(Rdata(i));
    r(i,:)=x(2,:);
end
t=x(1,:)./1000;
Fs=1/t(2);

rF=batchhighpassFilter(r,300,Fs);

E=batch_threshSpikes(rF,4,Fs);

[stim_ind_sort sort_index]=sort(stim_ind);

E_sort = E(sort_index);

stim_pos_sort=stim_pos(stim_ind_sort,:);

s=length(stim_pos);

stpo=stim_pos_sort(1);

fs=find(stim_pos==stpo);

displayEvents(E_sort)
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
title(t);

spr=figure;hold on;set(gcf, 'Position', get(0,'Screensize'));title(t) % Maximize figure.

rast=figure;title(t)
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
subplot(s,1,1)
title([num2str(stpo) '°']);
hold on
j=1;

for i=1:n
    if stim_pos_sort(i)~=stpo;%if stim position has changed, switch subplot
        spike_rate(fs)={sp};
        figure(spr)
        scatter(ones(size(sp)).*fs,sp);
        scatter(fs,mean(sp),'*');
        xlabels(fs)={[num2str(stpo) '°']};
        stpolabels(fs)={num2str(stpo)};
        mean_spks(fs)=mean(sp);
        
        figure(rast)
        stpo=stim_pos_sort(i);
        fs=find(stim_pos==stpo);
        subplot(s,1,fs)
        title([num2str(stpo) '°']);
        hold on
        j=1;
        
    end
    scatter(E_sort(i).spk-stim_on(i),ones(size(E_sort(i).spk)).*i,'k','Marker','.');%plot raster
    
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

figure(spr)

set(gca,'XTick',[1:length(xlabels)])
set(gca,'XTickLabel',xlabels)

figure
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
if azimuth
    imagesc(mean_spks);
    set(gca,'XTick',[1:length(stpolabels)])
    set(gca,'XTickLabel',stpolabels)
    c=colorbar;
    set(get(c,'Ylabel'),'String','spikes/second')
else
    imagesc(flipdim(mean_spks,1)');
    set(gca,'YTick',[1:length(stpolabels)])
    set(gca,'YTickLabel',stpolabels)
    c=colorbar;
    set(get(c,'Ylabel'),'String','spikes/second')
end


