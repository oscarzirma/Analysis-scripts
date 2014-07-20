%compare spike rate and reaction direction

rf_quadrant = 1;
non_rf_quadrant = 3;%non-RF quadrant on same hemifield
n=length(Neural);
correct_rxn_dir_hor = 1;

extract_data=0;%run data extraction scripts?
if extract_data
    
    [SpkR son soff t rF E] = get_spikeRates(Neural,PD);%stim locked spike rates
    
    [con coff]=photodiode_stim_times_cue(PD);
    con = con -.0105;
    coff = coff - .0105;
    
    [t_psth,psth_stim]=build_PSTH(E,son);%stim locke psth
    [t_psth,psth_cue]=build_PSTH(E,con);%stim locke psth
    
    tm=detect_eye_movement(MAGR);%timing of eye movement
    [t_psth_mov,psth_mov]=build_PSTH(E,tm);%eye movement locked PSTH
    [SpkR_mov] = get_spikeRates_move(Neural,tm);%eye movement locked spike rates
    
    reaction_direction;
    cue_duration=(coff-con)';
end


figure
title('Valid cue versus neutral cue')
plot(t_psth,mean(psth_cue((cue_duration~=0&td_index==-1),:)));
hold on
plot(t_psth,mean(psth_cue((cue_duration~=0&(td_index==1&(stimuli_positions==1|stimuli_positions==3))),:)),'k');
plot(t_psth,mean(psth_cue((cue_duration~=0&(td_index==1&(stimuli_positions==2|stimuli_positions==4))),:)),'r');
legend('Neutral cue','Valid cue','Valid cue opposite')

figure
title('cue - response direction horizontal')
hold on;
plot(t_psth,mean(psth_cue((cue_duration~=0&td_index==-1)&rxn_dir_hor==1,:)),'b');
plot(t_psth,mean(psth_cue((cue_duration~=0&td_index==-1)&rxn_dir_hor==-1,:)),'k');
plot(t_psth,mean(psth_cue(rxn_dir_hor==1&cue_duration~=0&(td_index==1&(stimuli_positions==1|stimuli_positions==3)),:)),'g');
plot(t_psth,mean(psth_cue(rxn_dir_hor==-1&cue_duration~=0&(td_index==1&(stimuli_positions==1|stimuli_positions==3)),:)),'r');
legend('Invalid cue correct orientation','Invalid cue incorrect orientation','Valid cue correct orientation','Valid cue incorrect orientation')


figure
title('cue - response direction quadrant')
hold on;
plot(t_psth,mean(psth_cue((cue_duration~=0&td_index==-1)&(stimuli_positions==1|stimuli_positions==3)&rxn_quad==stimuli_positions,:)),'b');
plot(t_psth,mean(psth_cue((cue_duration~=0&td_index==-1)&(stimuli_positions==1|stimuli_positions==3)&rxn_quad~=stimuli_positions,:)),'k');
plot(t_psth,mean(psth_cue(cue_duration~=0&(td_index==1&(stimuli_positions==1|stimuli_positions==3))&rxn_quad==stimuli_positions,:)),'g');
plot(t_psth,mean(psth_cue(cue_duration~=0&(td_index==1&(stimuli_positions==1|stimuli_positions==3))&rxn_quad~=stimuli_positions,:)),'r');
legend('Invalid cue correct orientation','Invalid cue incorrect orientation','Valid cue correct orientation','Valid cue incorrect orientation')