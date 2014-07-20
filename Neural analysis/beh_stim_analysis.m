function [allSpikes stimSpikes]=beh_stim_analysis(neural_data,stim_pos,thresh,flash_time,sort_order,window)
%Accepts a neural_data array and a stim_pos array. Imports the neural data,
%plots it and asks whether any trials need to be removed, and, if so, what
%the positive and negative thresholds should be for removal. The program
%will then filter the traces between 600 Hz and 2000 Hz. It will then save
%the filtered neural data in case the program is interrupted. stim_pos and
%the neural traces will then be sorted based on a sort defined by sort_order
%of stim_pos. Events will then be detected based on the
%thresh value given and displayed. Following a pause, the Events will be
%displayed by stimulus location and synchronized to the flash_time with a
%50 ms pad preceding and 350 ms pad following that time. The window is a
%two element vector specifying the period for which to count spikes. the
%first element indicates the starting time in s and the second the duration
%in s.

if exist('beh_stim_analysis workspace.mat')
    load('beh_stim_analysis workspace.mat')
else

    n=length(neural_data);
    for i=1:n%import neural data
        x=cell2mat(neural_data(i));
        N(i,:)=x(2,:);
    end
    
    t=x(1,:);
    figure;
    plot(t,N');
    
    s=input('Do traces need to be removed? (y/n)','s');%Find out if some traces are bad, find the thresholds for determining this, and remove bad traces.
    if(s=='y')
        mx=input('Maximum value?');
        mn=input('Minimum value?');
        real=max(N')<mx;
        N=N(real,:);
        stim_pos=stim_pos(real,:);
        real=min(N')>mn;
        N=N(real,:);stim_pos=stim_pos(real,:);
    end
    close(gcf)
    n=size(N,1);
    
    display('filtering...')
    
    Nf=batchbandpassFilter(N,600,2000,24414);%filter
    
    plot(t,Nf')
    title('Filtered traces');
    
    save('beh_stim_analysis workspace','N','Nf','n','stim_pos','t')
    
end

[sort_stim_pos I]=sortrows(stim_pos,sort_order);%sort
Nfs=Nf(I,1220:end);

Events=batch_threshSpikes(Nfs,thresh,24414);%find spikes
displayEvents(Events);

j=1;groupID=1;flashEvent(1).spk=.06;%initiations for groupID and flashEvent
group_title(1)={['x=' num2str(sort_stim_pos(1,1)) ' y=' num2str(sort_stim_pos(1,2))]};

for i=2:n
    flashEvent(i).spk=flash_time;
    if(sum(sort_stim_pos(i,1:2)~=sort_stim_pos(i-1,1:2)))
        j=j+1;
        group_title(j)={['x=' num2str(sort_stim_pos(i,1)) 'y=' num2str(sort_stim_pos(i,2))]};
    end
    groupID(i,1)=j;
end

allSpikes=display_Syncd_Spikes_Stimulus_Sort(flashEvent,Events,.05,.35,groupID,group_title);

for i=1:length(allSpikes)
    h=hist(allSpikes(i).spk,80);
    
    stimSpikes(i)=sum(h([window(1)/.005:window(1)/.005+window(2)/.005]))./sum(h);
end
figure;plot(stimSpikes)
    
end






