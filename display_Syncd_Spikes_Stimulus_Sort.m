function [all_syncedEvents ]=display_Syncd_Spikes_Stimulus_Sort(syncEvent_Full,spikeEvent_Full,prePad,postPad,stimulus_sort,group_title)
%Given a syncEvent vector of times, the script will display all of the
%spike events during the prePad and postPad periods relative to the
%synchronizing event. Stimulus sort defines the different groups. It will
%display a raster for each group and a PSTH for each group then return the
%maximum firing rate for each group.

n=max(stimulus_sort);

figure

for ind=1:n
    subplot(n,2,1+(ind-1)*2)
    index=(stimulus_sort==ind);
    syncEvent=syncEvent_Full(index);
    spikeEvent=spikeEvent_Full(index);
    
    hold on
    k=1;
    allSpikes=[];
    
    for i=1:length(syncEvent)
        s=syncEvent(i).spk;
        spk=spikeEvent(i).spk;
        for j=1:length(s)
            d=s(j);
            f=(spk>d-prePad);
            spikes=spk(f);
            f=(spikes<d+postPad);
            spikes=spikes(f);
            o=ones(size(spikes));
 
            spikes=spikes-o.*(prePad);
            syncedEvents(k).ev=spikes;
            allSpikes=[allSpikes; spikes];
            k=k+1;
            h=scatter(spikes,ones(size(spikes)).*k,'k','Marker','.');
            hChildren = get(h, 'Children');
            set(hChildren, 'Markersize', 12)
            
            %         if i==14
            %              set(h, 'MarkerEdgeColor', 'r','MarkerFaceColor','r');
            %         end
        end
        
    end
    if ~isempty(group_title)
        ylabel(group_title(ind),'Rotation',0)
    end
    subplot(n,2,2*ind)
    hist(sort(allSpikes),(prePad+postPad)/.005)
    all_syncedEvents(ind).spk=sort(allSpikes);
end
end