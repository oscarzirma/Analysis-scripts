function MicroplotNI(Run)
%takes in a three column signal from microphonic recordings, runs a 50
%point running mean filter on each column, normalizes all three columns,
%and shifts them from each other vertically. also low-pass filters
%interferometer signal (1500hz).

R=RMFa(Run,50);
R=R(9950:15500,1:2);
[m,n]=size(R);

R(:,1)=R(:,1)./100;
for(i=1:2)
    R(:,i)=R(:,i)-ones(m,1).*mean(R(:,i));
%   R(:,i)=R(:,i)./max(R(:,i));
end

R(:,1)=R(:,1)+ones(m,1).*(max(R(:,2)-min(R(:,1))));

plot(R);

end