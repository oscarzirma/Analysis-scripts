function combine_neural_datasets_v2
%this function will combine neural datasets, saving each set into a struct
%vector along with a struct of average values.

more = 1;
index=1;

while more
    
    [f,d]=uigetfile(pwd,'Select dataset file');
    
    load([d f]);

    
    combined(index).Neural                    = Neural;
    combined(index).distractor_position       = distractor_position;
    combined(index).distractor_pos_index      = distractor_pos_index;
    combined(index).PD                        = PD;
    combined(index).MAGR                      = MAGR;
    combined(index).stimuli_positions         = stimuli_positions;
    combined(index).contrast_index            = contrast_index;
    combined(index).distractor_index          = distractor_index;
    combined(index).td_index                  = td_index;
    combined(index).time_to_hard_initiation   = time_to_hard_initiation;
    combined(index).gazePosition              = gazePosition;
    combined(index).succFlag_index            = succFlag_index;
    combined(index).SpkR                      = SpkR;
    combined(index).son                       = son;
    combined(index).soff                      = soff;
    combined(index).E                         = E;
    combined(index).psth                      = psth;
    combined(index).tm                        = tm;
    combined(index).psth_mov                  = psth_mov;
    combined(index).SpkR_mov                  = SpkR_mov;
    combined(index).trb                       = trb;
    combined(index).psth_resp                 = psth_resp;
    combined(index).rxn_quad                  = rxn_quad;
    combined(index).rf_quadrant               = rf_quadrant;
    
    more = input('Enter 1 to input more datasets, 0 to stop','s');
    index=index+1;
end

filename = input('Enter file name:');

save(['combined_neural_datasets_' filename],'combined','t_psth')