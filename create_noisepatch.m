function noisepatch = create_noisepatch

imsize            = 500;%image size in pixels
pixels_per_cycle  = 25;
phase             = 0;%phase shift [0 1]
rotation          = 0;%grating rotation [0 180]

gauss_sigma       = 50;%standard deviation in pixels of gaussian
trim              = .005;%gaussian values below which set to zero


freq = imsize/pixels_per_cycle;%cycles per image
freqrad = 2*pi*freq;
phaserad = 2*pi*phase;
rotationrad = deg2rad(rotation);

sigma = gauss_sigma/imsize;


x=1:imsize;
x0=(x/imsize)-.5;

[xm,ym] = meshgrid(x0,x0);

xt = xm*cos(rotationrad);
yt = ym*sin(rotationrad);
xyt = xt + yt;
xyf = xyt*freqrad;

grating = sin(xyf-phaserad);
noise   = grating(randi(imsize,imsize));

gauss=exp(-(((xm.^2)+(ym.^2))./(2*sigma^2)));
gauss(gauss<trim)=0;

noisepatch = noise .* gauss;

imshow(noisepatch)
pause
close(gcf)
