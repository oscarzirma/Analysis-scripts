function concentricTubingSpiral(tube_diameter,minimum_radius,max_radius)
%given the inputs, it will display the necessary tubing length assuming
%that each spiral is a complete circle.

r=[minimum_radius:tube_diameter:max_radius];%index of radii

c=2*pi.*r;%circumferences

display(['Total tubing length = ' num2str(sum(c))])

a=max_radius^2*pi - minimum_radius^2*pi;

display(['Total area = ' num2str(a) ' sq ft'])
display(['Totla area = ' num2str(a/10.7639104) ' sq m'])