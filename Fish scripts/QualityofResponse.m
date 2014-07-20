function QualityofResponse()
%Given a folder containing a fish's response over time with one directory
%for each date, this program will open each date and assess the quality of
%the fish's response by analyzing the RelAng variable.
%Initial analysis: 
%left or right (1 if left turn)
%within 40° of 0° within 1.5s (1 if successful)

directory=uigetdir('/Users/behavior/Desktop/Behavior/')
cd(directory)
file=dir();
pwd
s=1;
for(i=3:length(file))
    
    cd(directory)
    if(file(i).isdir)
        cd([directory '/' file(i).name '/' file(i).name 'Data'])
        pwd
        
        load('RelAng4s.mat');
        m=size(RelAng,1);
        LorR(1:m,s)=RelAng(:,1)>0;
        
        Mean(1:m,s)=mean(RelAng(:,28:32),2);
        Succ(1:m,s+1)=abs(Mean(1:m,s))<40;
        M(s)=m;
        s=s+1;
            
        
    end
end
%Mean=abs(Mean);
cd(directory)

dlmwrite('LorR.txt',LorR,'delimiter','\t')
dlmwrite('LorR.txt','!','-append')
dlmwrite('LorR.txt',sum(LorR)./M,'delimiter','\t','-append')
dlmwrite('LorR.txt',M,'delimiter','\t','-append')

dlmwrite('Mean.txt',Mean,'delimiter','\t')
dlmwrite('Mean.txt','!','delimiter','\t','-append')
dlmwrite('Mean.txt',sum(abs(Mean))./M,'delimiter','\t','-append')

dlmwrite('Succ.txt',Succ,'delimiter','\t')
dlmwrite('Succ.txt','!','delimiter','\t','-append')
dlmwrite('Succ.txt',sum(Succ(:,2:end))./M,'delimiter','\t','-append')

[m n]=size(Succ);

Overall(1,:)=M;
Overall(2,:)=sum(LorR)./M;
Overall(3,:)=sum(abs(Mean))./M;
Overall(4,:)=sum(Succ(:,2:end))./M;
dlmwrite('Overall.txt',Overall,'delimiter','\t')


return