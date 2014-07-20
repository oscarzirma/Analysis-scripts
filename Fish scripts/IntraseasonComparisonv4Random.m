function [MeanHam HMean Numseq]=IntraseasonComparisonv4Random(Sequences,Indices,IDs,SeasonID,SeasonIndex,Iterations)
%Same as IntraseasonComparisonv3,except that it also outputs a second set
%based on the Sequences randomized according to SeasonIndex.

[Distinct MeanHam StDHam Numseq] = IntraseasonComparisonv3(Sequences,Indices,IDs,SeasonID);
size(Sequences);
for(i=1:Iterations)
    i
    for(j=1:length(SeasonIndex)-1)
        b=SeasonIndex(j);
        e=SeasonIndex(j+1);
        set=Sequences(b:(e-1));
        size(set);
        SeqRan(b:(e-1))=shake(set,1);
    end
    size(SeqRan);
    [D HMean(:,:,i) HStD(:,:,i) N]= IntraseasonComparisonv3(SeqRan,Indices,IDs,SeasonID);
end

return