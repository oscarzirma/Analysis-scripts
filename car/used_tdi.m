%car cost calculator

time = 1:120;%times in months
o=ones(size(time));
z=zeros(size(time));

load('fuel')


%Golf details

monthly_miles = [o.*100];%vector of monthly mileage over time

monthly_payment = 0;%[0.*ones(1,24) 351.*ones(1,60) zeros(1,36)];

mpg = 27.5;
premium = 0.2;

maintenance = monthly_miles.*.12;%[zeros(1,60) monthly_miles(61:84).*.05 monthly_miles(85:end).*.1];%vector of monthly maintenance over time

insurance =  66.*o;%[z(1:24) 72.*o(25:end)];

gti_cost = monthly_payment + (monthly_miles./mpg).*(fuel+premium) + maintenance + insurance;


%Golf TDI details

monthly_miles = [o.*800];%vector of monthly mileage over time

c=[o(1:36) z(37:end)];

monthly_payment = c.*140;%[0.*ones(1,24) 351.*ones(1,60) zeros(1,36)];

mpg = 45;
premium = 0.2;

maintenance = monthly_miles.*.12;%[zeros(1,60) monthly_miles(61:84).*.05 monthly_miles(85:end).*.1];%vector of monthly maintenance over time

insurance =  66.*o;%[z(1:24) 72.*o(25:end)];

tdi_cost = monthly_payment + (monthly_miles./mpg).*(fuel+premium) + maintenance + insurance;

%tdi_cost(1)=tdi_cost(1)+5000;

tdi_and_gti_cost = gti_cost + tdi_cost;

plot(tdi_and_gti_cost);