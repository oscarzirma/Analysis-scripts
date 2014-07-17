function [InitialI,FinalI]=BehaviorInvertSigns(Initial, Final)
%Takes in a set of initial angles and a set of final angles. If an element of the initial
%anARFinPgle is negative, it will reverse its sign and the sign of the
%corresponding final angle element.

x=find(Initial<0);

InitialI=Initial;FinalI=Final;

InitialI(x)=-InitialI(x);
FinalI(x)=-FinalI(x);

return