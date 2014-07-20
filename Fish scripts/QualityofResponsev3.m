function QualityofResponsev3()
%Given a folder containing a fish's response over time with one directory
%for each date, this program will open each date and assess the quality of
%the fish's response by analyzing the RelAng variable.
%Initial analysis: 
%left or right (1 if left turn)
%within 40° of 0° within 1.5s (1 if successful)
%version 3 adds independent left and write files.

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
        load('RelDis4s.mat');
        m=size(RelAng,1);
        LorR(1:m,s)=RelAng(:,1)>0;
        
        f=find(LorR(1:m,s));
        fp=find(-LorR(1:m,s)+ones(size(LorR(1:m,s))));
        
        Mean(1:m,s)=mean(RelAng(:,28:32),2);
        Succ(1:m,s+1)=abs(Mean(1:m,s))<40;
        M(s)=m;
        
 
        flen=length(f);
        fplen=length(fp);
        lM(s)=flen;
        rM(s)=fplen;
        
        J(s)=0;
        for(i=1:m)
            It=find(RelDis(i,:)<=1,1);
            if(It)
                Ang(i,s)=RelAng(i,It);
            else
                Ang(i,s)=200;
                J(s)=J(s)+1;
            end
        end
        
        Succ2(1:m,s)=abs(Ang(1:m,s))<40;
       
        
        lMean(1:flen,s)=Mean(f,s);
        rMean(1:fplen,s)=Mean(fp,s);
        lAng(1:flen,s)=Ang(f,s);
        rAng(1:fplen,s)=Ang(fp,s);
        
        lSucc2(1:flen,s)=abs(lAng(1:flen,s))<40;
        rSucc2(1:fplen,s)=abs(rAng(1:fplen,s))<40;
        
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

dlmwrite('Ang.txt',Ang,'delimiter','\t')
dlmwrite('Ang.txt','!','delimiter','\t','-append')
dlmwrite('Ang.txt',sum(abs(Ang))-J.*200./(M-J),'delimiter','\t','-append')

dlmwrite('Succ2.txt',Succ2,'delimiter','\t')
dlmwrite('Succ2.txt','!','delimiter','\t','-append')
dlmwrite('Succ2.txt',sum(Succ2)./M,'delimiter','\t','-append')

dlmwrite('DirA.txt','Left Means','delimiter','')
dlmwrite('DirA.txt',lMean,'delimiter','\t','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')
dlmwrite('DirA.txt','Left Angles','delimiter','','-append')
dlmwrite('DirA.txt',lAng,'delimiter','\t','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')
dlmwrite('DirA.txt','Left AngSuccess','delimiter','','-append')
dlmwrite('DirA.txt',lSucc2,'delimiter','\t','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')

dlmwrite('DirA.txt','Right Means','delimiter','','-append')
dlmwrite('DirA.txt',rMean,'delimiter','\t','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')
dlmwrite('DirA.txt','Right Angles','delimiter','','-append')
dlmwrite('DirA.txt',rAng,'delimiter','\t','-append')
dlmwrite('DirA.txt','Right AngSuccess','delimiter','','-append')
dlmwrite('DirA.txt',rSucc2,'delimiter','\t','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')

dlmwrite('DirA.txt','Number of trials/Prop Left','delimiter','','-append')
dlmwrite('DirA.txt','Mean,L/R','delimiter','','-append')
dlmwrite('DirA.txt','Ang,L/R','delimiter','','-append')
dlmwrite('DirA.txt','Success,L/R','delimiter','','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')

dlmwrite('DirA.txt',M,'delimiter','\t','-append')
dlmwrite('DirA.txt',sum(LorR)./M,'delimiter','\t','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')

dlmwrite('DirA.txt',sum(abs(lMean))./lM,'delimiter','\t','-append')
dlmwrite('DirA.txt',sum(abs(rMean))./rM,'delimiter','\t','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')


lefties=sum(lAng==200);
righties=sum(rAng==200);

dlmwrite('DirA.txt',(sum(abs(lAng))-lefties.*200)./(lM-lefties),'delimiter','\t','-append')
dlmwrite('DirA.txt',(sum(abs(rAng))-righties.*200)./(rM-righties),'delimiter','\t','-append')
dlmwrite('DirA.txt','!','delimiter','\t','-append')

dlmwrite('DirA.txt',sum(lSucc2)./lM,'delimiter','\t','-append')
dlmwrite('DirA.txt',sum(rSucc2)./rM,'delimiter','\t','-append')




return