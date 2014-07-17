function [times values] = find_plateau_values_eyelink(t,e)
%this function finds platau values in an eyelink trace give a time
%trace(t) and a value trace (e)

% de=abs(diff(e));
% 
% det = de>median(de)+2*std(de);
% 
% j=1;
% l=1;
% while j<length(det)-1
%     if det(j)==0
%         j=j+1;
%     else
%         k=j;
%         while det(j)==det(j+1)&&j<length(det)-1
%         j=j+1;
%         end
%         detf(l)=round(mean([k j]));
%         j=j+1;
%         l=l+1;
%     end
% end
% 
% detfT = find(diff(t(detf))>400);
% 
% for i=1:length(detfT) 
%     times(i) = t(round(mean([detf(i+1) detf(i)]))); 
%     values(i) = mean(e(detf(i):detf(i+1)));
% end
% 
% 


%old version:
stable_duration = 10;%number of samples that must be within threshold
threshold       = 2;%threshold values within which the diff must be

n=length(t);
index=zeros(n,1);

for i=1:n-stable_duration 
    x=e(i:i+stable_duration); 
    if sum(abs(diff(x))>threshold)==0 
        index(i+round(stable_duration/2))=1;
    end;
end

j=1;
i=[];
times=[];
values=[];
while j<n 
    if index(j)==1  
        k=j;
        while index(j)==1&&j<n 
            j=j+1;
        end
        in=round(mean([k j]));
        times(end+1)=t(in);
        values(end+1)=nanmean(e(round(k+1):round(j-1)));
    end
    j=j+1;
end

% indices = round(i);
% 
% times = t(indices);
% values = e(indices);
i=isnan(values);
times(i)=[];
values(i)=[];