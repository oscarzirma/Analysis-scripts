function number_of_eye_movements(t,X,time)
%this function will return the proportion of trials in which a significant
%eye movement occurs by time

thresh = 2;

i=time_match(t,time);
Xd=diff(X(:,1:i),[],2);

Xdt=abs(Xd)>thresh;

Xdts=sum(Xdt');

trial_events = sum(Xdts>0);

num_trials = size(X,1);

display(['Significant movements occurred on ' num2str(trial_events/num_trials) ' of trials']);