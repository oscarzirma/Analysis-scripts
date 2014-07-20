function display_spikes_posner(Rdata,contrast_index,contrast_label,PD,val_posner,stimuli_positions,RF_pos,CTI)
%Given a cell array of neural recordings, and index indicating which group
%each recording is associated with, an array of labels for each group, and
%a cell array of photodiode signals with which to calculate stim on and off
%times, the program wil

%Runs display_spikes on only the trials with a stimulus at the RF. Displays
%both congruent and incongruent data sets.

val_posner=val_posner(1:length(PD));%adjust array length

iRF = find(stimuli_positions==RF_pos);%index of trials with stim at RF
max(iRF)

RdataRF=Rdata(iRF);%RF neural traces
val_posnerRF=val_posner(iRF);%RF posner index
contrast_indexRF=contrast_index(iRF);
PDRF=PD(iRF);

ival=val_posnerRF==1;
iinv=val_posnerRF==0;

RdataRF_val=RdataRF(ival);
RdataRF_inv=RdataRF(iinv);

contrast_indexRF_val=contrast_indexRF(ival);
contrast_indexRF_inv=contrast_indexRF(iinv);

PDRF_val=PDRF(ival);
PDRF_inv=PDRF(iinv);

display_spikes(RdataRF_val,contrast_indexRF_val,contrast_label,PDRF_val);
figure
display_spikes(RdataRF_inv,contrast_indexRF_inv,contrast_label,PDRF_inv);
