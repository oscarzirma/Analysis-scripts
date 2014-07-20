function [data_sort] = get_as_function_of_contrast(contrast_index,data)
%This function will return a cell array of data organized by contrast)

u=unique(contrast_index);
m=max(u);

data_sort.data ={[]};
data_sort.mean=[];
data_sort.err=[];

for i=1:m
    d=data(contrast_index == i);
    data_sort(i).data=d;
    data_sort(i).mean=nanmean(d);
    data_sort(i).err=nanstd(d)/sqrt(length(d));
end
    