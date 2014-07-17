function playMov_eye_pos(m,fps,centroidp,zero)
%plays through the movie at fps. zero is the zero point of the eye

    h=figure;
centroidp=centroidp+repmat(zero,size(centroidp,1),1);

for(i=1:size(m,4))

    imagesc(m(:,:,:,i))
    hold on
    scatter(centroidp(i,1),centroidp(i,2),'r*')
    hold off
    pause(1/fps)
end
close(h)
end

