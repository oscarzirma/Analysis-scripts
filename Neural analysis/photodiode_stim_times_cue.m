function [on off]=photodiode_stim_times_cue(PD,varargin)
%given a photodiode trace, this script will return the CUE onset and
%offset times for each cell element

if length(varargin)==1
    cue_delay = cell2mat(varargin(1));
else
    cue_delay = 0.3;%delay for cue. only pulses before this will be considered stim_on and stim_off times
end
thresh    = .01;%threshold relative to minimum value of photodiode trace
max_thresh= 2;

n=length(PD);
on = zeros(n,1);
off = zeros(n,1);

for i=1:length(PD)
    
    x=cell2mat(PD(i));
    if ~isempty(x)
        t=x(1,:)./1000;
        p=x(2,:);
        m=min(p);
        
        th=thresh;
        cd = time_match(t,cue_delay);
        ev = 1;

%         while ev && th<max_thresh
            %pt=p<m+(abs(m)*th);
            pt=p<mean([m median(p)]);
            ptf = find(pt(1:cd));
%             th = th + .01;
%             if length(ptf)<3
%                 ev = 1;
%             elseif diff(ptf(1:2))>12
%                 ev = 1;
%             else
%                 ev = 0;
%             end
        end
        
        if ~isempty(ptf)
                on(i)=t(ptf(1));
                j=1;
      
            while j<length(ptf)&&ptf(j+1)-ptf(j)<20
                j=j+1;
            end
            off(i)=t(ptf(j));
        end
    end
end