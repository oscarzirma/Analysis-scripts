function [time trace_array]=neural_trace_from_cell(Neural)

for i=1:length(Neural)
    tmp=cell2mat(Neural(i));
    trace_array(i,:)=tmp(2,1:14600);
end

time=tmp(1,1:14600);

