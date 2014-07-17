%compare spike rate and reaction direction

rf_quadrant = 3;
non_rf_quadrant = 1;%non-RF quadrant on same hemifield
n=length(Neural);
correct_rxn_dir_hor = 1;

extract_data=1;%run data extraction scripts?
if extract_data
    for i=1:n for j=1:4 if distractor_position(i,:)==[azimuth(j) elevation(j)] distractor_pos_index(i)=j;end;end;end
    
    [SpkR son soff t rF E] = get_spikeRates(Neural,PD);%stim locked spike rates
    
    [t_psth,psth]=build_PSTH(E,son);%stim locke psth
    
    tm=detect_eye_movement(MAGR);%timing of eye movement
    [t_psth_mov,psth_mov]=build_PSTH(E,tm);%eye movement locked PSTH
    [SpkR_mov] = get_spikeRates_move(Neural,tm);%eye movement locked spike rates
    
    trb = time_to_hard_initiation+response_box_delay/1000;%time of response box onset
    [t_psth_resp,psth_resp]=build_PSTH(E,trb);%response box onset locked PSTH
    reaction_direction;
end

%%
%Stimulus-driven responses when orientation is toward versus away from RF
i_targ_rxn_dir_corr = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant;%target in RF, initial orientation response toward target
i_targ_rxn_dir_inc  = stimuli_positions==rf_quadrant&rxn_quad~=rf_quadrant;

i_dist_rxn_dir_corr = distractor_pos_index==rf_quadrant&rxn_quad==rf_quadrant;%distractor in RF, initial orientation response toward distractor
i_dist_rxn_dir_inc  = distractor_pos_index==rf_quadrant&rxn_quad~=rf_quadrant;

figure
subplot(211)
hold on
plot(t_psth,mean(psth(i_targ_rxn_dir_corr,:)),'g');
plot(t_psth,mean(psth(i_targ_rxn_dir_inc,:)),'r');
plot(t_psth,mean(psth(i_dist_rxn_dir_corr,:)),'b');
plot(t_psth,mean(psth(i_dist_rxn_dir_inc,:)),'k');
title('Correct versus incorrect target orientation responses, stim locked')
legend('To RF target','Away RF target','To RF distractor','Away RF distractor')
axis([0 .3 0 400]);
%Observations:
% Correct responses toward the target consistently lead to the largest
% spike rates, noticeably larger than responses away from the target.
% Distractor responses are harder to interpret, but the bird is heavily
% biases away from this hemifield, so there are very few trials where she
% responds to a distractor in the RF.

subplot(212)
hold on
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_corr,:)),'g');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_inc,:)),'r');
plot(t_psth_mov,mean(psth_mov(i_dist_rxn_dir_corr,:)),'b');
plot(t_psth_mov,mean(psth_mov(i_dist_rxn_dir_inc,:)),'k');
title('Correct versus incorrect target orientation responses, movement locked')
legend('To RF target','Away RF target','To RF distractor','Away RF distractor')
axis([-.4 .1 0 300]);
%Observations:
%There is a much longer firing period prior to movementwhen she makes a
% correct response to the target. This is probably due to the fact that she
% takes longer to make those decisions, so there is a larger response
% latency for correct responses when the target is in the RF.

%%
%Target responses when orientation is toward RF
i_targ_rxn_dir_corr_loC_loD = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==1&distractor_index==1;
i_targ_rxn_dir_corr_hiC_loD = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==2&distractor_index==1;
i_targ_rxn_dir_corr_loC_hiD = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==1&distractor_index==2;
i_targ_rxn_dir_corr_hiC_hiD = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==2&distractor_index==2;

figure
subplot(211)
hold on
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_loC_loD,:)),'k');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_loC_hiD,:)),'k--');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_hiC_loD,:)),'b');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_hiC_hiD,:)),'b--');
title('Correct responses to target versus contrast, stim locked')
legend('loC loD','loC hiD','hiC loD','hiC hiD')
axis([0 .3 0 550]);
%Observations:
%Higher contrast target drives larger spike rates. Distractor effect is
%weak.


subplot(212)
hold on
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_corr_loC_loD,:)),'k');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_corr_loC_hiD,:)),'k--');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_corr_hiC_loD,:)),'b');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_corr_hiC_hiD,:)),'b--');
title('Correct responses to target versus contrast, movement locked')
legend('loC loD','loC hiD','hiC loD','hiC hiD')
axis([-.4 .1 0 300]);


%%
%Target responses when orientation response is away from RF
i_targ_rxn_dir_inc_loC_loD = stimuli_positions==rf_quadrant&rxn_quad~=rf_quadrant&contrast_index==1&distractor_index==1;
i_targ_rxn_dir_inc_hiC_loD = stimuli_positions==rf_quadrant&rxn_quad~=rf_quadrant&contrast_index==2&distractor_index==1;
i_targ_rxn_dir_inc_loC_hiD = stimuli_positions==rf_quadrant&rxn_quad~=rf_quadrant&contrast_index==1&distractor_index==2;
i_targ_rxn_dir_inc_hiC_hiD = stimuli_positions==rf_quadrant&rxn_quad~=rf_quadrant&contrast_index==2&distractor_index==2;

figure
subplot(211)
hold on
plot(t_psth,mean(psth(i_targ_rxn_dir_inc_loC_loD,:)),'k');
plot(t_psth,mean(psth(i_targ_rxn_dir_inc_loC_hiD,:)),'k--');
plot(t_psth,mean(psth(i_targ_rxn_dir_inc_hiC_loD,:)),'b');
plot(t_psth,mean(psth(i_targ_rxn_dir_inc_hiC_hiD,:)),'b--');
title('Incorrect responses to target versus contrast, stim locked')
legend('loC loD','loC hiD','hiC loD','hiC hiD')
axis([0 .3 0 550]);
%Observations:
%On incorrect response trials, the low contrast target drives stonger
%responses when paired with a high contrast distractor than when paired
%with a low contrast distractor.


subplot(212)
hold on
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_inc_loC_loD,:)),'k');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_inc_loC_hiD,:)),'k--');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_inc_hiC_loD,:)),'b');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_inc_hiC_hiD,:)),'b--');
title('Incorrect responses to target versus contrast, movement locked')
legend('loC loD','loC hiD','hiC loD','hiC hiD')
axis([-.4 .1 0 300]);


%%
%Distractor responses on trials when orientation response is toward RF
i_dist_rxn_dir_corr_loC_loD = distractor_pos_index==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==1&distractor_index==1;
i_dist_rxn_dir_corr_loC_hiD = distractor_pos_index==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==2&distractor_index==1;
i_dist_rxn_dir_corr_hiC_loD = distractor_pos_index==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==1&distractor_index==2;
i_dist_rxn_dir_corr_hiC_hiD = distractor_pos_index==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==2&distractor_index==2;

figure
subplot(211)
hold on
plot(t_psth,mean(psth(i_dist_rxn_dir_corr_loC_loD,:)),'k');
plot(t_psth,mean(psth(i_dist_rxn_dir_corr_loC_hiD,:)),'k--');
plot(t_psth,mean(psth(i_dist_rxn_dir_corr_hiC_loD,:)),'b');
plot(t_psth,mean(psth(i_dist_rxn_dir_corr_hiC_hiD,:)),'b--');
title('Responses to distractor in RF versus contrast, stim locked')
legend('loC loD','loC hiD','hiC loD','hiC hiD')
axis([0 .3 0 550]);
%Observations:



subplot(212)
hold on
plot(t_psth_mov,mean(psth_mov(i_dist_rxn_dir_corr_loC_loD,:)),'k');
plot(t_psth_mov,mean(psth_mov(i_dist_rxn_dir_corr_loC_hiD,:)),'k--');
plot(t_psth_mov,mean(psth_mov(i_dist_rxn_dir_corr_hiC_loD,:)),'b');
plot(t_psth_mov,mean(psth_mov(i_dist_rxn_dir_corr_hiC_hiD,:)),'b--');
title('Responses to distractor in RF versus contrast, movement locked')
legend('loC loD','loC hiD','hiC loD','hiC hiD')
axis([-.4 .1 0 300]);


%%
%Distractor responses on trials when orientation response is away from RF
i_dist_rxn_dir_inc_loC_loD = distractor_pos_index==rf_quadrant&rxn_quad~=rf_quadrant&contrast_index==1&distractor_index==1;
i_dist_rxn_dir_inc_loC_hiD = distractor_pos_index==rf_quadrant&rxn_quad~=rf_quadrant&contrast_index==2&distractor_index==1;
i_dist_rxn_dir_inc_hiC_loD = distractor_pos_index==rf_quadrant&rxn_quad~=rf_quadrant&contrast_index==1&distractor_index==2;
i_dist_rxn_dir_inc_hiC_hiD = distractor_pos_index==rf_quadrant&rxn_quad~=rf_quadrant&contrast_index==2&distractor_index==2;

figure
subplot(211)
hold on
plot(t_psth,mean(psth(i_dist_rxn_dir_inc_loC_loD,:)),'k');
plot(t_psth,mean(psth(i_dist_rxn_dir_inc_loC_hiD,:)),'k--');
plot(t_psth,mean(psth(i_dist_rxn_dir_inc_hiC_loD,:)),'b');
plot(t_psth,mean(psth(i_dist_rxn_dir_inc_hiC_hiD,:)),'b--');
title('Responses away from distractor in RF versus contrast, stim locked')
legend('loC loD','loC hiD','hiC loD','hiC hiD')
axis([0 .3 0 600]);
%Observations:

subplot(212)
hold on
plot(t_psth_mov,mean(psth_mov(i_dist_rxn_dir_inc_loC_loD,:)),'k');
plot(t_psth_mov,mean(psth_mov(i_dist_rxn_dir_inc_loC_hiD,:)),'k--');
plot(t_psth_mov,mean(psth_mov(i_dist_rxn_dir_inc_hiC_loD,:)),'b');
plot(t_psth_mov,mean(psth_mov(i_dist_rxn_dir_inc_hiC_hiD,:)),'b--');
title('Responses away from distractor in RF versus contrast, movement locked')
legend('loC loD','loC hiD','hiC loD','hiC hiD')
axis([-.4 .1 0 300]);
%Observations:
%Clear competitor effect


%%
%%
%Cued versus uncued, correct
i_targ_rxn_dir_corr_loC_loD_cued = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==1&distractor_index==1&td_index==1;
i_targ_rxn_dir_corr_hiC_loD_cued = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==2&distractor_index==1&td_index==1;
i_targ_rxn_dir_corr_loC_hiD_cued = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==1&distractor_index==2&td_index==1;
i_targ_rxn_dir_corr_hiC_hiD_cued = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==2&distractor_index==2&td_index==1;

i_targ_rxn_dir_corr_loC_loD_uncued = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==1&distractor_index==1&td_index==-1;
i_targ_rxn_dir_corr_hiC_loD_uncued = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==2&distractor_index==1&td_index==-1;
i_targ_rxn_dir_corr_loC_hiD_uncued = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==1&distractor_index==2&td_index==-1;
i_targ_rxn_dir_corr_hiC_hiD_uncued = stimuli_positions==rf_quadrant&rxn_quad==rf_quadrant&contrast_index==2&distractor_index==2&td_index==-1;

figure
subplot(211)
hold on
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_loC_loD_cued,:)),'r');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_loC_hiD_cued,:)),'r--');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_loC_loD_uncued,:)),'k');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_loC_hiD_uncued,:)),'k--');

title('Cued correct responses to low contrast target, stim locked')
legend('cued loD','cued hiD','uncued loD','uncued hiD')
axis([0 .3 0 600]);
%Observations:
%Cue enhances early response to the target.


subplot(212)
hold on
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_hiC_loD_cued,:)),'r');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_hiC_hiD_cued,:)),'r--');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_hiC_loD_uncued,:)),'k');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_hiC_hiD_uncued,:)),'k--');

title('Cued correct responses to high contrast target, stim locked')
legend('cued loD','cued hiD','uncued loD','uncued hiD')
axis([0 .3 0 600]);
%Observations:
%In the context of a strong distractor, the cue has a large effect. It hs
%no effect in the context of a weak distractor.

%%
%Correct vs incorrect responses to target by contrast

figure
subplot(211)
hold on
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_loC_loD,:)),'g');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_loC_hiD,:)),'g--');
plot(t_psth,mean(psth(i_targ_rxn_dir_inc_loC_loD,:)),'r');
plot(t_psth,mean(psth(i_targ_rxn_dir_inc_loC_hiD,:)),'r--');
title('Correct vs incorrect responses to low contrast target, stim locked')
legend('corr loD','corr hiD','incorr loD','incorr hiD')
axis([0 .3 0 550]);
%Obervations:
%Early and late responses show a large separation between correct and
%incorrect responses. Peak responses are consistently larger on correct
%trials, but the difference is small with a high contrast distractor. The
%distractor effect is in the opposite direction as expected, with the
%stronger distractor driving larger neural responses.

subplot(212)
hold on
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_hiC_loD,:)),'g');
plot(t_psth,mean(psth(i_targ_rxn_dir_corr_hiC_hiD,:)),'g--');
plot(t_psth,mean(psth(i_targ_rxn_dir_inc_hiC_loD,:)),'r');
plot(t_psth,mean(psth(i_targ_rxn_dir_inc_hiC_hiD,:)),'r--');
title('Correct vs incorrect responses to high contrast target, stim locked')
legend('corr loD','corr hiD','incorr loD','incorr hiD')
axis([0 .3 0 550]);
%Observations:
%Early responses not separated by behavioral response. Peak responses show
%a weak separation. Late responses are clearly separated.

%%
%Correct vs incorrect responses to target by contrast

figure
subplot(211)
hold on
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_corr_loC_loD,:)),'g');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_corr_loC_hiD,:)),'g--');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_inc_loC_loD,:)),'r');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_inc_loC_hiD,:)),'r--');
title('Correct vs incorrect responses to low contrast target, stim locked')
legend('corr loD','corr hiD','incorr loD','incorr hiD')
axis([-.3 0 0 150]);
%Obervations:
%Early and late responses show a large separation between correct and
%incorrect responses. Peak responses are consistently larger on correct
%trials, but the difference is small with a high contrast distractor. The
%distractor effect is in the opposite direction as expected, with the
%stronger distractor driving larger neural responses.

subplot(212)
hold on
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_corr_hiC_loD,:)),'g');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_corr_hiC_hiD,:)),'g--');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_inc_hiC_loD,:)),'r');
plot(t_psth_mov,mean(psth_mov(i_targ_rxn_dir_inc_hiC_hiD,:)),'r--');
title('Correct vs incorrect responses to high contrast target, stim locked')
legend('corr loD','corr hiD','incorr loD','incorr hiD')
axis([-.3 0 0 200]);
%Observations:
%Early responses not separated by behavioral response. Peak responses show
%a weak separation.

figure
subplot(221)
display_raster(E(i_targ_rxn_dir_corr_loC_loD),son(i_targ_rxn_dir_corr_loC_loD),0,'k.',1)
display_raster(E(i_targ_rxn_dir_inc_loC_loD),son(i_targ_rxn_dir_inc_loC_loD),0,'b.',1+sum(i_targ_rxn_dir_corr_loC_loD))
title('corr vs inc loC loD')
a=axis;
a(1:2)=[0 .3];
axis(a);
subplot(222)
display_raster(E(i_targ_rxn_dir_corr_loC_hiD),son(i_targ_rxn_dir_corr_loC_hiD),0,'k.',1)
display_raster(E(i_targ_rxn_dir_inc_loC_hiD),son(i_targ_rxn_dir_inc_loC_hiD),0,'b.',1+sum(i_targ_rxn_dir_corr_loC_hiD))
title('loC hiD')
a=axis;
a(1:2)=[0 .3];
axis(a)

subplot(223)
display_raster(E(i_targ_rxn_dir_corr_hiC_loD),son(i_targ_rxn_dir_corr_hiC_loD),0,'k.',1)
display_raster(E(i_targ_rxn_dir_inc_hiC_loD),son(i_targ_rxn_dir_inc_hiC_loD),0,'b.',1+sum(i_targ_rxn_dir_corr_hiC_loD))
title('hiC loD')
a=axis;
a(1:2)=[0 .3];
axis(a);
subplot(224)
display_raster(E(i_targ_rxn_dir_corr_hiC_hiD),son(i_targ_rxn_dir_corr_hiC_hiD),0,'k.',1)
display_raster(E(i_targ_rxn_dir_inc_hiC_hiD),son(i_targ_rxn_dir_inc_hiC_hiD),0,'b.',1+sum(i_targ_rxn_dir_corr_hiC_hiD))
title('corr  hiC hiD')
a=axis;
a(1:2)=[0 .3];
axis(a);


figure
subplot(221)
display_raster(E(i_targ_rxn_dir_corr_loC_loD_cued),son(i_targ_rxn_dir_corr_loC_loD_cued),0,'k.',1)
display_raster(E(i_targ_rxn_dir_corr_loC_loD_uncued),son(i_targ_rxn_dir_corr_loC_loD_uncued),0,'b.',1+sum(i_targ_rxn_dir_corr_loC_loD_cued))
title('cued vs uncued loC loD')
a=axis;
a(1:2)=[0 .3];
axis(a);
subplot(222)
display_raster(E(i_targ_rxn_dir_corr_loC_hiD_cued),son(i_targ_rxn_dir_corr_loC_hiD_cued),0,'k.',1)
display_raster(E(i_targ_rxn_dir_corr_loC_hiD_uncued),son(i_targ_rxn_dir_corr_loC_hiD_uncued),0,'b.',1+sum(i_targ_rxn_dir_corr_loC_hiD_cued))
title('loC hiD')
a=axis;
a(1:2)=[0 .3];
axis(a);

subplot(223)
display_raster(E(i_targ_rxn_dir_corr_hiC_loD_cued),son(i_targ_rxn_dir_corr_hiC_loD_cued),0,'k.',1)
display_raster(E(i_targ_rxn_dir_corr_hiC_loD_uncued),son(i_targ_rxn_dir_corr_hiC_loD_uncued),0,'b.',1+sum(i_targ_rxn_dir_corr_hiC_loD_cued))
title('hiC loD')
a=axis;
a(1:2)=[0 .3];
axis(a);
subplot(224)
display_raster(E(i_targ_rxn_dir_corr_hiC_hiD_cued),son(i_targ_rxn_dir_corr_hiC_hiD_cued),0,'k.',1)
display_raster(E(i_targ_rxn_dir_corr_hiC_hiD_uncued),son(i_targ_rxn_dir_corr_hiC_hiD_uncued),0,'b.',1+sum(i_targ_rxn_dir_corr_hiC_hiD_cued))
title('hiC hiD')
a=axis;
a(1:2)=[0 .3];
axis(a);

%%
%Spike rate vs response
figure
errorbar(contrast_label,[mean(SpkR(i_targ_rxn_dir_corr_loC_loD)) mean(SpkR(i_targ_rxn_dir_corr_hiC_loD))],[std(SpkR(i_targ_rxn_dir_corr_loC_loD))/sqrt(sum(i_targ_rxn_dir_corr_loC_loD)) std(SpkR(i_targ_rxn_dir_corr_hiC_loD))/sqrt(sum(i_targ_rxn_dir_corr_hiC_loD))],'go-','MarkerSize',10,'MarkerFaceColor','g')
hold on
errorbar(contrast_label,[mean(SpkR(i_targ_rxn_dir_inc_loC_loD)) mean(SpkR(i_targ_rxn_dir_inc_hiC_loD))],[std(SpkR(i_targ_rxn_dir_inc_loC_loD))/sqrt(sum(i_targ_rxn_dir_inc_loC_loD)) std(SpkR(i_targ_rxn_dir_inc_hiC_loD))/sqrt(sum(i_targ_rxn_dir_inc_hiC_loD))],'ro-','MarkerSize',10,'MarkerFaceColor','r')
errorbar(contrast_label,[mean(SpkR(i_targ_rxn_dir_corr_loC_hiD)) mean(SpkR(i_targ_rxn_dir_corr_hiC_hiD))],[std(SpkR(i_targ_rxn_dir_corr_loC_hiD))/sqrt(sum(i_targ_rxn_dir_corr_hiC_loD)) std(SpkR(i_targ_rxn_dir_corr_hiC_hiD))/sqrt(sum(i_targ_rxn_dir_corr_hiC_hiD))],'gs-','MarkerSize',10,'MarkerFaceColor','k')
errorbar(contrast_label,[mean(SpkR(i_targ_rxn_dir_inc_loC_hiD)) mean(SpkR(i_targ_rxn_dir_inc_hiC_hiD))],[std(SpkR(i_targ_rxn_dir_inc_loC_hiD))/sqrt(sum(i_targ_rxn_dir_inc_loC_hiD)) std(SpkR(i_targ_rxn_dir_inc_hiC_hiD))/sqrt(sum(i_targ_rxn_dir_inc_hiC_hiD))],'rs-','MarkerSize',10,'MarkerFaceColor','k')
legend('correct low distractor','incorrect low distractor','correct high distractor','incorrect high distractor')

%spike rate vs cued
figure
errorbar(contrast_label,[mean(SpkR(i_targ_rxn_dir_corr_loC_loD_cued)) mean(SpkR(i_targ_rxn_dir_corr_hiC_loD))],[std(SpkR(i_targ_rxn_dir_corr_loC_loD_cued))/sqrt(sum(i_targ_rxn_dir_corr_loC_loD_cued)) std(SpkR(i_targ_rxn_dir_corr_hiC_loD))/sqrt(sum(i_targ_rxn_dir_corr_hiC_loD))],'bo-','MarkerSize',10,'MarkerFaceColor','b')
hold on
errorbar(contrast_label,[mean(SpkR(i_targ_rxn_dir_corr_loC_loD_uncued)) mean(SpkR(i_targ_rxn_dir_corr_hiC_loD_uncued))],[std(SpkR(i_targ_rxn_dir_corr_loC_loD_uncued))/sqrt(sum(i_targ_rxn_dir_corr_loC_loD_uncued)) std(SpkR(i_targ_rxn_dir_corr_hiC_loD_uncued))/sqrt(sum(i_targ_rxn_dir_corr_hiC_loD_uncued))],'ko-','MarkerSize',10,'MarkerFaceColor','k')
errorbar(contrast_label,[mean(SpkR(i_targ_rxn_dir_corr_loC_hiD_cued)) mean(SpkR(i_targ_rxn_dir_corr_hiC_hiD_cued))],[std(SpkR(i_targ_rxn_dir_corr_loC_hiD_cued))/sqrt(sum(i_targ_rxn_dir_corr_loC_hiD_cued)) std(SpkR(i_targ_rxn_dir_corr_hiC_hiD_cued))/sqrt(sum(i_targ_rxn_dir_corr_hiC_hiD_cued))],'bs-','MarkerSize',10,'MarkerFaceColor','b')
errorbar(contrast_label,[mean(SpkR(i_targ_rxn_dir_corr_loC_hiD_uncued)) mean(SpkR(i_targ_rxn_dir_corr_hiC_hiD_uncued))],[std(SpkR(i_targ_rxn_dir_corr_loC_hiD_uncued))/sqrt(sum(i_targ_rxn_dir_corr_loC_hiD_uncued)) std(SpkR(i_targ_rxn_dir_corr_hiC_hiD_uncued))/sqrt(sum(i_targ_rxn_dir_corr_hiC_hiD_uncued))],'ks-','MarkerSize',10,'MarkerFaceColor','k')
legend('cued low distractor','uncued low distractor','cued high distractor','uncued high distractor')


save_dataset_for_comparison = 1;
if save_dataset_for_comparison
    stim_driven_spikes_loC = SpkR(contrast_index==1&(stimuli_positions==rf_quadrant|distractor_pos_index==rf_quadrant)&rxn_quad==rf_quadrant);
    stim_driven_spikes_hiC = SpkR(contrast_index==2&(stimuli_positions==rf_quadrant|distractor_pos_index==rf_quadrant)&rxn_quad==rf_quadrant);
    save spkr_for_comparison stim_driven_spikes_loC stim_driven_spikes_hiC
end
