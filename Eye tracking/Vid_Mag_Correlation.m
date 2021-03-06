function output=Vid_Mag_Correlation(centroid,mdata,shift)
%given a centroid matrix (with X in the first column and Y in the second)
%and an mdata matrix with time in the first row, sensor 1 in the second,
%and sensor 2 in the third, this program will: (1) find the temporal shift
%between the two traces by maximizing the correlation between the aligned
%traces while shifting the temporal alignment. (2) find the linear correlations
%between the four combinations of centroid-mdata traces (X-M1 Y-M1, X-M2, Y-M2)
%and plot with the least squares regression fit. If shift == 'find', the
%program will compute the shift. Otherwise it will use the specified shift.

v_time = (1/30:1/30:length(centroid)/30);%time for centroid/video trace. assume 30fps frame rate

Inan=find(isnan(centroid(:,1)));
v_time(Inan)=[];
centroid(Inan,:)=[];

if strcmp(shift,'find')

shift_range = (-.05:.001:.05); %temporal shift range to test. �50 ms in 1 ms steps (default)
%shift_range=0;
for i=1:length(shift_range)
    shift_range(i);
    aligned=aligned_mag_vid(v_time,centroid(:,1),mdata(1,:)./1000,mdata(2,:),shift_range(i));
    cor = corrcoef(aligned);
    corr(i) = cor(2,1);
end
corr;
[min ind] = max(abs(corr));

shift_opt = shift_range(ind);

display(['Best correlation is ' num2str(corr(ind)) ', which occurs at a temporal shift of ' num2str(shift_opt)]);

else
    shift_opt = shift;
end

m1_vs_X = aligned_mag_vid(v_time,centroid(:,1),mdata(1,:)./1000,mdata(2,:),shift_opt);%find temporally aligned m1 vs x trace
m1xcor=corrcoef(m1_vs_X);%find correlation coefficient between aligned m1 and x
m1xp =polyfit(m1_vs_X(:,2),m1_vs_X(:,1),1);%fit the aligned traces

m1_vs_Y = aligned_mag_vid(v_time,centroid(:,2),mdata(1,:)./1000,mdata(2,:),shift_opt);
m1ycor=corrcoef(m1_vs_Y);
m1yp =polyfit(m1_vs_Y(:,2),m1_vs_Y(:,1),1);

m2_vs_X = aligned_mag_vid(v_time,centroid(:,1),mdata(1,:)./1000,mdata(3,:),shift_opt);
m2xcor=corrcoef(m2_vs_X);
m2xp =polyfit(m2_vs_X(:,2),m2_vs_X(:,1),1);

m2_vs_Y = aligned_mag_vid(v_time,centroid(:,2),mdata(1,:)./1000,mdata(3,:),shift_opt);
m2ycor=corrcoef(m2_vs_Y);
m2yp =polyfit(m2_vs_Y(:,2),m2_vs_Y(:,1),1);

m1_vs_m2 = [m1_vs_X(:,2),m2_vs_X(:,2)]; 
m1m2cor=corrcoef(m1_vs_m2);
m1m2p = polyfit(m1_vs_m2(:,2),m1_vs_m2(:,1),1);

X_vs_Y = [m1_vs_X(:,1),m1_vs_Y(:,1)]; 
xycor=corrcoef(X_vs_Y);
xyp = polyfit(X_vs_Y(:,2),X_vs_Y(:,1),1);

% figure;
% subplot(211)
% plot(v_time,m1_vs_X(:,1))
% subplot(212)
% plot(v_time,m1_vs_X(:,2))
figure;
subplot(231)
scatter(m1_vs_X(:,2),m1_vs_X(:,1));title('M1 vs X');hold on;plot(m1_vs_X(:,2),polyval(m1xp,m1_vs_X(:,2)))
subplot(234)
scatter(m1_vs_Y(:,2),m1_vs_Y(:,1));title('M1 vs Y');hold on;plot(m1_vs_Y(:,2),polyval(m1yp,m1_vs_Y(:,2)))
subplot(232)
scatter(m2_vs_X(:,2),m2_vs_X(:,1));title('M2 vs X');hold on;plot(m2_vs_X(:,2),polyval(m2xp,m2_vs_X(:,2)))
subplot(235)
scatter(m2_vs_Y(:,2),m2_vs_Y(:,1));title('M2 vs Y');hold on;plot(m2_vs_Y(:,2),polyval(m2yp,m2_vs_Y(:,2)))
subplot(233)
scatter(m1_vs_m2(:,2),m1_vs_m2(:,1));title('M1 vs M2');hold on;plot(m1_vs_m2(:,2),polyval(m1m2p,m1_vs_m2(:,2)))
subplot(236)
scatter(X_vs_Y(:,2),X_vs_Y(:,1));title('X vs Y');hold on;plot(X_vs_Y(:,2),polyval(xyp,X_vs_Y(:,2)))

display(['Sensor 1 versus X correlation = ' num2str(m1xcor(2,1)) '. Linear regression: m = ' num2str(m1xp(1)) ' b = ' num2str(m1xp(2)) '.'])
display(['Sensor 1 versus Y correlation = ' num2str(m1ycor(2,1)) '. Linear regression: m = ' num2str(m1yp(1)) ' b = ' num2str(m1yp(2)) '.'])
display(['Sensor 2 versus X correlation = ' num2str(m2xcor(2,1)) '. Linear regression: m = ' num2str(m2xp(1)) ' b = ' num2str(m2xp(2)) '.'])
display(['Sensor 2 versus Y correlation = ' num2str(m2ycor(2,1)) '. Linear regression: m = ' num2str(m2yp(1)) ' b = ' num2str(m2yp(2)) '.'])
display(['Sensor 1 versus Sensor 2 correlation = ' num2str(m1m2cor(2,1)) '. Linear regression: m = ' num2str(m1m2p(1)) ' b = ' num2str(m1m2p(2)) '.']);
display(['X versus Y correlation = ' num2str(xycor(2,1)) '. Linear regression: m = ' num2str(xyp(1)) ' b = ' num2str(xyp(2)) '.']);

output = [m1_vs_X(:,1) m2_vs_Y(:,1) m1_vs_Y(:,2) m2_vs_Y(:,2)];

figure
scatter3(m1_vs_X(:,2),m2_vs_X(:,2),m1_vs_X(:,1));title('M1/M2 vs X')

figure
scatter3(m1_vs_Y(:,2),m2_vs_Y(:,2),m1_vs_Y(:,1));title('M1/M2 vs Y')