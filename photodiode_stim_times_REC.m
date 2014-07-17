function [on off]=photodiode_stim_times_REC(REC,varargin)
%given a photodiode trace, this script will return the stim onset and
%offset times for each cell element
if length(varargin)==1
    cue_delay = cell2mat(varargin(1));
else
    cue_delay = 0.01;%delay for cue. only pulses after this will be considered stim_on and stim_off times
end
thresh    = .01;%threshold relative to minimum value of photodiode trace
max_thresh= 2;

for i=1:length(REC)
    
    x=REC(i).PD;
    if ~isempty(x)
        t=x(1,:)./1000;
        p=x(2,:);
        m=min(p);
        
        th=thresh;
        cd = time_match(t,cue_delay);
        ev = 1;

%         while ev && th<max_thresh
            %pt=p<m+(abs(m)*th);
            pt=p<mean([m mean(p)]);
            ptf = find(pt(cd:end))+cd-1;
%             th = th + .01;
%             if length(ptf)<5
%                 ev = 1;
%             elseif diff(ptf(1:2))>10
%                 ev = 1;
%             else
%                 ev = 0;
%             end
        end
        
        if ~isempty(ptf)
            if t(ptf(1))<cue_delay
                j=1;
                while j+1<length(ptf)&&ptf(j+1)-ptf(j)<50
                    j=j+1;
                end
                j=j+1;
                on(i)=t(ptf(j));
            else
                on(i)=t(ptf(1));
                j=1;
            end
            while j<length(ptf)&&ptf(j+1)-ptf(j)<20
                j=j+1;
            end
            off(i)=t(ptf(j));
        end
    end
end