function f=batchhighpassFilter(s,freq,Fs)
%takes in a matrix and outputs that matrix after band pass filtering each
%row. 

h=fdesign.highpass('Fst,Fp,Ast,Ap',freq,1.5*freq,80,1,Fs);
d=design(h,'equiripple'); %Lowpass FIR filter

for i=1:size(s,1)
f(i,:)=filtfilt(d.Numerator,1,s(i,:));
end

end