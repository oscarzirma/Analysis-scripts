%script to calculate lease payment
%payment = depreciation fee + finance fee

car_cost     = 28800;
destination  = 850;
discount     = 7500;
incentive    = 2300;%dealer incentive

acquisition  = 595;
title        = 285;
doc_fee      = 80;
disposition  = 395;

residual     = .48;%proportion of car_cost
money_factor = .00168;
sales_tax    = .085;

down_payment = 2756;%money down before first month payment
term         = 36;

cap_cost_reduction = down_payment - acquisition - title - doc_fee;

Capital_cost = car_cost + destination - discount - incentive - cap_cost_reduction;
Residual = (car_cost)*residual;

Depreciation_fee = (Capital_cost - Residual)/term;
Finance_fee = (Capital_cost + Residual)*money_factor;
Sales_tax = ((car_cost-discount-incentive - Residual)*sales_tax)/term;

Lease_payment = Depreciation_fee + Finance_fee;

Total_payment = Lease_payment + Sales_tax;

Total_cost = Total_payment * term + down_payment + disposition;

display(['Capital cost:$' num2str(Capital_cost)]);
display(['Residual:$' num2str(Residual)]);
display(['Depreciation fee:$' num2str(Depreciation_fee)]);
display(['Finance fee:$' num2str(Finance_fee)]);
display(['Sales tax:$' num2str(Sales_tax)]);
display(['Lease payment:$' num2str(Lease_payment)]);
display(['Total payment:$' num2str(Total_payment)]);
display(['Total cost:$' num2str(Total_cost)]);
