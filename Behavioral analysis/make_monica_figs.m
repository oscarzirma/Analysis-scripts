function make_monica_figs(A,B)
%This function will make the figures for monica's analysis

for i = 1:length(A)
    total_perf(i) = sum(sum(A(i).S))/sum(sum(A(i).T));
    
    all_tot(:,:,i) = A(i).T;
    all_suc(:,:,i) = A(i).S;
    
    all_HP(:,:,i) = A(i).HP;
    
end

for j = 1:4
    quad_perf(j,:) = sum(squeeze(all_suc(:,j,:)))./sum(squeeze(all_tot(:,j,:))); 
    dist_perf(j,:) = sum(squeeze(all_suc(j,:,:)))./sum(squeeze(all_tot(j,:,:)));
end

quad_perf_all = sum(B.S)./sum(B.T);

quad_perf_med = median(quad_perf,2);
quad_perf_mean = mean(quad_perf,2);
quad_perf_err = std(quad_perf,[],2)/sqrt(i);

dist_perf_med = median(dist_perf,2);
dist_perf_mean = mean(dist_perf,2);
dist_perf_err = std(dist_perf,[],2)/sqrt(i);

figure
title('Performance by session');
plot(total_perf,'ko-')
axis([0 i+1 .5 .85])

figure
title('Quadrant performance')
errorbar(1:4,quad_perf_mean,quad_perf_err)
hold on
plot(quad_perf_med,'ko-')
plot(quad_perf_all,'r*')

figure
title('Distractor performance')
errorbar(1:4,dist_perf_mean,dist_perf_err)
hold on
plot(dist_perf_med,'ko-')

figure
title('Relative distractor position effect by quadrant - Means');
subplot(121)
plot(B.HP,'o-')
xlabel('Quadrant')
legend('Same hemifield','Diagonal','Opposite hemifield')
subplot(122)
plot(B.HP','o-')
set(gca,'XTick',[1:3]);
set(gca,'XTickLabel',{['Same hemifield'],['Diagonal'],['Opposite hemifield']})
legend('Q1','Q2','Q3','Q4');

figure
title('Relative distractor position effect by quadrant');
subplot(2,2,1)
x = squeeze(all_HP(3,:,:));
plot(x,'ko-')
hold on;
errorbar(mean(x,2),std(x,[],2)/sqrt(i),'r','LineWidth',2)
set(gca,'XTick',[1:3]);
axis([0.5 3.5 .2 1]);

subplot(2,2,2)
x = squeeze(all_HP(4,:,:));
plot(x,'ko-')
hold on;
errorbar(mean(x,2),std(x,[],2)/sqrt(i),'r','LineWidth',2)
set(gca,'XTick',[1:3]);
axis([0.5 3.5 .2 1]);

subplot(2,2,3)
x = squeeze(all_HP(1,:,:));
plot(x,'ko-')
hold on;
errorbar(mean(x,2),std(x,[],2)/sqrt(i),'r','LineWidth',2)
set(gca,'XTick',[1:3]);
set(gca,'XTickLabel',{['Same hemifield'],['Diagonal'],['Opposite hemifield']})
axis([0.5 3.5 .2 1]);

subplot(2,2,4)
x = squeeze(all_HP(2,:,:));
plot(x,'ko-')
hold on;
errorbar(mean(x,2),std(x,[],2)/sqrt(i),'r','LineWidth',2)
set(gca,'XTick',[1:3]);
set(gca,'XTickLabel',{['Same hemifield'],['Diagonal'],['Opposite hemifield']})
axis([0.5 3.5 .2 1]);
% subplot(122)
% plot(B.HP','o-')
% set(gca,'XTick',[1:3]);
% set(gca,'XTickLabel',{['Same hemifield'],['Opposite hemifield'],['Diagonal']})
% legend('Q1','Q2','Q3','Q4');

% xlabel('Quadrant')
% legend('Same hemifield','Opposite hemifield','Diagonal')

figure
x = squeeze(all_HP(3,:,:));
errorbar(mean(x,2),std(x,[],2)/sqrt(i),'r','LineWidth',2)
hold on
x = squeeze(all_HP(4,:,:));
errorbar(mean(x,2),std(x,[],2)/sqrt(i),'c','LineWidth',2)
x = squeeze(all_HP(1,:,:));
errorbar(mean(x,2),std(x,[],2)/sqrt(i),'b','LineWidth',2)
x = squeeze(all_HP(2,:,:));
errorbar(mean(x,2),std(x,[],2)/sqrt(i),'g','LineWidth',2)

keyboard
