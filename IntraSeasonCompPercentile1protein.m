function IntraSeasonCompPercentile1protein(Sequence,Indices,IDs,SeasonID,SeasonIndex,Iterations)
%Takes in season Indices, group id's, group season ID's, season divisions,
%and the number of iterations and writes to data.dat for each influenza
%protein (as specified in the code) the percentile rank of the true mean hamming distance
%per comparison for each season and group relative to the iterations. The
%iterations will be sorted from minimum to maximum, with rank 1 being the
%minimum. The program will also output the true mean hamming distance, the
%max, min, mean, and standard deviation of the iterations.

dlmwrite('data.dat',' ','delimiter','\t')

dlmwrite('data.dat','HA','-append')
interfunction(Sequence,Indices,IDs,SeasonID,SeasonIndex,Iterations)
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')

end

function interfunction(Sequences,Indices,IDs,SeasonID,SeasonIndex,Iterations)

[MeanHam HMean Numseq]=IntraseasonComparisonv4Random(Sequences,Indices,IDs,SeasonID,SeasonIndex,Iterations);

[m,n]=size(MeanHam);

Percentile=zeros(m,n);iMean=zeros(m,n);iStd=zeros(m,n);iMax=zeros(m,n);iMin=zeros(m,n);
%initialize output matrices

iSort=sort(HMean,3,'ascend');

for(i=1:m)
    for(j=1:n)
        x=iSort(i,j,:);
        Percentile(i,j)=Iterations+1;
        k=1;
        while(k<length(x))
            if(MeanHam(i,j)<x(k))
                Percentile(i,j)=k;
                break
            else
                k=k+1;
            end
        end
        iMean(i,j)=mean(x);
        iStd(i,j)=std(x);
        iMax(i,j)=max(x);
        iMin(i,j)=min(x);
    end
end

dlmwrite('data.dat','Percentile','-append')
dlmwrite('data.dat',Percentile,'delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat','MeanHam','-append')
dlmwrite('data.dat',MeanHam,'delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat','Iteration Mean','-append')
dlmwrite('data.dat',iMean,'delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat','Iteration Standard Deviation','-append')
dlmwrite('data.dat',iStd,'delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat','Iteration Maximum','-append')
dlmwrite('data.dat',iMax,'delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat','Iteration Minimum','-append')
dlmwrite('data.dat',iMin,'delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat',' ','delimiter','\t','-append')
dlmwrite('data.dat','Number Sequences','-append')
dlmwrite('data.dat',Numseq,'delimiter','\t','-append')

end
