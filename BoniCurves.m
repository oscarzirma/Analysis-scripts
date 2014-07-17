function [F D]=BoniCurves(A)
%takes in A which has number of days after first sequence in the first
%column, number of days from july1 in the second, hamming distance from
%first sequence and hamming distance from prior dominant sequence. returns
%F and D which have max(A(:,3)) and max(A(:,4)) columns and indicate the
%number of instances of a particular hamming distance in consecutive
%windows. new seasons are marked with a row of -1 in every column.

F=zeros(length(A),2+max(A(:,3)));
D=zeros(length(A),2+max(A(:,4)));
size(F)
F(:,1)=A(:,2);
D(:,1)=A(:,2);

for(i=1:length(A))
    F(i,2+A(i,3))=1;
    D(i,2+A(i,4))=1;
end

end
   