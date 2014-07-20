function MOV =load_frame_across_trials(frame_number)
%this program will load the mov file from each workspace in the current
%directory and generate a mov containing the frame specified by
%frame_number from each trial

file=dir('*.mat');

for i=1:length(file)
    load(file(i).name,'mov');
    if ~isempty(mov)
        MOV(:,:,:,i) = mov(:,:,:,frame_number);
        clear mov;
    end
end