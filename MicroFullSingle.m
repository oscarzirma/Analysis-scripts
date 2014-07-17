function MicroFullSingle(Range,Interval,Freq,Srate,coordinates,fishposition,display)
    n='out.nm';
    [f a]=MicrophonicBatch(Range,Interval,Freq,Srate,display);

    Positions=zeros(size(a,1)+2,5);size(Positions)
    size(fishposition)
    Positions(1:3,1:2)=fishposition;
    Positions(1,3:5)=a(1,:);
    size(Positions(4:3+size(coordinates,1),1:2))
    size(coordinates)
    Positions(5:4+size(coordinates,1),1:2)=coordinates;
    Positions(4:size(Positions,1),3:5)=a(2:size(a,1),:);
    

    dlmwrite(n,Positions,'\t')
    
end