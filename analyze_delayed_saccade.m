
correct_hor_rxn_direction = -1;

extract_data = 1;
if extract_data
    for ii=1:5
        x=cell2mat(PD(ii));
        if ~isempty(x)
            p(ii,:) = x(2,:);
        end
    end
    pfig=figure;
    plot(x(1,:)./1000,p')
    title('Select a timepoint dividing the cue and target')
    [ct,~] = ginput(1);
    close(pfig)
    pause(.1)
    [SpkR son soff t rF E] = get_spikeRates(Neural,PD);
    [ton toff] = photodiode_stim_times(PD,ct);
    [con coff] = photodiode_stim_times_cue(PD,ct);
    ton = ton - .0105;toff = toff - 0.0105;
    con = con - .0105;coff = coff - 0.0105;
    tm = detect_eye_movement_stim(MAGR,ton);
        reaction_direction;

    [t_psth_targ psth_targ] = build_PSTH(E,ton);
    [t_psth_cue psth_cue] = build_PSTH(E,con);
    [t_psth_mov psth_mov] = build_PSTH(E,tm);
    [t_psth_hmov psth_hmov] = build_PSTH(E,rel_rxn_time);
end

iRF  = rxn_dir_hor == correct_hor_rxn_direction;
iaRF = rxn_dir_hor == -correct_hor_rxn_direction;

figure
subplot(311)
shadedErrorBar(t_psth_targ,mean(psth_targ(iRF,:)),std(psth_targ(iRF,:))/sqrt(sum(iRF)),'b');
hold on;
shadedErrorBar(t_psth_targ,mean(psth_targ(iaRF,:)),std(psth_targ(iaRF,:))/sqrt(sum(iaRF)),'k');
a=axis;
a(1:3) = [0 1 -10];
axis(a)
title('Target sync')


subplot(312)
shadedErrorBar(t_psth_cue,mean(psth_cue(iRF,:)),std(psth_cue(iRF,:))/sqrt(sum(iRF)),'b');
hold on;
shadedErrorBar(t_psth_cue,mean(psth_cue(iaRF,:)),std(psth_cue(iaRF,:))/sqrt(sum(iaRF)),'k');
a=axis;
a(1:3) = [-.6 1 -10];
axis(a)
title('Cue sync')


subplot(313)
shadedErrorBar(t_psth_hmov,mean(psth_hmov(iRF,:)),std(psth_hmov(iRF,:))/sqrt(sum(iRF)),'b');
hold on;
shadedErrorBar(t_psth_hmov,mean(psth_hmov(iaRF,:)),std(psth_hmov(iaRF,:))/sqrt(sum(iaRF)),'k');
a=axis;
a(1:3) = [-.6 .6 -10];
axis(a)
title('Motor sync')
