u=unique(stim_contrast_command);
l=length(u);

time_out=zeros(l);
box_on_nogo=zeros(l);
incorrent_response=zeros(l);
nogo_on_go=zeros(l);
success=zeros(l);
nogo_on_nogo=zeros(l);
gaze_trigger_reward=zeros(l);
%for i=1:l x=succFlag_index(stim_contrast_command==u(1,i));n=length(x);u(2,i)=sum(x==-5)/n;u(3,i)=sum(x==-2)/n;u(4,i)=sum(x==1)/n;u(5,i)=sum(x==-1)/n;u(6,i)=n;end
if posner_enable %posner enable
    con_val=stim_contrast_command(find(val_posner(1:trial_counter)));
    con_inval=stim_contrast_command(find(~val_posner(1:trial_counter)));
    val=succFlag_index(find(val_posner(1:trial_counter)));
    inval=succFlag_index(find(~val_posner(1:trial_counter)));
    
    for i=1:l x=val(con_val==u(1,i));n=length(x);u(2,i)=sum(x==-5)/n;u(3,i)=sum(x==-3)/n;u(4,i)=sum(x==-2)/n;u(5,i)=sum(x==-1)/n;u(6,i)=sum(x==1)/n;u(7,i)=sum(x==2)/n;u(8,i)=sum(x==8)/n;u(9,i)=n;c(i)=sum(x==1)/(sum(x==1)+sum(x==-2));end
    figure;bar(1:l,u(2:end-1,:)','stacked');
    set(gca,'XTickLabel',cellstr(num2str(u(1,:)',2)))
    title('Go responses - Congruent')
    legend('Time out','Box on nogo','Incorrect response','Nogo on go','Success','Nogo on nogo','Gaze trigger reward')
    figure;bar(1:l,c);
    set(gca,'XTickLabel',u(1,:))
    title('% Correct responses - Congruent')
    un=succFlag_index(find(nogo_index));
    figure;hist(un);
    title('Nogo responses - Congruent')
    
    for i=1:l x=inval(con_inval==u(1,i));n=length(x);u(2,i)=sum(x==-5)/n;u(3,i)=sum(x==-3)/n;u(4,i)=sum(x==-2)/n;u(5,i)=sum(x==-1)/n;u(6,i)=sum(x==1)/n;u(7,i)=sum(x==2)/n;u(8,i)=sum(x==8)/n;u(9,i)=n;c(i)=sum(x==1)/(sum(x==1)+sum(x==-2));end
    figure;bar(1:l,u(2:end-1,:)','stacked');
    set(gca,'XTickLabel',cellstr(num2str(u(1,:)',2)))
    title('Go responses - Incongruent')
    legend('Time out','Box on nogo','Incorrect response','Nogo on go','Success','Nogo on nogo','Gaze trigger reward')
    figure;bar(1:l,c);
    set(gca,'XTickLabel',u(1,:))
    title('% Correct responses - Incongruent')
    un=succFlag_index(find(nogo_index));
    figure;hist(un);
    title('Nogo responses - Incongruent')
elseif enable_distractor %if a distractor is present
    ud=unique(distractor_contrast_command);
    ld=length(ud);
    if TD_enable%&&(td_valid<1||cue_frequency<1)%distractor present and both valid and invalid cues
        if td_valid<1
            ti=0;
        else
            ti=-1;
        end
        for i=1:l
            x=succFlag_index(stim_contrast_command==u(1,i)&td_index==1);
            y=succFlag_index(stim_contrast_command==u(1,i)&td_index==ti);
            n=length(x);
            o=length(y);
            %performance on valid trials
            u(2,i)=sum(x==-5)/n;%
            u(3,i)=sum(x==-3)/n;
            u(4,i)=sum(x==-2)/n;
            u(5,i)=sum(x==-1)/n;
            u(6,i)=sum(x==1)/n;
            u(7,i)=sum(x==2)/n;
            u(8,i)=sum(x==8)/n;
            u(9,i)=n;c(i)=sum(x==1)/(sum(x==1)+sum(x==-2));
            
            %performance on invalid trials
            w(2,i)=sum(y==-5)/o;%
            w(3,i)=sum(y==-3)/o;
            w(4,i)=sum(y==-2)/o;
            w(5,i)=sum(y==-1)/o;
            w(6,i)=sum(y==1)/o;
            w(7,i)=sum(y==2)/o;
            w(8,i)=sum(y==8)/o;
            w(9,i)=o;cw(i)=sum(y==1)/(sum(y==1)+sum(y==-2));
            for j=1:ld
                
                x=succFlag_index(stim_contrast_command==u(1,i)&distractor_contrast_command==ud(1,j)&td_index==1);
                y=succFlag_index(stim_contrast_command==u(1,i)&distractor_contrast_command==ud(1,j)&td_index==ti);
                n=length(x);
                o=length(y);
                
                rv=reaction_time(stim_contrast_command==u(1,i)&distractor_contrast_command==ud(1,j)&td_index==1);
                ri=reaction_time(stim_contrast_command==u(1,i)&distractor_contrast_command==ud(1,j)&td_index==ti);

                %performance on valid trials
                
                time_out(j,i)=sum(x==-5)/n;
                box_on_nogo(j,i)=sum(x==-3)/n;
                incorrent_response(j,i)=sum(x==-2)/n;
                nogo_on_go(j,i)=sum(x==-1)/n;
                success(j,i)=sum(x==1)/n;
                nogo_on_nogo(j,i)=sum(x==2)/n;
                gaze_trigger_reward(j,i)=sum(x==8)/n;
                percent_correct(j,i)=sum(x==1)/(sum(x==1)+sum(x==-2));
                target_contrast(j,i)=u(1,i);
                distractor_contrast(j,i)=ud(1,j);
                rxn_time(j,i) = nanmean(rv(x==1));
                
                %performance on invalid trials
                
                time_out_inv(j,i)=sum(y==-5)/o;
                box_on_nogo_inv(j,i)=sum(y==-3)/o;
                incorrent_response_inv(j,i)=sum(y==-2)/o;
                nogo_on_go_inv(j,i)=sum(y==-1)/o;
                success_inv(j,i)=sum(y==1)/o;
                nogo_on_nogo_inv(j,i)=sum(y==2)/o;
                gaze_trigger_reward_inv(j,i)=sum(y==8)/o;
                percent_correct_inv(j,i)=sum(y==1)/(sum(y==1)+sum(y==-2));
                rxn_time_inv(j,i) = nanmean(ri(y==1));
            end
        end
        %valid figures
        figure;bar(1:l,u(2:end-1,:)','stacked');
        set(gca,'XTickLabel',cellstr(num2str(u(1,:)',2)))
        title('Go responses - Valid')
        legend('Time out','Box on nogo','Incorrect response','Nogo on go','Success','Nogo on nogo','Gaze trigger reward')
        figure;bar(1:l,c);
        set(gca,'XTickLabel',u(1,:))
        title('% Correct responses - Valid')
        axis([0 l+1 0 1]);
        un=succFlag_index((nogo_index==1)&td_index==1);
        figure;hist(un);
        title('Nogo responses - Valid')
        figure;
        imagesc(percent_correct,[0 1]);
        set(gca,'XTick',1:l);
        set(gca,'YTick',1:ld);
        set(gca,'XTickLabel',u(1,:));
        set(gca,'YTickLabel',ud(1,:));
        xlabel('target contrast')
        ylabel('distractor contrast')
        colorbar
        title('%Correct distractor - Valid')

        
        %invalid figures
        figure;bar(1:l,w(2:end-1,:)','stacked');
        set(gca,'XTickLabel',cellstr(num2str(ud(1,:)',2)))
        title('Go responses - Invalid')
        legend('Time out','Box on nogo','Incorrect response','Nogo on go','Success','Nogo on nogo','Gaze trigger reward')
        figure;bar(1:l,cw);
        set(gca,'XTickLabel',ud(1,:))
        title('% Correct responses - Invalid')
        axis([0 l+1 0 1]);
        un=succFlag_index((nogo_index==1)&td_index==0);
        figure;hist(un);
        title('Nogo responses - Invalid')
        figure;
        imagesc(percent_correct_inv,[0 1]);
        set(gca,'XTick',1:l);
        set(gca,'YTick',1:ld);
        set(gca,'XTickLabel',u(1,:));
        set(gca,'YTickLabel',ud(1,:));
        xlabel('target contrast')
        ylabel('distractor contrast')
        colorbar
                title('%Correct distractor - Invalid')
                
                figure;
        imagesc(percent_correct-percent_correct_inv);
        set(gca,'XTick',1:l);
        set(gca,'YTick',1:ld);
        set(gca,'XTickLabel',u(1,:));
        set(gca,'YTickLabel',ud(1,:));
        xlabel('target contrast')
        ylabel('distractor contrast')
        colorbar
        title('Difference % Correct Valid-Invalid')

    else%distractor present but either no cues or only valid cues
        for i=1:l
            x=succFlag_index(stim_contrast_command==u(1,i));
            n=length(x);
            u(2,i)=sum(x==-5)/n;
            u(3,i)=sum(x==-3)/n;
            u(4,i)=sum(x==-2)/n;
            u(5,i)=sum(x==-1)/n;
            u(6,i)=sum(x==1)/n;
            u(7,i)=sum(x==2)/n;
            u(8,i)=sum(x==8)/n;
            u(9,i)=n;c(i)=sum(x==1)/n;
            for j=1:l
                x=succFlag_index(stim_contrast_command==u(1,i)&distractor_contrast_command==u(1,j));
                n=length(x);
                
                time_out(j,i)=sum(x==-5)/n;
                box_on_nogo(j,i)=sum(x==-3)/n;
                incorrent_response(j,i)=sum(x==-2)/n;
                nogo_on_go(j,i)=sum(x==-1)/n;
                success(j,i)=sum(x==1)/n;
                nogo_on_nogo(j,i)=sum(x==2)/n;
                gaze_trigger_reward(j,i)=sum(x==8)/n;
                percent_correct(j,i)=sum(x==1)/(sum(x==1)+sum(x==-2));
            end
        end
        figure;bar(1:l,u(2:end-1,:)','stacked');
        set(gca,'XTickLabel',cellstr(num2str(u(1,:)',2)))
        title('Go responses')
        legend('Time out','Box on nogo','Incorrect response','Nogo on go','Success','Nogo on nogo','Gaze trigger reward')
        figure;bar(1:l,c);
        set(gca,'XTickLabel',u(1,:))
        title('% Correct responses')
        axis([0 l+1 0 1]);
        un=succFlag_index(find(nogo_index));
        figure;hist(un);
        title('Nogo responses')
        figure;
        title('%Correct distractor')
        imagesc(percent_correct,[0 1]);
        set(gca,'XTick',1:l);
        set(gca,'YTick',1:ld);
        set(gca,'XTickLabel',u(1,:));
        set(gca,'YTickLabel',ud(1,:));
        xlabel('target contrast')
        ylabel('distractor contrast')
        colorbar
    end
else %no distractor or posnercues
    for i=1:l
        x=succFlag_index(stim_contrast_command==u(1,i));
        n=length(x);
        u(2,i)=sum(x==-5)/n;
        u(3,i)=sum(x==-3)/n;
        u(4,i)=sum(x==-2)/n;
        u(5,i)=sum(x==-1)/n;
        u(6,i)=sum(x==1)/n;
        u(7,i)=sum(x==2)/n;
        u(8,i)=sum(x==8)/n;
        u(9,i)=n;c(i)=sum(x==1)/n;
    end
    figure;bar(1:l,u(2:end-1,:)','stacked');
    set(gca,'XTickLabel',cellstr(num2str(u(1,:)',2)))
    title('Go responses')
    legend('Time out','Box on nogo','Incorrect response','Nogo on go','Success','Nogo on nogo','Gaze trigger reward')
    figure;bar(1:l,c);
    set(gca,'XTickLabel',u(1,:))
    axis([0 l+1 0 1]);
    title('% Correct responses')
    un=succFlag_index(find(nogo_index));
    figure;hist(un);
    title('Nogo responses')
end