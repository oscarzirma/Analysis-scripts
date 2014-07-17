function M=MakeMovAvi(I,filename,map)
%Takes in an array of images and converts them to an array of frames. Then
%writes this to an avi with 30 fps.


for(i=1:size(I,4))
    M(i)=im2frame(I(:,:,:,i),map);
end
movie2avi(M,[filename '.avi'],'FPS',30)
return