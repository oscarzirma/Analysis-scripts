function display_bar(theWindow,theRect,color,azimuth,elevation,width,height,DtoP)
%clears screen to black and displays a bar of the given color and
%angular coordinates. color is rgb. flip screen to display dot.

%displays stimulus

sc_width=theRect(3);centerx=sc_width/2;
sc_height=theRect(4);centery=sc_height/2;

Screen('FillRect', theWindow, [0 0 0])

%assign left and right borders based on which side is closer to center
pix_diamxl = DtoP*abs(tand(azimuth)-tand(azimuth-width/2));
pix_diamxr = DtoP*abs(tand(azimuth)-tand(azimuth+width/2));

pix_diamyt = DtoP*abs(tand(elevation)-tand(elevation+height/2)) ;
pix_diamyb = DtoP*abs(tand(elevation)-tand(elevation-height/2));

x=centerx+tand(azimuth)*DtoP;
y=centery-tand(elevation)*DtoP;
[x-pix_diamxl y-pix_diamyt x+pix_diamxr y+pix_diamyb];
Screen('FillRect', theWindow, color,[x-pix_diamxl y-pix_diamyt x+pix_diamxr y+pix_diamyb])

%[y-pix_diamyt x-pix_diamxl   y+pix_diamyb x+pix_diamxr]
%Screen('FillOval', theWindow, color,[y-pix_diamyt x-pix_diamxl
%y+pix_diamyb x+pix_diamxr])





