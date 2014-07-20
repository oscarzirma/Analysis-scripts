
rf_quadrant = 1;

extract_data = 1;
if extract_data
    [SpkR son soff t rF E] = get_spikeRates(Neural,PD);
    [ton toff] = photodiode_stim_times(PD,.01);
    [con coff] = photodiode_stim_times(PD,.54);
    ton = ton - .0105;toff = toff - 0.0105;
    con = con - .0105;coff = coff - 0.0105;
    tm = detect_eye_movement_stim(MAGR,con);
        reaction_direction;

    [t_psth_targ psth_targ] = build_PSTH(E,ton);
    [t_psth_cue psth_cue] = build_PSTH(E,con);
    [t_psth_mov psth_mov] = build_PSTH(E,tm);
    [t_psth_hmov psth_hmov] = build_PSTH(E,abs_rxn_time);
end

 iRF  = rxn_quad == rf_quadrant;
 iaRF = rxn_quad == 2;
% iRF  = stimuli_positions==1;
% iaRF = stimuli_positions == 2;

figure
subplot(311)
shadedErrorBar(t_psth_targ,nanmean(psth_targ(iRF,:)),nanstd(psth_targ(iRF,:))/sqrt(sum(iRF)),'b');
hold on;
shadedErrorBar(t_psth_targ,nanmean(psth_targ(iaRF,:)),nanstd(psth_targ(iaRF,:))/sqrt(sum(iaRF)),'k');
a=axis;
a(1:3) = [0 1 -10];
axis(a)
title('Target sync')


subplot(312)
shadedErrorBar(t_psth_cue,nanmean(psth_cue(iRF,:)),nanstd(psth_cue(iRF,:))/sqrt(sum(iRF)),'b');
hold on;
shadedErrorBar(t_psth_cue,nanmean(psth_cue(iaRF,:)),nanstd(psth_cue(iaRF,:))/sqrt(sum(iaRF)),'k');
a=axis;
a(1:3) = [-.6 1 -10];
axis(a)
title('Cue sync')


subplot(313)
shadedErrorBar(t_psth_hmov,nanmean(psth_mov(iRF,:)),nanstd(psth_mov(iRF,:))/sqrt(sum(iRF)),'b');
hold on;
shadedErrorBar(t_psth_hmov,nanmean(psth_mov(iaRF,:)),nanstd(psth_mov(iaRF,:))/sqrt(sum(iaRF)),'k');
a=axis;
a(1:3) = [-.6 .6 -10];
axis(a)
title('Motor sync')
