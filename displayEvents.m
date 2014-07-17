function displayEvents(Events)
%Displays a set of events in raster form.


hold on
for i=1:length(Events)
scatter(Events(i).spk,ones(size(Events(i).spk)).*i,'k','Marker','.');
end

end