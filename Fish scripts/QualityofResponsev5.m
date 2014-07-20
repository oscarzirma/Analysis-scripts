function QualityofResponsev5()
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

%version 5 plots each angle and distance trajectory, asking for 'initial
%response,' 'initial estimate,' and 'final estimate.'  Initial response is
%after the fish just begins to move or turn toward the pellet. Initial
%estimate is the fish's initial interpretation of the angle. Final estimate
%is where the fish finishes its movements.
%What do I want?
%Initial Angle
%Initial Distance
%'Reaction time' (distance and angle)
%'Initial estimate' (distance and angle - the first time d/dt ->0)
%'Final estimate' (distance and angle - the closest the fish gets

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
        M(s)=m;
        
        LorR(1:m,s)=RelAng(:,1)>0;
        InitialAngle(1:m,s)=RelAng(:,1);
        InitialDistance(1:m,s)=RelDis(:,1);
        
        DistanceBest(1:m,s)=min(RelDis,[],2);      
        
        for(i=1:m)
            plot(RelDis(i,:));
            
            fprintf('Initial reaction?\n')%user input of distance rxn time
            [xC,yC]=ginput(1);
            DisRxn(i,s)=xC/20;
            
            fprintf('Initial estimate of distance?\n')
            [xC,yC]=ginput(1);
            DistanceEstimate(i,s)=RelDis(i,round(xC));
            
%             fprintf('Best estimate of distance?\n')
%             [xC,yC]=ginput(1);
%             DistanceBest(i,s)=RelDis(i,round(xC));            
                              
            plot(RelAng(i,:));
            fprintf('Initial reaction?\n')%user input of angular rxn time
            [xC,yC]=ginput(1);
            AngRxn(i,s)=xC/20;
            
            fprintf('Initial estimate of angle?\n')
            [xC,yC]=ginput(1);
            AngleEstimate(i,s)=RelAng(i,round(xC));
            
%             fprintf('Best estimate of angle?\n\n')
%             [xC,yC]=ginput(1);
%             AngleBest(i,s)=RelAng(i,round(xC));

            [y,j]=min(abs(RelAng(i,:)),[],2);
            AngleBest(i,s)=RelAng(i,j);

            S=input('Success?(1 or 0)')
            Success(i,s)=S;
            
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

dlmwrite('v5Out.txt','Initial Angle','delimiter','')
dlmwrite('v5Out.txt',InitialAngle,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt',sum(InitialAngle)./M,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt','Initial Distance','delimiter','','-append')
dlmwrite('v5Out.txt',InitialDistance,'delimiter','\t','-append')
dlmwrite('v5Out.txt',sum(InitialDistance)./M,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')

dlmwrite('v5Out.txt','Reaction Times','delimiter','','-append')
dlmwrite('v5Out.txt','Angle Reaction Time','delimiter','','-append')
dlmwrite('v5Out.txt',AngRxn,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt',sum(AngRxn)./M,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt','Distance Reaction Time','delimiter','','-append')
dlmwrite('v5Out.txt',DisRxn,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt',sum(DisRxn)./M,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')

dlmwrite('v5Out.txt','Estimates','delimiter','','-append')
dlmwrite('v5Out.txt','Angle Estimate','delimiter','','-append')
dlmwrite('v5Out.txt',AngleEstimate,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt',sum(abs(AngleEstimate))./M,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt','Distance Estimate','delimiter','','-append')
dlmwrite('v5Out.txt',DistanceEstimate,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt',sum(DistanceEstimate)./M,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')

dlmwrite('v5Out.txt','Best Estimates','delimiter','','-append')
dlmwrite('v5Out.txt','Angle Best','delimiter','','-append')
dlmwrite('v5Out.txt',AngleBest,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt',sum(abs(AngleBest))./M,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt','Distance Best','delimiter','','-append')
dlmwrite('v5Out.txt',DistanceBest,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt',sum(DistanceBest)./M,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')

dlmwrite('v5Out.txt','Success','delimiter','','-append')
dlmwrite('v5Out.txt',Success,'delimiter','\t','-append')
dlmwrite('v5Out.txt','!','delimiter','\t','-append')
dlmwrite('v5Out.txt',sum(Success)./M,'delimiter','\t','-append')


close

return