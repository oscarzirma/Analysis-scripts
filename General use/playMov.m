function playMov(m,fps)
%plays through the movie at fps

    h=figure;
for(i=1:size(m,4))

    imshow(m(:,:,:,i))
    pause(1/fps)
end
close(h)
end

