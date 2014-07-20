function combine_neural_datasets
%this function will combine datasets from two recording days. This version
%does a direct combination, so it will not work for analysing datasets between which 
%the RF location differs

[f1,d1]=uigetfile(pwd,'Select first dataset file');

load([d1 f1]);

Neural_A                    = Neural;
distractor_position_A       = distractor_position;
PD_A                        = PD;
MAGR_A                      = MAGR;
stimuli_positions_A         = stimuli_positions;
contrast_index_A            = contrast_index;
distractor_index_A          = distractor_index;
td_index_A                  = td_index;
time_to_hard_initiation_A   = time_to_hard_initiation;
gazePosition_A              = gazePosition;
succFlag_index_A            = succFlag_index;


[f2,d2]=uigetfile(pwd,'Select second dataset file');

load([d2 f2]);

Neural_B                    = Neural;
distractor_position_B       = distractor_position;
PD_B                        = PD;
MAGR_B                      = MAGR;
stimuli_positions_B         = stimuli_positions;
contrast_index_B            = contrast_index;
distractor_index_B          = distractor_index;
td_index_B                  = td_index;
time_to_hard_initiation_B   = time_to_hard_initiation;
gazePosition_B              = gazePosition;
succFlag_index_B            = succFlag_index;

Neural                  = [Neural_A; Neural_B];
distractor_position     =[distractor_position_A; distractor_position_B];
PD                      = [PD_A; PD_B];
MAGR                    = [MAGR_A; MAGR_B];
stimuli_positions       = [stimuli_positions_A stimuli_positions_B];
contrast_index          = [contrast_index_A contrast_index_B];
distractor_index        = [distractor_index_A distractor_index_B];
td_index                = [td_index_A td_index_B];
time_to_hard_initiation = [time_to_hard_initiation_A time_to_hard_initiation_B];
gazePosition            = [gazePosition_A; gazePosition_B];
succFlag_index          = [succFlag_index_A succFlag_index_B];


save(['combined_neural_datasets_' f1 '_' f2],'Neural','distractor_position','PD','MAGR','stimuli_positions','contrast_index','distractor_index','td_index','azimuth','elevation','time_to_hard_initiation','response_box_delay','gazePosition','succFlag_index');