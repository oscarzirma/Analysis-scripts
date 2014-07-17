function [timestamps aligned_values index] = align_mag_eyelink(mag_time,mag_val,eye_time,eye_val)
%this function will align two traces based on timestamps

window = 500;

aligned_values=[];
index=[];

j=1;
index=[];
timestamps=[];
indE=1;
for i=1:length(mag_time) 
    x=mag_time(i);
    r=find(eye_time<(x+window)&eye_time>(x-window));
    if ~isempty(r)&&r(1)>indE
        indE=r(1);
        timestamps(j,:)=[x eye_time(r(1))];
        aligned_values(j,:)=[mag_val(i) eye_val(r(1))];
        index(j)=i;
        j=j+1;
    end;
end

% figure
% subplot(122)
% title('Values')
% scatter(aligned_values(:,1),aligned_values(:,2))
% 
% subplot(121)
% title('Times')
% scatter(timestamps(:,1),timestamps(:,2))
% pause
% close(gcf)