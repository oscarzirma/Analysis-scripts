function prob_dist=event_probability(event,interval)
%accepts an event struct from find_head_eye_events_bars and returns the
%probability that each of the event types occurs within interval from the
%trigger event

n=length(event);

prob_dist = zeros(5,1);
RE = 0;HX=RE;HY=RE;HZ=RE;LE=RE;

stim = .1;

num_events = 0;%record of total number of trigger events

for i=1:length(event)
    e=event(i);
    
    ep=disambiguate_sequential_events(e.peck,.015);
    
    ele=disambiguate_sequential_events(e.eye_left,.015);
    
    ere = disambiguate_sequential_events(e.eye_right,.015);
    
    ehx = disambiguate_sequential_events(e.x,.015);
    ehy = disambiguate_sequential_events(e.y,.015);
    ehz = disambiguate_sequential_events(e.z,.015);
    
    
    for j=1:length(ehx)
        ev = ehy(j);%what is the locked event type?
        
        %left eye
        locked_events = ele - ones(size(ele))*ev;
        index = abs(locked_events)<interval;
        if sum(index)>0 LE = LE +1;end
        
        %right eye
        locked_events = ere - ones(size(ere))*ev;
        index = abs(locked_events)<interval;
        if sum(index)>0 RE = RE +1;end
        
        %head x
        locked_events = ehx - ones(size(ehx)).*ev;
        index = abs(locked_events)<interval;
        if sum(index)>0 HX = HX +1;end
    
                %head y
        locked_events = ehy - ones(size(ehy)).*ev;
        index = abs(locked_events)<interval;
        if sum(index)>0 HY = HY +1;end

        
                %head z
        locked_events = ehz - ones(size(ehz)).*ev;
        index = abs(locked_events)<interval;
        if sum(index)>0 HZ = HZ +1;end

        num_events=num_events+1;
        
    end
end


prob_dist = [LE;RE; HX; HY; HZ];
prob_dist = prob_dist./repmat(num_events,5,1);