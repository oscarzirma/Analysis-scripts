%car cost calculator

time = 1:120;%times in months
o=ones(size(time));
z=zeros(size(time));

c=[z(1:24) o(25:end)];

load('fuel')


%Golf details

monthly_miles = [o(1:24).*900 100.*o(25:end)];%vector of monthly mileage over time

monthly_payment = 0;%[0.*ones(1,24) 351.*ones(1,60) zeros(1,36)];

mpg = 27.5;
premium = 0.2;

maintenance = monthly_miles.*.1;%[zeros(1,60) monthly_miles(61:84).*.05 monthly_miles(85:end).*.1];%vector of monthly maintenance over time

insurance =  66.*o;%[z(1:24) 72.*o(25:end)];

gti_cost = monthly_payment + (monthly_miles./mpg).*(fuel+premium) + maintenance + insurance;



%New car details
c=[z(1:24) o(25:end)];

monthly_miles = c.*800;%vector of monthly mileage over time

monthly_payment = [c(1:84).*351 z(85:end)];%[0.*ones(1,24) 351.*ones(1,60) zeros(1,36)];

mpg = 40;
premium = 0.2;

maintenance = [z(1:60) monthly_miles(61:96).*.05 monthly_miles(97:end).*.12];%[zeros(1,60) monthly_miles(61:84).*.05 monthly_miles(85:end).*.1];%vector of monthly maintenance over time

insurance =  72.*c;%[z(1:24) 72.*o(25:end)];

new_golf_cost = monthly_payment + (monthly_miles./mpg).*(fuel+premium) + (monthly_miles./mkwh)./efficiency*kwh + maintenance + insurance;

total_cost_new_golf =gti_cost + new_golf_cost;

plot(total_cost_new_golf);