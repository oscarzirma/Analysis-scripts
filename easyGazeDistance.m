function density=easyGazeDistance(distance)
%given a distance in cm, this will return the pixel density in pixels per
%cm

load easyGaze_distance_vs_pixel_density

density=feval(easyGaze_distance_vs_pixel_density,distance);
