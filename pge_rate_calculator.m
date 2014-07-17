function pge_rate_calculator(consumption)
%this function will calculate the total cost and overall electrical rate
%given a certain amount of consumption

baseline = 178; %winter baseline 178. summer baseline 167. Summer is May through October
tier1 = 1;%0 to 100%
tier2 = 1.3;%101 to 130%
tier3 = 2;%131 to 200%
tier4 = 3;%200 to 300%
tier5 = 20;%greater than 300%

rate1 = .1323;%tier 1 rate
rate2 = .1504;
rate3 = .30025;
rate4 = .34025;
rate5 = .34025;

con1=0;con2=0;con3=0;con4=0;con5=0;

%tier1 consumption
if consumption <= baseline
    con1=consumption;
else
    con1 = baseline;
    if consumption <= baseline*tier2
        con2 = consumption - baseline;
    else
        con2 = (tier2-tier1)*baseline;
        if consumption <= baseline*tier3
            con3 = consumption - tier2*baseline;
        else
            con3 = (tier3 - tier2)*baseline;
            if consumption <=baseline*tier4
                con4 = consumption - tier3*baseline;
            else
                con4 = (tier4 - tier3)*baseline;
                if (consumption > (baseline*tier4))
                    con5 = consumption - tier4*baseline;
                end
            end
        end
    end
end
% 
% con1
% con2
% con3
% con4
% con5

cost = con1*rate1 + con2*rate2 + con3*rate3 + con4*rate4 +con5*rate5;
overall_rate = cost/consumption;

display(['Total cost is ' num2str(cost) ' at a rate of ' num2str(overall_rate) ' per kWh']);