function M=MakeMov(I)
%Takes in an array of images and converts them to an array of frames.

for(i=1:size(I,4))
    M(i)=im2frame(I(:,:,:,i));
end

return