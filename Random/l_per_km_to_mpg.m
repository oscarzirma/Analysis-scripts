function l_per_km_to_mpg(lpk)
%this function converts liters per 100 km to miles per gallon

gp100km = lpk/3.79;
gpk = gp100km/100;
gpm = gpk*1.609;

mpg = 1/gpm;

display([num2str(lpk) 'liters per 100 km equals ' num2str(mpg) ' miles per gallon']);
