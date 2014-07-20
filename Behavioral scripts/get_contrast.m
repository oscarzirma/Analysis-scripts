function screen_contrast = get_contrast(desired_contrast)
%this function will return the screen command value to get a particular
%desired contrast

load('contrastfit_minolta.mat')

screen_contrast=feval(contrastfit_minolta,desired_contrast);