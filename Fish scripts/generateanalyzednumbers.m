function [analyzed_wav_files_final,analyzed_numbers2]=generateanalyzednumbers(analyzed_wav_files)



%import a directory of wav files
directoryname = uigetdir('C:\Documents and Settings\nicole\My Documents\MATLAB','Choose a directory that contains the directory testseg'); 

directoryname 
subdir='./chippingsparrowgoodboutsthirdtest/'
files = dir([subdir '*.wav']);

F=length(files)+1
filenumber=zeros(1,F-1);

for i=1:F-1
i

    wavfile=([files(i).name]);


wavfile
analyzed_wav_files_final{i}=wavfile;

filenumber(i)=strmatch(analyzed_wav_files_final{i}, analyzed_wav_files, 'exact')


end
char(analyzed_wav_files)
analyzed_numbers2=filenumber
