function [f,d]=loadLPFilter(s,frequency,Fs)
%Either loads a low-pass filter matching the specification from the ~/MATLAB/Filters
%folder and passes it or builds the filter, saves it to that folder, and passes it on.
% frequency - frequency in Hz
% Fs - sample rate in kHz

%build file name to search for. uses a convention
filter_name=['lp_' num2str(frequency) '_' num2str(Fs) '.filt'];

filter_path=['/Users/jschwarz/Documents/MATLAB/Filters/' filter_name];

g=exist(filter_path);

if(g)
    load(filter_path,'-mat');
else
    h=fdesign.lowpass('Fp,Fst,Ap,Ast',.8*frequency,frequency,1,60,Fs.*1000);
    d=design(h,'equiripple'); %Lowpass FIR filter
    save(filter_path,'d')
end
f=filtfilt(d.Numerator,1,s);
end