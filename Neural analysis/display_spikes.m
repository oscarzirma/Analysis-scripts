function [t E rF spike_rate]=display_spikes(Rdata,index,labels,PD)
%Given a cell array of neural recordings, and index indicating which group
%each recording is associated with, an array of labels for each group, and
%a cell array of photodiode signals with which to calculate stim on and off
%times, the program will present a number of representations: raster,
%psth, spike rate,

n=length(Rdata);
g=length(labels);

for i=1:n
    x=cell2mat(Rdata(i));
    if ~isempty(x)

    r(i,1:length(x))=x(2,:);
    end
end
t=x(1,:)./1000;
Fs=1/t(2);

rF=batchhighpassFilter(r,400,Fs);

E=batch_threshSpikes(rF,4,Fs);
[~, sort_index]=sort(index(1:n));
E_sort=E(sort_index);
displayEvents(E_sort)
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

[stim_on stim_off]=photodiode_stim_times(PD);

%%FIX FOR SAMPLE DELAY
%stim_on=stim_on+.4;
stim_on=stim_on-.0105;
stim_off=stim_off-.0105;

ps_bin=.02;
ps_dur=round((t(end)+.2)/ps_bin);
ps_neg=.2/ps_bin;

rast=figure;set(gcf, 'Position', get(0,'Screensize'));
spkrt=figure;set(gcf, 'Position', get(0,'Screensize'));hold on;
psth=figure;set(gcf, 'Position', get(0,'Screensize'));

for i=1:g
    E_group=E(index==i);
    son=stim_on(index==i);
    soff=stim_off(index==i);
    
    figure(rast)
    subplot(g,1,i)
    title(num2str(labels(i)));
    hold on;
    
    for j=1:length(E_group)
        x=E_group(j).spk-son(j);
        dur=soff(j)-son(j);%duration of stim presentation
        
        %get spike rate
        baseline=length(find(x<0))/son(j);%baseline spike rate before stim onset
        peristim=x(x>=0);%find spikes occurring following stimulus onset
        stim_spikes=length(find(peristim<(dur+.1)))/(dur+.1);%-baseline;%find mean spike rate during stimulus presentation and the following 100 ms
        spkr(j)=stim_spikes;
        %get psth
        for k=1:ps_dur
            psa=x>(k-1-ps_neg)*ps_bin;
            psb=x<(k-ps_neg)*ps_bin;
            psc=psa+psb;
            ps(j,k)=length(find(psc==2))/ps_bin;%-baseline;
        end
        %plot raster
        scatter(x,ones(size(x)).*j,'k')
    end
    ax=axis;ax(1)=-.2;ax(2)=t(end)-.2;axis(ax);%fix raster axis
    
    %plot spike rate comparison
    figure(spkrt)
    scatter(ones(size(spkr)).*i,spkr)
    scatter(i,mean(spkr),'*')
    spike_rate(i)={spkr};
    spike_rate_mean(i)=nanmean(spkr);
    spike_rate_err(i)=nanstd(spkr)/sqrt(length(spkr));
    
    psth_full(i,:)=nanmean(ps);
    psth_var(i,:)=nanstd(ps)./sqrt(j);
        
end
set(gca,'Xtick',unique(index));
set(gca,'XTickLabel',strread(num2str(labels)));
ax=axis;ax(3)=-20;axis(ax);
figure
errorbar(unique(index),spike_rate_mean,spike_rate_err,'k','LineWidth',2);
set(gca,'Xtick',unique(index));
set(gca,'XTickLabel',strread(num2str(labels)));


%plot psth
psthmax=max(nanmax(psth_full));
figure(psth)
for i=1:g
    subplot(g,1,i)
    %shadedErrorBar(-.2:ps_bin:t(end)-ps_bin,psth_full(i,:),psth_var(i,:));
    plot(-.2:ps_bin:t(end)-ps_bin,psth_full(i,:))
    title(num2str(labels(i)));
    ax=axis;ax(1)=-.2;ax(2)=t(end)-.2;ax(3)=0;ax(4)=psthmax;axis(ax);%fix raster axis
end



