function Tectum(Input,AGF,iterations)

OT=zeros(size(Input));
Ipc=OT;Imc=ones(size(Input));

OT=Input+AGF;

for i=1:iterations
    Ipc=OT;
    Imc=Imc-OT;
    OT=OT+Ipc;
    OT=OT-Imc;
    
    imagesc(OT)
    pause
   
end
