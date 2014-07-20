function [Fi,Ai,Fo,Ao]=Microphonic(D,I,S)
%takes in data in a 2 column format (D), with the input signal in the first
%column and output data in the second column. Finds peaks and outputs the 
%frequency and amplitude over the interval I. Takes in sampling rate S.
%Returns mean input frequency and amplitude and mean output frequency and
%amplitude. displays mean, standard deviation, and range for each.

Pi=findpeaks(D(:,1),I);
Po=findpeaks(D(:,2),I);

[a,fim,fir,fis]=meanfreq(Pi,S);
[a,fom,f_or,fos]=meanfreq(Po,S);
[a,aim,air,ais]=meanamp(Pi);
[a,aom,aor,aos]=meanamp(Po);

fi=fim;ai=aim;fo=fom;ao=aom;
Fi=[fim,fir,fis];
Fo=[fom,f_or,fos];
Ai=[aim,air,ais];
Ao=[aom,aor,aos];

%fprintf('The input frequency mean, range and standard deviation are:');
%Fi

%fprintf('The input amplitude mean, range, and standard deviation are:');
%Ai

%fprintf('The output frequency mean, range and standard deviation are:');
%Fo

%fprintf('The output amplitude mean, range, and standard deviation are:');
%Ao
return