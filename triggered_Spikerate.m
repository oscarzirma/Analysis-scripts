function SpkR=triggered_Spikerate(E,trigger,interval,subtract_baseline)
%this function will return the spike rate during a fixed interval following a trigger 

for ii=1:length(E);
    t=trigger(ii);
    x=E(ii).spk-t;
        
    %get spike rate
    if subtract_baseline
        baseline=sum(x<0)/t;%baseline spike rate before trigger
    else
        baseline=0;
    end
    triggered = sum(x>0&x<interval)/interval;%spike rate during interval
    SpkR(ii)=triggered-baseline;
end