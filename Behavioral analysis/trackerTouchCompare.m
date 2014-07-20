function [hor ver pck pecks] = trackerTouchCompare(headPosition,peckLocations)
%given headPosition and peckLocations, this program returns a matrix
%containing the X and Y positions, with the tracker position in the first
%column and the touch screen position in the second. The pck vector contains
%the tracker Y-values at the time of the peck.

[T X Y Z Yaw Rol Pit Tm Xm Ym Zm Yawm Rolm Pitm]=getHeadPos(headPosition);

n=length(T);
k=1;
peckTrials = 0;
pecks = [];

for i = 1:n
    p=cell2mat(peckLocations(i));
    if ~isempty(p) %if there were additional pecks in the trial, compare tracker and screen positions
        pecks=[pecks;p];
        t=cell2mat(T(i));
        m=size(p,1);
        peckTrials = peckTrials +1;
        for j=1:m
             a=find(((t>(p(j,1)-.016))+(t<p(j,1)+.016))==2);
             if ~isempty(a)
                 x=cell2mat(X);y=cell2mat(Y);z=cell2mat(Z);
                 hor(k,:) = [x(a(1)) p(j,2)];
                 ver(k,:) = [z(a(1)) p(j,3)];
                 pck(k)   = y(a(1));
                 k=k+1;
                 if(p(j,2)<100)
                     keyboard
                 end
             end
        end
    end
end

peckTrials