function degree=EOG_convert(trace,chicken)
%input an EOG voltage trace and a chicken number and will
%return the degree trace. For chicken 18:
%switched to using just the slope of the fit. no y-intercept. also, updated
%the conversion for chicken 18 assuming the swivel point of the eye is 6 mm
%from the surface. 10 mm would be the back of the eye. the eye is not
%swiveling from the back, but rather from it's 'center'

if(chicken==18)
%brob =[-0.2153 -0.2529];OLD VERSION
brob=-.129;
end
%o=ones(size(trace));

degree=trace./brob(1);

%degree=degree+o.*brob(1);

end