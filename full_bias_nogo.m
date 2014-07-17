%This script will modify INDEX.nogo so that it is assigned only to ONLY either
%go or nogo. It will not extend the block, merely convert the current block
%of 10 indices.

if ~INIT.soft
    display('Nogo (1) or Go (0)?')
    q = input(':');
    
    if q==1||q==0
        INDEX.nogo = ones(size(INDEX.nogo)).*q;
        get_stim_parameters;
    else
        display('Invalid input')
    end
end

clear q;