function [struct] = trackerPeck(headPosition,response_trial_index,stimulus_position,peckLocations)
%Script determines the timing of pecks on response trials and the location of the head at each
%peck. It also determines the reaction time, the point at which the head
%begins to move away from the zero point following the cue (cross
%disappearance). Peck contains a row for each response trial with the
%columns organized [time y x z].

y_thresh   = .07; %the threshold in the y head position to be considered a peck
rxn_thresh = .02;%threshold for the derivitive of position to be considered a reaction
art_thresh = .15;%threshold for the deriivitive of position to be considered an artifact
drxn       = 40; %delay between start of trial and possible reactions
dpck       = 40;%delay between start of trial and possible peck
check_threshold = true; %if true, program will plot reponses and ask for user input on thresholds

n = length(headPosition); %number of total trials run

[T X Y Z Yaw Rol Pit Tm Xm Ym Zm Yawm Rolm Pitm]=getHeadPos(headPosition);%get head position data

clear T X Y Z Yaw Rol Pit Yawm Rolm Pitm;

r=find(response_trial_index(1:n));

Y=Ym(r,:);%generate matrix containing only response trials
X=Xm(r,:);
T=Tm(r,:);
Z=Zm(r,:);
stim = stimulus_position(r,:);

n = size(X,1);

if check_threshold
    i=randi(n,50,1);
    plot(Ym(i,:)');
    axis([0 100 .03 .15])
    title('Indicate y-thresh and x-delay for peck')
    [x y]=ginput(1);
    dpck = round(x);
    y_thresh = y
    close(gcf)
end


%%find zero pecks
[zVal zInd] = max(Y(:,1:dpck-1)');

%%find pecks

[mVal mInd] = max(Y(:,dpck:end)'); %find value and time index of max of Y for each trial (pecks)
peckInd = mVal > y_thresh; %index of trials with a peck
mInd = mInd(peckInd); %cut out those trials without a peck from the peck time index mInd


Tp=T(peckInd,:);%generate matrix containing only trials with pecks
Yp=Y(peckInd,:);
Xp=X(peckInd,:);
Zp=Z(peckInd,:);



for i = 1:n
    %zeros
    Zero(i,:) = [T(i,zInd(i)) Y(i,zInd(i)) X(i,zInd(i)) Z(i,zInd(i))];
    %peck locations
    %     plot(Y(i,:))
    %     hold on
    %     plot(Yp(i,:),'r')
    %     scatter(mInd(i)+dpck-1,0,'r')
    %     scatter(zInd(i),0,'b')
    %     pause
    %     close(gcf)
    if i<=size(Xp,1)
        Peck(i,:) = [Tp(i,mInd(i)+dpck-1) Yp(i,mInd(i)+dpck-1) Xp(i,mInd(i)+dpck-1) Zp(i,mInd(i)+dpck-1)];
    end
    
end
[m] = mean(Zero);%find mean zero position

%%find reaction times

%normalize X position to mean zero X.
Xn = X - ones(size(X)).*m(3);
s=-sign(stim(:,1));
sr=repmat(s,1,size(X,2));
Xd=Xn.*sr;
if check_threshold
    plot(Xd');hold on
    plot(ones(1,size(Xd,2)).*rxn_thresh)
    line([drxn drxn],[-.1 .05])
    axis([0 100 -.1 .05])
    title('X movement threshold')
    [x y] =ginput(1);
    drxn = round(x);
    rxn_thresh = y
    close(gcf)
end




movement = Xd > rxn_thresh; %index of movement faster than threshold
artifact = Xd > art_thresh; %index of movements likely to be artifacts
response = movement - artifact;%remove artifact indices from movement index

for i = 1:n
    %reaction times
%         plot(X(i,:))
%         hold on
%         plot(response(i,:)./100,'r')
%         pause
%          close(gcf)
    f=find(response(i,drxn:end));%find responses occurring after the stimulus is presented following delay
    if ~isempty(f)
        Rxn(i,:) = [T(i,f(1)+drxn-1) Y(i,f(1)+drxn-1) X(i,f(1)+drxn-1) Z(i,f(1)+drxn-1)];
    else
        Rxn(i,:) = [0 0 0 0];
    end
end


%%normalize peck locations to mean of zero pecks. this accounts for between-day changes
%%in the marker placement
o=ones(n,1);


N = [zeros(n,1) o.*m(2) o.*m(3) o.*m(4)];

%Zero = Zero-N; do not normalize zero
Rxn  = Rxn-N;

o=ones(size(Xp,1),1);
N = [zeros(size(o)) o.*m(2) o.*m(3) o.*m(4)];

Peck = Peck-N;

stim = stim(peckInd,:);


touch_peck = peckLocations(r);
touch_peck = touch_peck(peckInd);



%generate struct output
struct.peck=Peck;
struct.zero=Zero;
struct.stim=stim;
struct.rxn=Rxn;
struct.touch_peck=touch_peck;
