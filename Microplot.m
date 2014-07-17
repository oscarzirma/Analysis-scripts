function Microplot(Run)
%takes in a three column signal from microphonic recordings, runs a 50
%point running mean filter on each column, normalizes all three columns,
%and shifts them from each other vertically. also low-pass filters
%interferometer signal (1500hz).

R=RMFa(Run,50);
%R=R(60000:65000,:);
[m,n]=size(R);

%[B,A]=butter(4,.15);
%R(:,3)=filter(B,A,R(:,3));

R(:,1)=R(:,1)./100;
R(:,3)=R(:,3)./10;
for(i=1:3)
    R(:,i)=R(:,i)-ones(m,1).*mean(R(:,i));
%   R(:,i)=R(:,i)./max(R(:,i));
end

R(:,1)=R(:,1)+ones(m,1).*(max(R(:,3)-min(R(:,1))));
R(:,2)=R(:,2)-ones(m,1).*(max(R(:,2)-min(R(:,3))));

plot(R);

end