function firewood_calculator(diameter,length)
%given a wood round diameter and length (in inches), it will calculate how many rounds
%per cord

diameterf = diameter/12;
lengthf = length/12;

volume_one_round = (diameterf/2)^2 * pi * lengthf;

rounds_per_cord = 128 / volume_one_round;

display(['A single round has a volume of ' num2str(volume_one_round) ' cu ft'])
display([num2str(rounds_per_cord) ' rounds make one cord'])