function [Events]=EOG_HT_behav_analys_v2(eog,ht)
%This program analyses EOG and headtracker data from behavioral trials. The
%basic strategy is:
% 1. Load workspace.
% 2. Detect events in the different traces for each trial.
% 3. For each trial, display all three traces with the events indicated. If there are large errors, the user can press 'e'. And then each type of trace will be displayed and the user will indicate the timing of events. The program will then continue to the next trial. Any other keypress besides 'e' will continue to the next trial.
% 4. Build and display a raster plot for each of the three event types.
%Input variables:
% eog - a cell array of eog activity for each trial. time in first row, eog in second row
% ht - a cell array of headtracker activity for each trial. time, az, el, roll, x, y, x
%V2 - updated for 2 EOG channels and for optitrack outputs

n=length(eog);

for k =1:n
    
    e=cell2mat(eog(k));%acquire eog data in matrix form
    
    if(k==1)
        te=e(1,:);
    end%time index
    e1=e(2,:);%left eye
    e2=e(3,:);%right eye
    %e1f=loadLPFilter(e1,30,.5);%filter eog TURN OFF FILTERING TO SAVE TIME

%     subplot(211)
%     plot(e1f)
    
    e1d=diff(e1);ted=te(1:end-1);%differentiate eog and replace time index
    e2d=diff(e2)
%     subplot(212)
%     plot(e1fd);pause
    
    hti=cell2mat(ht(k));%acquire headtracker data in matrix form
    
    htid=diff(hti,1,2);%diff of headtracker
    htid(1,:)=hti(1,1:end-1);%replace time index with non-diff version
    
    for i=2:4%Since these are angles, sometimes there are discontinuities when it jumps from positive to negative, so we remove any points with values great then ±50
        x=find(abs(htid(i,:))>100);
        if(x)
            
            for j=1:length(x)
                htid(i,x(j))=mean(htid(i,:));
            end
        end
    end
    
    %Time conversion values
    timeConversionEOG=ted(end)/length(e1fd);
    timeConversionHT=hti(1,end)/length(hti(2,:));
    
    %Find eog events in which the diff crosses the threshold of .004
    eogThresh=find(abs(e1fd)>.005);eogEvents=[];
    
    %Remove those events not separated by at least 50 ms
    if(eogThresh)
        interval=round(50/timeConversionEOG);
        eogEvents=eogThresh(1);j=2;
        for (i=2:length(eogThresh))
            
            if eogThresh(i)>=eogEvents(j-1)+interval
                eogEvents(j)=eogThresh(i);
                j=j+1;
            end
        end
    end
    
    eogEvents=eogEvents.*timeConversionEOG;%Convert time base
    htEvents=[];
    
    interval=round(100/timeConversionHT);
    for(i=2:7)%Find HT events
        tmp=(find(abs(htid(i,:))>4));
        if(tmp)
            tmpEv=tmp(1);j=2;
            for in=2:length(tmp)
                if(tmp(in)>=tmpEv(j-1)+interval)
                    tmpEv(j)=tmp(in);
                    j=j+1;
                end
            end
        end
        htEvents(i-1,1:length(tmpEv))=tmpEv.*timeConversionHT;
        
        Events(k).ht=htEvents;
        Events(k).eog=eogEvents;
    end
%                 size(e1f)-size(e1)

    if ~(mod(k,100))

        show_ht_eog_data_diff([te;e1f],hti,[ted;e1fd],htid,eogEvents,htEvents);
        pause()
        %show_ht_eog_data([ted;e1fd],htid);
        
        close all;
        
        
    end
    
end
figure;hold on;
for i=1:n
    tmp=Events(i).ht;
    A=tmp(1:3,:);A=A(:);%plot az/el/ro
    o=ones(size(A)).*i;
    scatter(A,o,'k');
    A=tmp(4:6,:);A=A(:);%plot x/y/z
    o=ones(size(A)).*i;
    scatter(A,o,'b');
    p=ones(size(Events(i).eog)).*i;%plot eog
    scatter(Events(i).eog,p,'r');
end











