function indivFishAnalysis(minAng)
%takes in a minimum angle and then asks for a directory. will then open
%each subdirectory, assuming that each one contains data for one fish,
%opening the 'baseline' directory and importing 'BaselineAllV10.txt' and
%'RidgeAllV10.txt.' It will then calculate the 'error' in the angular
%response by subracting from the initial angle (column 1) the angle
%estimate (column 10) and final angle (column 11). For each of these values
%it will then calculate the proportion of them that are less than the
%minAng. It will create two variables estPer and finPer, the first of which
%will contain the proportion of trials with the angle estimate reaching the 
%minAng with baseline in the first column and ridge in the second. The 
%second willb e the same for final angle. Each fish will have a row. It
%will then write these two variables.

%d=uigetdir;
%d 
%cd(d)

d=pwd

file=dir;
n=length(file);

j=1;

for i=4:length(file)
    if ~file(i).isdir% exit if the file entry is not a directory
        break
    end
    cd(file(i).name);
    cd('baseline');%import base and ridge data from behavioral program
    tmp=importdata('BaselineAllV10.txt');
    base=tmp.data;
    tmp=importdata('RidgeAllV10.txt');
    ridge=tmp.data;
    
    est=abs(base(:,1)-base(:,10))<minAng;
    estPer(j,1)=sum(est)/length(est);
    estFal(j,1)=sum((abs(0.2*base(:,1))>abs(base(:,10))))/length(est);
 
   
    fin=abs(base(:,1)-base(:,11))<minAng;
    finPer(j,1)=sum(fin)/length(fin);
    finFal(j,1)=sum((abs(0.2.*base(:,1))>abs(base(:,11))))/length(fin);

    
    est=abs(ridge(:,1)-ridge(:,10))<minAng;
    estPer(j,2)=sum(est)/length(est);
    estFal(j,2)=sum((abs(0.2*ridge(:,1))>abs(ridge(:,10))))/length(est);

    
    fin=abs(ridge(:,1)-ridge(:,11))<minAng;
    finPer(j,2)=sum(fin)/length(fin);
    finFal(j,2)=sum((abs(0.2.*ridge(:,1))>abs(ridge(:,11))))/length(fin);

    j=j+1;
    cd(d)
end

estPer;
mean(estPer)
[h p]=ttest(estPer(:,1),estPer(:,2),.05,'right')
 mean(estFal)
 [h p]=ttest(estFal(:,1),estFal(:,2),.05,'left')


sum(estPer(:,1)>estPer(:,2));

% finPer;
% mean(finPer)
% [h p]=ttest(finPer(:,1),finPer(:,2),.05,'right')
% mean(finFal)
% [h p]=ttest(finFal(:,1),finFal(:,2),.05,'left')


sum(finPer(:,1)>finPer(:,2));

save 'estimate.mat' estPer
save 'final.mat' finPer
save 'estFailed.mat' estFal

clear

end