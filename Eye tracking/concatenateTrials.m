function [cEOG cheadPosition cpeckLocations cstimulus_position csuccFlag_index session_indices] = concatenateTrials(file)
%given a file array, program will load the listed variables from the worksapce 
%represented by each element of the array and concatenates them together

cEOG=[];cheadPosition=[];cpeckLocations=[]; cstimulus_position=[]; csuccFlag_index=[];

for i=1:length(file)
    session_indices(i)=length(cEOG)+1;
    load(file(i).name,'EOG','headPosition','peckLocations','stimulus_position','succFlag_index')
    cEOG=[cEOG EOG];
    cheadPosition=[cheadPosition;headPosition];
    cpeckLocations=[cpeckLocations peckLocations];
    cstimulus_position=[cstimulus_position;stimulus_position];
    csuccFlag_index =[csuccFlag_index succFlag_index];
end