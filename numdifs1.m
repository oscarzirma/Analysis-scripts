function z=numdifs1(seq)
%takes in a list of sequences, and returns a vector of the number of
%differences for every pairwise comparison

k=0;
v=0;
for(i=1:length(seq)-1)
    for(j=i+1:length(seq))
        c=aadiff(char(seq(i)),char(seq(j)));
        v(j-1+(k*length(seq)))=c;
        k=k+1;
    end
end
z=v;
return