%this script will find the reaction direction for each trial
n=length(gazePosition);
rxn_dir_hor = nan(1,n);
rxn_dir_vert = nan(1,n);
abs_rxn_time = nan(1,n);
rel_rxn_time = nan(1,n);
rxn_quad     = zeros(1,n);
rxn_index  = ones(1,n);
rxn_gaze_x = nan(1,n);
rxn_gaze_y = nan(1,n);


for i=1:length(gazePosition)
    g=cell2mat(gazePosition(i));
    dg=diff(g(:,2));
    tso=time_match(g(:,1),son(i));%find time point at which stimulus turns on
    gm=find(abs(dg(tso:end))>3);%find indices following stimulus onset at which there is a significant movement
    if ~isempty(gm)
    max_index = gm(1) + tso-1;
    rxn_dir_hor(i)=sign(dg(max_index));
    abs_rxn_time(i) = g(max_index,1)+son(i);
    rel_rxn_time(i) = g(max_index,1);
    rxn_gaze_x(i) = g(max_index,2);
    rxn_gaze_y(i) = g(max_index,3);
    rxn_index(i) = max_index + tso;
    end
        dg=diff(g(:,3));
    gm=find(abs(dg(tso:end))>3);%find indices following stimulus onset at which there is a significant movement
    if ~isempty(gm)
    max_index = gm(1) + tso-1;
    rxn_dir_vert(i)=sign(dg(max_index));
    end
end

for i=1:length(azimuth);
    rxn_quad(rxn_dir_hor==sign(azimuth(i))&rxn_dir_vert==sign(elevation(i)))=i;
end