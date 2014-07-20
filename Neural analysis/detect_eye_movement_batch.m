function Tm=detect_eye_movement_batch(MAG)
%detects eye movements from a MAG cell file

n=length(MAG);
Tm=nan(n,1);

for i=1:n
    Tm(i)=detect_eye_movement(cell2mat(MAG(i)));
end