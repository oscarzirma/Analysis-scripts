function [Distinct MeanHam StDHam Numseq] = IntraseasonComparisonv3(Sequences,Indices,IDs,Season)
%Takes in a list of sequences, indices by which to divide those sequences
%and a list of ID numbers identifying which column each division should be
%included in (for example, 1 for early epidemic, 2 for mid epidemic, 3 for
%late epidemic)and a vector of seasons indicating the proper row for a division
%and returns two matrices one of the number of distinct sequences
%and the other of the mean hamming distance between sequences for each
%division with the different groups in columns and consecutive divisions
%within groups in rows.
%Added in version 2.1: 1. Outputs mean hamming distance per comparison
%rather than per sequence.
%2. Outputs a kruskal wallis p-value for comparing the distributions of
%hamming distances between divisions

hamming=[];
group=[];

for(i=1:length(Indices)-1)
    S=Sequences(Indices(i):Indices(i+1)-1);
    m=Season(i);
    n=IDs(i);
    
    Distinct(m,n)=length(unique(S));
    
    ham=numdifs1(S);
    
    hamming=[hamming ham];
    one=ones(1,length(ham))*n;
    group=[group one];
    
    MeanHam(m,n)=mean(ham);
    StDHam(m,n)=std(ham);
    Numseq(m,n)=length(S);
end

D=Distinct(1:5,:);
D=[D
    Distinct(7:10,:)];%remove zero values in season 5
H=MeanHam(1:5,:);
H=[H
    MeanHam(7:10,:)];

%kruskalwallis(hamming,group,'off');
%kruskalwallis(H,[],'off');

%dlmwrite('data.dat',' ','delimiter','\t')
%dlmwrite('data.dat',Distinct,'delimiter','\t','-append')
%dlmwrite('data.dat',' ','delimiter','\t','-append')
%dlmwrite('data.dat',MeanHam,'delimiter','\t','-append')
%dlmwrite('data.dat',' ','delimiter','\t','-append')
%dlmwrite('data.dat',StDHam,'delimiter','\t','-append')
%dlmwrite('data.dat',' ','delimiter','\t','-append')
%dlmwrite('data.dat',Numseq,'delimiter','\t','-append')

return