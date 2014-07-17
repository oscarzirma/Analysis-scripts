function [iCon iInc] = get_congruent_indices(stimuli_positions,val_posner,RF_pos)
%This program will generate indices for congruent and incongruent trials.
%RF_stim_index indicates the RF stim location (based on azimuth and
%elevation arrays)

iRF=stimuli_positions==RF_pos;

val_posner=val_posner(1:length(stimuli_positions));

icon=val_posner==1;
iinc=val_posner==-1;

iCon=iRF+icon;
iCon=iCon==2;

iInc=iRF+iinc;
iInc=iInc==2;