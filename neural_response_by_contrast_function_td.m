function neural_response_by_contrast_function_td(Neural,PD,stimuli_positions,td_index,RF_pos,contrast_index,reaction_time,succFlag_index,contrast_label)

%This script will generate spike rates, succflag indices, and reaction
%times as a function of contrast and queuing

[spkr son soff t rF E] = get_spikeRates(Neural,PD);

[iCon iInc] = get_congruent_indices(stimuli_positions,td_index,RF_pos);

u=length(unique(contrast_index));

contrast_index_con=contrast_index(iCon);
contrast_index_inc=contrast_index(iInc);

spkr_con = get_as_function_of_contrast(contrast_index_con,spkr(iCon));
spkr_inc = get_as_function_of_contrast(contrast_index_inc,spkr(iInc));

succFlag_con = get_as_function_of_contrast(contrast_index_con,succFlag_index(iCon));
succFlag_inc = get_as_function_of_contrast(contrast_index_inc,succFlag_index(iInc));

reaction_time_succ=reaction_time;
reaction_time_succ(succFlag_index~=1)=nan;

rxn_con = get_as_function_of_contrast(contrast_index_con,reaction_time_succ(iCon));
rxn_inc = get_as_function_of_contrast(contrast_index_inc,reaction_time_succ(iInc));

for i=1:u d=succFlag_con(i).data;succFlag_con(i).percorr=length(find(d==1))/(length(find(d==1))+length(find(d==-2)));end
for i=1:u d=succFlag_inc(i).data;succFlag_inc(i).percorr=length(find(d==1))/(length(find(d==1))+length(find(d==-2)));end

figure
plot(contrast_label,[succFlag_con(:).percorr],'-*')
hold on
plot(contrast_label,[succFlag_inc(:).percorr],'r-*')
set(gca,'XScale','log')
set(gca,'XTick',10.^[-4:0])
title('Proportion correct 1010')

figure
errorbar(contrast_label,[spkr_con(:).mean],[spkr_con(:).err])
hold on
errorbar(contrast_label,[spkr_inc(:).mean],[spkr_inc(:).err],'r')
set(gca,'XScale','log')
set(gca,'XTick',10.^[-4:0])
title('Spike rate 1010')

figure
errorbar(contrast_label,[rxn_con(:).mean],[rxn_con(:).err])
hold on
errorbar(contrast_label,[rxn_inc(:).mean],[rxn_inc(:).err],'r')
set(gca,'XScale','log')
set(gca,'XTick',10.^[-4:0])
title('Reaction time 1010')