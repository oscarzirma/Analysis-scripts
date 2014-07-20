function [stim_amp E1 E2 uE1 uE2]=uStim_Eye(EYE,STIM)
%Given eye and stim, it will display the eye traces from sensor one and ask
%for baseline and microstimmed timepoints. It will return stim_amp, eye
%sensor traces, and uE1 and uE2 which for each trial (row), has the baseline
%position in the first column, stimmed position in the second, and
%difference in the third.

for i=1:length(EYE); 
    e=cell2mat(EYE(i)); 
    s=cell2mat(STIM(i));
    if ~isempty(e) 
        E1(i,:)=e(2,:);
        E2(i,:)=e(3,:);
    end
    if ~isempty(s)
        S(i,:)=s(2,:);
    end
end

et=e(1,:);
st=s(1,:);
figure
subplot(211)
plot(E1')
subplot(212)
plot(S');
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

title('Select baseline value')
[b y]=ginput(1);
title('Select stimmed value')
[s y]=ginput(1);
close(gcf)
uE1(:,1)=E1(:,round(b));
uE1(:,2)=E1(:,round(s));
uE1(:,3)=uE1(:,2)-uE1(:,1);

uE2(:,1)=E2(:,round(b));
uE2(:,2)=E2(:,round(s));
uE2(:,3)=uE2(:,2)-uE2(:,1);

a = get_ustim_amp(S);

a(isnan(a))=0.0001;
a(a==0)=.0001;

stim_amp=a;