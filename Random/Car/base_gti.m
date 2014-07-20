%car cost calculator

time = 1:120;%times in months
o=ones(size(time));
z=zeros(size(time));

load('fuel')


%Golf details

monthly_miles = [o.*900];%vector of monthly mileage over time

monthly_payment = 0;%[0.*ones(1,24) 351.*ones(1,60) zeros(1,36)];

mpg = 27.5;
premium = 0.2;

maintenance = monthly_miles.*.12;%[zeros(1,60) monthly_miles(61:84).*.05 monthly_miles(85:end).*.1];%vector of monthly maintenance over time

insurance =  66.*o;%[z(1:24) 72.*o(25:end)];

base_gti_cost = monthly_payment + (monthly_miles./mpg).*(fuel+premium) + maintenance + insurance;


plot(base_gti_cost);