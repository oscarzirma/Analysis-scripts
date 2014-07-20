function [syncedEvents]=display_Syncd_Spikes(syncEvent,spikeEvent,prePad,postPad)
%Given a syncEvent vector of times, the script will display all of the
%spike events during the prePad and postPad periods relative to the
%synchronizing event

figure
% subplot(211)

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
        spikes=spikes-o.*(d-prePad);
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
%  subplot(212)
%  hist(sort(allSpikes),(prePad+postPad)/.005)

end