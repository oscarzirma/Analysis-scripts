function M=MakeMov(I,t)
%Takes in an array of images and converts them to an array of frames.

for(i=1:size(I,3))
    x=I(:,:,i);
	x=t.*x;
    x=uint8(x);
    M(i)=im2frame(x,jet);
end

return