function generateMicroOutput (Range,prefix,suffix,NeuromastLabels)
%Will import microphonic 2 column data files over a range of numbers with a
%given prefix and suffix (e.g. for Run 01 - Run 05, range = [1 5] prefix =
%'Run ' suffix = '.txt'. Assumes that there are three files for each
%neuromast, a 100hz 10cycle baseline, a multi-freq, multi-amp test,
%followed by another 100hz 10cycle baseline. The test parameters must be
%manually entered in the initiation values within the program. Neuromasts
%in rows, frequencies along columns.

%The program will output 
%1)Baseline amplitude response between neuromasts at 100hz (absolute 
%in column 1, relative in column 2), 2) Stimulus frequencies, 3) Stimulus amplitudes,
%4-5)Frequency response between neuromasts (in the form of a 3-dim matrix: 
%rows represent neuromasts, columns represent frequencies, and z-columns represent 
%amplitudes) with the first matrix being absolute values and the second
%matrix being relative values.

%Will also print figures:
%baseline.png - absolute baseline comparisons across neuromasts
%Relbaseline.png - relative baseline comparisons across neuromasts
%FreqFreq.png - response frequency as a function of stimulus frequency
%AmpAmp.png - response amplitude as a function of stimulus amplitude
%AbsFreq.png - frequency response by neuromast
%RelFreq.png - relative frequency response by neuromast



dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat',Baseline,'-append','delimiter','\t','precision',6)
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat',StimFreq,'-append','delimiter','\t','precision',6)
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat',StimAmp,'-append','delimiter','\t','precision',6)
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat',ResFreq,'-append','delimiter','\t','precision',6)
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat',AbsAmp,'-append','delimiter','\t','precision',6)
dlmwrite('data.dat',' ','-append')
dlmwrite('data.dat',RelAmp,'-append','delimiter','\t','precision',6)
dlmwrite('data.dat',' ','-append')
    