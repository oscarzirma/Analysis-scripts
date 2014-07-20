function prob_dist=event_probability_distribution_left_eye(event,interval)
%accepts an event struct from find_head_eye_events_bars and returns the
%probability distribution as a function of time during time interval
%±interval from each left_eye event for each of the other event types. looks in 10 ms
%steps

n=length(event);

prob_dist = zeros(5,2*interval/.01);
RE = prob_dist(1,:);HX=RE;HY=RE;HZ=RE;LE=RE;

stim = .1;

for i=1:length(event)
    e=event(i);
    
    ep=disambiguate_sequential_events(e.peck,.015);
    
    ele=disambiguate_sequential_events(e.eye_left,.015);
    
    ere = disambiguate_sequential_events(e.eye_right,.015);
    
    ehx = disambiguate_sequential_events(e.x,.015);
    ehy = disambiguate_sequential_events(e.y,.015);
    ehz = disambiguate_sequential_events(e.z,.015);
    
    
    
    for j=1:length(stim)
        ev = stim(j);%what is the locked event type?
        
        %left eye
        locked_events_indexed = zeros(1,2*interval/.01);
        locked_events = ele - ones(size(ele))*ev;
        index = abs(locked_events)<interval;
        locked_events_indexed(ceil(((locked_events(index)+interval))./.01)) = 1;
        LE = LE + locked_events_indexed;
        
        %right eye
        locked_events_indexed = zeros(1,2*interval/.01);
        locked_events = ere - ones(size(ere))*ev;
        index = abs(locked_events)<interval;
        locked_events_indexed(ceil(((locked_events(index)+interval))./.01)) = 1;
        RE = RE + locked_events_indexed;
        
        %head x
        locked_events_indexed = zeros(1,2*interval/.01);
        locked_events = ehx - ones(size(ehx)).*ev;
        index = abs(locked_events)<interval;
        locked_events_indexed(ceil(((locked_events(index)+interval))./.01)) = 1;
        HX = HX + locked_events_indexed;
    
                %head y
        locked_events_indexed = zeros(1,2*interval/.01);
        locked_events = ehy - ones(size(ehy)).*ev;
        index = abs(locked_events)<interval;
        locked_events_indexed(ceil(((locked_events(index)+interval))./.01)) = 1;
        HY = HY + locked_events_indexed;
        
                %head z
        locked_events_indexed = zeros(1,2*interval/.01);
        locked_events = ehz - ones(size(ehz)).*ev;
        index = abs(locked_events)<interval;
        locked_events_indexed(ceil(((locked_events(index)+interval))./.01)) = 1;
        HZ = HZ + locked_events_indexed;
        
    end
end

prob_dist = [LE;RE; HX; HY; HZ];