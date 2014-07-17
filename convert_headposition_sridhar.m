%converts headPosition from Sridhar format to my format

for i=1:length(headPositionS) 
    hs=headPositionS(i);
    hst=hs.t';
    headPosition(i) = {[hst-hst(1) hs.trans_dat hs.rot_dat]};
end
headPosition=headPosition';