function playMov_eye(m,fps,centroid)
%plays through the movie at fps

    h=figure;
for(i=1:size(m,4))

    imshow(m(:,:,:,i))
    hold on
    scatter(centroid(i,1),centroid(i,2));
    hold off
    pause(1/fps)
end
close(h)
end

