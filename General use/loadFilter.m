function d=loadLPFilter(frequency,Fs)
%Either loads a low-pass filter matching the specification from the ~/MATLAB/Filters
%folder and passes it or builds the filter, saves it to that folder, and passes it on.
% frequency - frequency in Hz
% Fs - sample rate in kHz

%build file name to search for. uses a convention
filter_name=['lp_' num2str(frequency) '_' num2str(Fs) '.filt'];

g=exists(['/Users/jschwarz/Documents/MATLAB/General use/Filters' filter_name]);

if(g)
    d=load(['/Users/jschwarz/Documents/MATLAB/General use/Filters' filter_name]);
    disp('Filter loaded')
else
    h=fdesign.lowpass('Fp,Fst,Ap,Ast',.8*frequency,frequency,1,60,Fs);
    d=design(h,'equiripple'); %Lowpass FIR filter
    disp('Filter built')
    save(filter_name,d)
end
end