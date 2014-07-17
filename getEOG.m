function [t El Er] = getEOG(EOG,curate)
%this function returns a time vector, and matrices of the left and right eye EOGs.
%If curate is true, the program will plot the EOG for each trial and the
%user can specify whether it is an acceptable recording. IF it is not, the
%trace will be replaced with zeros in the output.

for i=1:length(EOG)
    e=cell2mat(EOG(i));
    if ~isempty(e)
        t=e(1,:);
        if curate
            subplot(211);
            plot(t,e(2,:));
            subplot(212);
            plot(t,e(3,:));
            a=input('Is this trace acceptable? (y/n)','s');
            if a=='n'
                z=zeros(size(e(2,:)));
                e(2,:)=z;e(3,:)=z;
            end
        end
        
        El(i,1:length(e(3,:)))=e(2,:);
        Er(i,1:length(e(3,:)))=e(3,:);
    end
end