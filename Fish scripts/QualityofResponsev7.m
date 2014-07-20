function QualityofResponsev7(Ridges,Baselines)
%Given a folder containing a fish's response over time with one directory
%for each date, this program will open each date and assess the quality of
%the fish's response by analyzing the RelAng variable.
%Initial analysis:
%left or right (1 if left turn)
%within 40° of 0° within 1.5s (1 if successful)
%version 3 adds independent left and write files.
%version 4 calculates d/dt of angle and distance, and uses them to
%determine the time to take the fish's 'best estimate' of the angle. it
%will look for the maximum d/dt of distance or a local minimum d/dt of
%angle (local within set interval e.g. 15-35 frames (.75-1.75seconds)

%Version 6 uses the fish's abstract angle to determine when the fish has
%'decided' on an initial estimate of angle. The criteria to determine when
%the fish has 'decided' is when the absolute value of the running average (window size 5) of the
%instantaneous differential (diff()) is <1 after the 10th frame of the
%response. The initial estimate of distance is taken as <.015.
%The RelAng value at the index is then taken to be the fish's
%estimate of distance. Version 6 estimates the reaction time by looking for
%the first index where the absolute value of diff RelAng >5 or RelDis is
%>0.5.
%Ridges argument is a vector of indices of the dates when ridges were added. It
%is used to output a ttest between the pooled ridge and nonridge experiments
%as well as the mean, stdev, and std error.

%Version 7 - eliminate the values where distance best is not less than 1
%from the pooled analysis

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
        load('FishAngle.mat');
        m=size(RelAng,1);
        M(s)=m;
        
        dAng=diff(Angle,1,2);
        dRelDis=diff(RelDis,1,2);
        
        %         dAngRA5=filter(ones(1,5)/5,1,dAng);%is this the right dimension to filter?
        %         dRelDisRA5=filter(ones(1,5)/5,1,dRelDis);
        
        
        
        LorR(1:m,s)=RelAng(:,1)>0;
        InitialAngle(1:m,s)=RelAng(:,1);
        InitialDistance(1:m,s)=RelDis(:,1);
        
        DistanceBest(1:m,s)=min(RelDis,[],2);
        
        for(i=1:m)
            
            %            fprintf('Initial reaction?\n')%user input of distance rxn time
            
            x=find(dRelDis(i,2:end)<-.1);
            x=xempty(x);
            
            DisRxn(i,s)=(x(1)+1)/20;
            
            %           fprintf('Initial estimate of distance?\n')
            
            x=find(abs(dRelDis(i,20:end))<.01);
            x=xempty(x);
            DistanceEstimate(i,s)=RelDis(i,x(1));
            
            
            
            %            fprintf('Initial reaction?\n')%user input of angular rxn time
            
            x=find(abs(dAng(i,2:end))>5);
            x=xempty(x);
            AngRxn(i,s)=(x(1)+1)/20;
            
            
            %            fprintf('Initial estimate of angle?\n')
            
            x=find(abs(dAng(i,20:end))<5);
            x=xempty(x);
            AngleEstimate(i,s)=RelAng(i,x(1)+19);
%             AngRxn(i,s)*20
%             x(1)
%             x(1)+AngRxn(i,s)*20+10
%             
%                                 plot(Angle(1,:))
%                     hold on
%                     plot(RelAng(i,:),'color',[0 0 0])
%                     plot(dAng(i,:),'color','green')
%                     plot(x(1)+AngRxn(i,s)*20+10,RelAng(i,x(1)+AngRxn(i,s)*20+10),'r*')
%                     plot(AngRxn(i,s)*20,RelAng(i,AngRxn(i,s)*20),'b*')
%                     pause
%                     close
            
            %             fprintf('Best estimate of angle?\n\n')
            %             [xC,yC]=ginput(1);
            %             AngleBest(i,s)=RelAng(i,round(xC));
            
            [y,j]=min(abs(RelAng(i,:)),[],2);
            AngleBest(i,s)=RelAng(i,j);
            
        end
        
        s=s+1;
        save progress
        
    end
end


%Mean=abs(Mean);
cd(directory)
%
dlmwrite('LorR.txt',LorR,'delimiter','\t')
dlmwrite('LorR.txt','!','-append')
dlmwrite('LorR.txt',sum(LorR)./M,'delimiter','\t','-append')
dlmwrite('LorR.txt',M,'delimiter','\t','-append')


dlmwrite('v6Out.txt','Initial Angle','delimiter','')
dlmwrite('v6Out.txt',InitialAngle,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt',sum(InitialAngle)./M,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt','Initial Distance','delimiter','','-append')
dlmwrite('v6Out.txt',InitialDistance,'delimiter','\t','-append')
dlmwrite('v6Out.txt',sum(InitialDistance)./M,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')

dlmwrite('v6Out.txt','Reaction Times','delimiter','','-append')
dlmwrite('v6Out.txt','Angle Reaction Time','delimiter','','-append')
dlmwrite('v6Out.txt',AngRxn,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt',sum(AngRxn)./M,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt','Distance Reaction Time','delimiter','','-append')
dlmwrite('v6Out.txt',DisRxn,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt',sum(DisRxn)./M,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')

dlmwrite('v6Out.txt','Estimates','delimiter','','-append')
dlmwrite('v6Out.txt','Angle Estimate','delimiter','','-append')
dlmwrite('v6Out.txt',AngleEstimate,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt',sum(abs(AngleEstimate))./M,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt','Distance Estimate','delimiter','','-append')
dlmwrite('v6Out.txt',DistanceEstimate,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt',sum(DistanceEstimate)./M,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')

dlmwrite('v6Out.txt','Best Estimates','delimiter','','-append')
dlmwrite('v6Out.txt','Angle Best','delimiter','','-append')
dlmwrite('v6Out.txt',AngleBest,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt',sum(abs(AngleBest))./M,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt','Distance Best','delimiter','','-append')
dlmwrite('v6Out.txt',DistanceBest,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt',sum(DistanceBest)./M,'delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')
dlmwrite('v6Out.txt','!','delimiter','\t','-append')

if(~isempty(Ridges))%Pool the results from the rigde experiments and baseline experiments
    
    RidgeDI=InitialDistance(:,Ridges);%Initial values
    BaselineDI=InitialDistance(:,Baselines);
    RidgeDI=RidgeDI(:);BaselineDI=BaselineDI(:);%Vectorize the matrices
    RidgeDI=RidgeDI(RidgeDI~=0);BaselineDI=BaselineDI(BaselineDI~=0);%Remove Zeroes
    
    RidgeAI=InitialAngle(:,Ridges);
    BaselineAI=InitialAngle(:,Baselines);
    RidgeAI=RidgeAI(:);BaselineAI=BaselineAI(:);
    RidgeAI=RidgeAI(RidgeAI~=0);BaselineAI=BaselineAI(BaselineAI~=0);
    
    RidgeDR=DisRxn(:,Ridges);%Reaction Times
    BaselineDR=DisRxn(:,Baselines);
    RidgeDR=RidgeDR(:);BaselineDR=BaselineDR(:);
    RidgeDR=RidgeDR(RidgeDR~=0);BaselineDR=BaselineDR(BaselineDR~=0);
    
    RidgeAR=AngRxn(:,Ridges);
    BaselineAR=AngRxn(:,Baselines);
    RidgeAR=RidgeAR(:);BaselineAR=BaselineAR(:);
    RidgeAR=RidgeAR(RidgeAR~=0);BaselineAR=BaselineAR(BaselineAR~=0);
    
    RidgeDE=DistanceEstimate(:,Ridges);%Estimates
    BaselineDE=DistanceEstimate(:,Baselines);
    RidgeDE=RidgeDE(:);BaselineDE=BaselineDE(:);
    RidgeDE=RidgeDE(RidgeDE~=0);BaselineDE=BaselineDE(BaselineDE~=0);
    
    RidgeAE=AngleEstimate(:,Ridges);
    BaselineAE=AngleEstimate(:,Baselines);
    RidgeAE=RidgeAE(:);BaselineAE=BaselineAE(:);
    RidgeAE=RidgeAE(RidgeAE~=0);BaselineAE=BaselineAE(BaselineAE~=0);
    
    RidgeDB=DistanceBest(:,Ridges);%Best
    BaselineDB=DistanceBest(:,Baselines);
    RidgeDB=RidgeDB(:);BaselineDB=BaselineDB(:);
    RidgeDB=RidgeDB(RidgeDB~=0);BaselineDB=BaselineDB(BaselineDB~=0);
    
    RidgeAB=AngleBest(:,Ridges);
    BaselineAB=AngleBest(:,Baselines);
    RidgeAB=RidgeAB(:);BaselineAB=BaselineAB(:);
    RidgeAB=RidgeAB(RidgeAB~=0);BaselineAB=BaselineAB(BaselineAB~=0);
    
    
    %initial distance
    sB=find(BaselineDB<2);%find indices where best distance is <3
    sR=find(RidgeDB<2);
    
    RidgeDI=RidgeDI(sR);BaselineDI=BaselineDI(sB);%remove indices wehere best distance >=3
    [h p]=ttest2(RidgeDI,BaselineDI,.05,'right');
    Average=[mean(BaselineDI) mean(RidgeDI)];
    StDev=[std(BaselineDI) std(RidgeDI)];
    StErr=StDev./[sqrt(length(BaselineDI)) sqrt(length(RidgeDI))];
    
    dlmwrite('Pooled.txt','Initial Distance','delimiter','')
    dlmwrite('Pooled.txt','T-Test','delimiter','','-append')
    dlmwrite('Pooled.txt',p,'delimiter','','-append')
    dlmwrite('Pooled.txt','Mean(B R)','delimiter','','-append')
    dlmwrite('Pooled.txt',Average,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StDev','delimiter','','-append')
    dlmwrite('Pooled.txt',StDev,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StErr','delimiter','','-append')
    dlmwrite('Pooled.txt',StErr,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','!','delimiter','','-append')
    
    %initial angle
    RidgeAI=RidgeAI(sR);BaselineAI=BaselineAI(sB);
    [h p]=ttest2(RidgeAI,BaselineAI,.05,'right');
    Average=[mean(BaselineAI) mean(RidgeAI)];
    StDev=[std(BaselineAI) std(RidgeAI)];
    StErr=StDev./[sqrt(length(BaselineAI)) sqrt(length(RidgeAI))];
    
    dlmwrite('Pooled.txt','Initial Angle','delimiter','','-append')
    dlmwrite('Pooled.txt','T-Test','delimiter','','-append')
    dlmwrite('Pooled.txt',p,'delimiter','','-append')
    dlmwrite('Pooled.txt','Mean(B R)','delimiter','','-append')
    dlmwrite('Pooled.txt',Average,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StDev','delimiter','','-append')
    dlmwrite('Pooled.txt',StDev,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StErr','delimiter','','-append')
    dlmwrite('Pooled.txt',StErr,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','!','delimiter','','-append')
    
    %distance rxn
    RidgeDR=RidgeDR(sR);BaselineDR=BaselineDR(sB);
    [h p]=ttest2(RidgeDR,BaselineDR,.05,'right');
    Average=[mean(BaselineDR) mean(RidgeDR)];
    StDev=[std(BaselineDR) std(RidgeDR)];
    StErr=StDev./[sqrt(length(BaselineDR)) sqrt(length(RidgeDR))];
    
    dlmwrite('Pooled.txt','Distance Reaction','delimiter','','-append')
    dlmwrite('Pooled.txt','T-Test','delimiter','','-append')
    dlmwrite('Pooled.txt',p,'delimiter','','-append')
    dlmwrite('Pooled.txt','Mean(B R)','delimiter','','-append')
    dlmwrite('Pooled.txt',Average,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StDev','delimiter','','-append')
    dlmwrite('Pooled.txt',StDev,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StErr','delimiter','','-append')
    dlmwrite('Pooled.txt',StErr,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','!','delimiter','','-append')
    
    %angle reaction
    RidgeAR=RidgeAR(sR);BaselineAR=BaselineAR(sB);
    [h p]=ttest2(RidgeAR,BaselineAR,.05,'right');
    Average=[mean(BaselineAR) mean(RidgeAR)];
    StDev=[std(BaselineAR) std(RidgeAR)];
    StErr=StDev./[sqrt(length(BaselineAR)) sqrt(length(RidgeAR))];
    
    dlmwrite('Pooled.txt','Angle Reaction','delimiter','','-append')
    dlmwrite('Pooled.txt','T-Test','delimiter','','-append')
    dlmwrite('Pooled.txt',p,'delimiter','','-append')
    dlmwrite('Pooled.txt','Mean(B R)','delimiter','','-append')
    dlmwrite('Pooled.txt',Average,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StDev','delimiter','','-append')
    dlmwrite('Pooled.txt',StDev,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StErr','delimiter','','-append')
    dlmwrite('Pooled.txt',StErr,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','!','delimiter','','-append')
    
    %distance estimate
    RidgeDE=RidgeDE(sR);BaselineDE=BaselineDE(sB);
    [h p]=ttest2(RidgeDE,BaselineDE,.05,'right');
    Average=[mean(BaselineDE) mean(RidgeDE)];
    StDev=[std(BaselineDE) std(RidgeDE)];
    StErr=StDev./[sqrt(length(BaselineDE)) sqrt(length(RidgeDE))];
    
    dlmwrite('Pooled.txt','Distance Estimate','delimiter','','-append')
    dlmwrite('Pooled.txt','T-Test','delimiter','','-append')
    dlmwrite('Pooled.txt',p,'delimiter','','-append')
    dlmwrite('Pooled.txt','Mean(B R)','delimiter','','-append')
    dlmwrite('Pooled.txt',Average,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StDev','delimiter','','-append')
    dlmwrite('Pooled.txt',StDev,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StErr','delimiter','','-append')
    dlmwrite('Pooled.txt',StErr,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','!','delimiter','','-append')
    
    %angle estimate
    RidgeAE=RidgeAE(sR);BaselineAE=BaselineAE(sB);
    [h p]=ttest2(abs(RidgeAE),abs(BaselineAE),.05,'right');
    Average=[mean(abs(BaselineAE)) mean(abs(RidgeAE))];
    StDev=[std(abs(BaselineAE)) std(abs(RidgeAE))];
    StErr=StDev./[sqrt(length(BaselineAE)) sqrt(length(RidgeAE))];
    
    dlmwrite('Pooled.txt','Angle Estimate','delimiter','','-append')
    dlmwrite('Pooled.txt','T-Test','delimiter','','-append')
    dlmwrite('Pooled.txt',p,'delimiter','','-append')
    dlmwrite('Pooled.txt','Mean(B R)','delimiter','','-append')
    dlmwrite('Pooled.txt',Average,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StDev','delimiter','','-append')
    dlmwrite('Pooled.txt',StDev,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StErr','delimiter','','-append')
    dlmwrite('Pooled.txt',StErr,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','!','delimiter','','-append')
    
    %best distance
    RidgeDB=RidgeDB(sR);BaselineDB=BaselineDB(sB);
    [h p]=ttest2(RidgeDB,BaselineDB,.05,'right');
    Average=[mean(abs(BaselineDB)) mean(abs(RidgeDB))];
    StDev=[std(abs(BaselineDB)) std(abs(RidgeDB))];
    StErr=StDev./[sqrt(length(BaselineDB)) sqrt(length(RidgeDB))];
    
    dlmwrite('Pooled.txt','Distance Best','delimiter','','-append')
    dlmwrite('Pooled.txt','T-Test','delimiter','','-append')
    dlmwrite('Pooled.txt',p,'delimiter','','-append')
    dlmwrite('Pooled.txt','Mean(B R)','delimiter','','-append')
    dlmwrite('Pooled.txt',Average,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StDev','delimiter','','-append')
    dlmwrite('Pooled.txt',StDev,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StErr','delimiter','','-append')
    dlmwrite('Pooled.txt',StErr,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','!','delimiter','','-append')
    
    %best angle
    RidgeAB=RidgeAB(sR);BaselineAB=BaselineAB(sB);
    [h p]=ttest2(abs(RidgeAB),abs(BaselineAB),.05,'right');
    Average=[mean(abs(BaselineAB)) mean(abs(RidgeAB))];
    StDev=[std(abs(BaselineAB)) std(abs(RidgeAB))];
    StErr=StDev./[sqrt(length(BaselineAB)) sqrt(length(RidgeAB))];
    
    dlmwrite('Pooled.txt','Angle Best','delimiter','','-append')
    dlmwrite('Pooled.txt','T-Test','delimiter','','-append')
    dlmwrite('Pooled.txt',p,'delimiter','','-append')
    dlmwrite('Pooled.txt','Mean(B R)','delimiter','','-append')
    dlmwrite('Pooled.txt',Average,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StDev','delimiter','','-append')
    dlmwrite('Pooled.txt',StDev,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','StErr','delimiter','','-append')
    dlmwrite('Pooled.txt',StErr,'delimiter','\t','-append')
    dlmwrite('Pooled.txt','!','delimiter','','-append')
    
    
    %output estimated angle vs initial angle
    
    %RidgeAI(RidgeAI~=0);%remove zero values
    %RidgeAE=RidgeAE(RidgeAE~=0) ;
    %BaselineAI=BaselineAI(BaselineAI~=0);%remove zero values
    %BaselineAE=BaselineAE(BaselineAE~=0);
        
    dlmwrite('RidgeInitvsEst.txt','Angles - Ridge','delimiter','')
    dlmwrite('RidgeInitvsEst.txt','Initial - Estimate','delimiter','','-append')
    dlmwrite('RidgeInitvsEst.txt',[RidgeAI RidgeAE],'delimiter','\t','-append')
    
    dlmwrite('BaselineInitvsEst.txt','Angles - Baseline','delimiter','')
    dlmwrite('BaselineInitvsEst.txt','Initial - Estimate','delimiter','','-append')
    dlmwrite('BaselineInitvsEst.txt',[BaselineAI BaselineAE],'delimiter','\t','-append')
    
    
end

cd ..
close

end

function x=xempty(x)
if(isempty(x))
    x=1;
end
end