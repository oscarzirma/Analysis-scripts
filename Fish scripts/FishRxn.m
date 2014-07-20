function [Response RxnTime AngAccuracy DisAccuracy]=FishRxn(RelDis,RelAng,ResCri,fps)
%Takes in the RelDis and RelAng from FishBehavior program and outputs
%whether or not there was a response (does the fish get within ResCri cm of
%the pellet), the reaction time (time to the fish turning toward the
%pellet), the AngAccuracy outputs the minimum of the RelAng, and
%DisAccuracy outputs the minimum of the RelDis.

[m,n]=size(RelDis);

[AngAccuracy Ia]=min(abs(RelAng),[],2);
[DisAccuracy Id]=min(RelDis,[],2);

RxnTime=Ia./fps;

Response=DisAccuracy<ResCri;

return
    









