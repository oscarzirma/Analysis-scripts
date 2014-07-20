%script to analyze differences in recordings between different depths close
%to Ipc

file = dir('*.mat');
P = {};
W = {};
a = figure;
b = figure;
Fs = 24000;
h=fdesign.highpass('Fst,Fp,Ast,Ap',400,600,80,1,Fs);
d=design(h,'equiripple'); %Lowpass FIR filter
R = {};
for i = 1:length(file)
    load(file(i).name,'stim_ind','Rdata');
    on_rf = find(stim_ind == 3);
    for j=1:length(on_rf)
        r = cell2mat(Rdata(on_rf(j)));
        [p(j,:), w(j,:)] = periodogram(r(2,:),[],[],24000);
        raw(j+1,:) = r(2,:);
    end
    soundsc(r(2,:),24000)
    P(i) = {p};
    W(i) = {w};
    figure(a)
    subplot(3,5,i)
    plot(w(1,:),mean(p));
    set(gca,'YScale','log')
    axis([375 2164 2.6128e-14 4.2324e-12])
%     axis([0 12000 1e-16 1e-8])
    title(file(i).name)
    figure(b)
    subplot(3,5,i)
    plot(r(1,:),filtfilt(d.Numerator,1,r(2,:)));
    title(file(i).name)
    axis([ 0  600.0000   -0.0003    0.0003])
    raw(1,:) = r(1,:);
    R(i) = {raw};
    clear raw
    pause
end
