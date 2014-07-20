%car cost calculator

time = 1:120;%times in months
o=ones(size(time));
z=zeros(size(time));

c=[o(1:36) z(37:end)];

load('fuel')

%Leaf calculations 36 mo lease

monthly_miles =700.*c;

monthly_payment = 240*c;

mkwh = 3.8;%miles per kWh
kwh = .19;%cost per kWh
efficiecny = .92;%efficiency of charging

maintenance = 20.*c;

insurance = 72.*c;

leaf_cost = monthly_payment + (monthly_miles./mkwh)./efficiency*kwh + maintenance + insurance;

%Golf details

monthly_miles = [o(1:36).*200 100.*o(37:end)];%vector of monthly mileage over time

monthly_payment = 0;%[0.*ones(1,24) 351.*ones(1,60) zeros(1,36)];

mpg = 27.5;
premium = 0.2;

maintenance = monthly_miles.*.12;%[zeros(1,60) monthly_miles(61:84).*.05 monthly_miles(85:end).*.1];%vector of monthly maintenance over time

insurance =  66.*o;%[z(1:24) 72.*o(25:end)];

gti_cost = monthly_payment + (monthly_miles./mpg).*(fuel+premium) + maintenance + insurance;



%New car details
c=[z(1:36) o(37:end)];

monthly_miles = c.*800;%vector of monthly mileage over time

monthly_payment = [c(1:96).*351 z(97:end)];%[0.*ones(1,24) 351.*ones(1,60) zeros(1,36)];

mpg = 40;
premium = 0.2;

mkwh = inf;%miles per kwH
kwh = .19;%cost per kwh
efficiency = .85;%proportion of electricity that goes to car

maintenance = [z(1:72) monthly_miles(73:108).*.05 monthly_miles(109:end).*.12];%[zeros(1,60) monthly_miles(61:84).*.05 monthly_miles(85:end).*.1];%vector of monthly maintenance over time

insurance =  72.*c;%[z(1:24) 72.*o(25:end)];

new_golf_cost = monthly_payment + (monthly_miles./mpg).*(fuel+premium) + (monthly_miles./mkwh)./efficiency*kwh + maintenance + insurance;

leaf_total_cost = leaf_cost + gti_cost + new_golf_cost;

plot(leaf_total_cost);