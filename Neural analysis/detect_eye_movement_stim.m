function tm=detect_eye_movement(MAG,son)
%given a 3 row eye position trace [time;channelA;channelB] this will return
%the timing of the first eye movement
%stim version detect first movement following stim onset

thresh = 8e-5;%2e-4;

n=length(MAG);

for i=1:n
    x=cell2mat(MAG(i));
    if ~isempty(x)
        M(i,:)=x(3,:);
    end
end

MF=batchlowpassFilter(M,100,610);
t=x(1,:);
tm=nan(n,1);

for i=1:n
    k=time_match(t/1000,son(i));
    m=MF(i,k:end);
    j=find(abs(diff(m))>thresh);
    if ~isempty(j)
        tm(i)=t(j(1)+k)/1000;
    end
    
end
