function [gabor,noisepatch] = create_gabor

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

noise_tile_size = 25;nts=noise_tile_size;

x=1:imsize;
x0=(x/imsize)-.5;

[xm,ym] = meshgrid(x0,x0);

xt = xm*cos(rotationrad);
yt = ym*sin(rotationrad);
xyt = xt + yt;
xyf = xyt*freqrad;

grating = sin(xyf-phaserad);

gauss=exp(-(((xm.^2)+(ym.^2))./(2*sigma^2)));
gauss(gauss<trim)=0;

gabor = grating .* gauss;

N=grating;G=grating;
        [ix,iy]=meshgrid(nts:nts:imsize-nts);
        m=numel(ix);
        r=randperm(m);
        vx=[1:nts];
for i=1:m
        N(vx+ix(i),vx+iy(i))= G(vx+ix(r(i)),vx+iy(r(i)));
end

noise   = N;
noisepatch = noise .* gauss;

subplot(211)
imshow(gabor)
subplot(212)
imshow(noisepatch)
pause
close(gcf)
keyboard
