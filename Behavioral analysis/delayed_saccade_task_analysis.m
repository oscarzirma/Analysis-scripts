%Script to analyze delayed saccade task first used in summer 2014 on birds
%59 and 75

%Set figure defaults
% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Times New Roman')
set(0,'DefaultAxesFontSize', 15)

% Change default text fonts.
set(0,'DefaultTextFontname', 'Times New Roman')
set(0,'DefaultTextFontSize', 18)

%%
%Extract data for each session
file = dir('*.mat');
n = length(file);
perf_corr = zeros(n,1);
success_index = [];
stim_pos = [];
for ii = 1:n
    load(file(ii).name,'OUT','SUCC');
    perf_corr(ii) = sum(SUCC.index==1)/length(SUCC.index);
    success_index = [success_index SUCC.index];
    stim_pos = [stim_pos OUT.stim_positions];
end

%Figure 1 - performance over time
f1 = figure;
plot(perf_corr,'ko-','LineWidth',2,'MarkerSize',8,'MarkerFaceColor','k')
xlabel('Session number')
ylabel('Proportion correct')
title('Delayed saccade task: performance over time')


%Put together data across sessions
centers = [-5  -2 1];
for ii = 1:4
    hsp = hist(success_index(stim_pos == ii),centers);
    P(ii,:) = hsp;
end

Lab = [{'Upper left'},{'Upper right'},{'Lower left'},{'Lower right'}];

%Figure 2 - performance by quadrant overall
barh(P,'stacked')
set(gca,'YTickLabel',Lab)
leg = legend('Time out','Response to stimulus','Correct response','Location','BestOutside');
xlabel('Number of trials');
ylabel('Quadrant');
title('Performance by quadrant')