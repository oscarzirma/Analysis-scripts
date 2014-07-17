%Script that extracts eye position from eyelink frame struct

n=length(frameData);

%leftEye=zeros(3,n);
%rightEye=zeros(3,n);
t0=frameData(1).ImageData.Timestamp;

l=1;
r=1;

for i=1:n
    t=frameData(i).ImageData.Timestamp;
    if frameData(i).LeftEye.Found
        leftEye(1,l)=t-t0;
        %leftEye(2:3,l)=[frameData(i).LeftEye.Pupil.x-(frameData(i).LeftEye.Glint0.x+frameData(i).LeftEye.Glint1.x)/2; frameData(i).LeftEye.Pupil.y-(frameData(i).LeftEye.Glint0.y+frameData(i).LeftEye.Glint1.y)/2];
        leftEye(2:3,l)=[frameData(i).LeftEye.Pupil.x; frameData(i).LeftEye.Pupil.y];
        leftEye(4:5,l)=[frameData(i).LeftEye.Pupil.x-frameData(i).LeftEye.Glint0.x; frameData(i).LeftEye.Pupil.y-frameData(i).LeftEye.Glint0.y];
        leftEye(6:7,l)=[frameData(i).LeftEye.Pupil.x-frameData(i).LeftEye.Glint1.x; frameData(i).LeftEye.Pupil.y-frameData(i).LeftEye.Glint1.y];
        %         leftEye(2:3,l)=[(frameData(i).LeftEye.Glint0.x+frameData(i).LeftEye.Glint1.x)/2; (frameData(i).LeftEye.Glint0.y+frameData(i).LeftEye.Glint1.y)/2];
        l=l+1;
    end
    
    
    if frameData(i).RightEye.Found
        rightEye(1,r)=t-t0;
        rightEye(2:3,r)=[frameData(i).RightEye.Pupil.x; frameData(i).RightEye.Pupil.y];
        rightEye(4:5,r)=[frameData(i).RightEye.Pupil.x-frameData(i).RightEye.Glint0.x; frameData(i).RightEye.Pupil.y-frameData(i).RightEye.Glint0.y];
        rightEye(6:7,r)=[frameData(i).RightEye.Pupil.x-frameData(i).RightEye.Glint1.x; frameData(i).RightEye.Pupil.y-frameData(i).RightEye.Glint1.y];        %         rightEye(2:3,r)=[(frameData(i).RightEye.Glint0.x+frameData(i).RightEye.Glint1.x)/2; (frameData(i).RightEye.Glint0.y+frameData(i).RightEye.Glint1.y)/2];
        r=r+1;
    end
    
end

clear t l r n