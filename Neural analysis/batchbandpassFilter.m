function f=batchbandpassFilter(s,lowfreq,highfreq,Fs)
%takes in a matrix and outputs that matrix after band pass filtering each row. 

h=fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',.8*lowfreq,lowfreq,highfreq,1.25*highfreq,100,1,100,Fs);
d=design(h,'equiripple'); %Lowpass FIR filter

for i=1:size(s,1)
f(i,:)=filtfilt(d.Numerator,1,s(i,:));
end

end