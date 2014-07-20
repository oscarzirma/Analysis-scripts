%This script will modify INDEX.stimuli so that it is assigned only to a
%single quadrant. It will produce a full block (20 at the time of writing)

if ~INIT.soft
    display('Which quadrant to bias? (1-LD, 2-RD, 3-LU, 4-RU, -1-unbias)')
    q = input(':');
    
    if sum(STIMPROP.positions == q) == 1
        INDEX.stimuli = ones(1,20).*q;
        get_stim_parameters;
    elseif q == -1
        INDEX.stimuli = [];
        if STIMPROP.bias
            display('STIMPROP.bias is on, stimuli positions will be biased based on performance')
        end
        get_stim_parameters;
    else
        display('Invalid quadrant')
    end
end

clear q