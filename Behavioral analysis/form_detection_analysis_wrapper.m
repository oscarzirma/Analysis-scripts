function form_detection_analysis_wrapper(bird)
%This function will run through a folder, import each mat file, and analyze
%cueing effect on performance

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
TC = cell(n,1);TU = TC;SC=TC;SU=TC;PDC=TC;PDU=TC;SCV = TC;rt = [];si = [];sc=[];sp=[];dp=[];cu=[];
most_contrasts = 0;
for ii = 1:n
    load(file(ii).name,'OUT','SUCC');
    [Tc,Tu,Sc,Su,Pdc,Pdu,scv,dpi] = analyze_form_detection_task(OUT,SUCC);
    TC(ii) = {Tc};
    TU(ii) = {Tu};
    SC(ii) = {Sc};
    SU(ii) = {Su};
    PDC(ii) = {Pdc};
    PDU(ii) = {Pdu};
    SCV(ii) = {scv};
    if length(scv) > length(most_contrasts)
        most_contrasts = scv;
    end
    
    %Extract data for rxn time analysis
    rt = [rt OUT.reaction_time];
    si = [si SUCC.index];
    sp = [sp OUT.stim_positions];
    sc = [sc OUT.stim_contrast];
    dp = [dp dpi];
    cu = [cu OUT.cue];
    
end

c = length(most_contrasts);
con = unique(sc);

%%
%Combine data across sessions
Cued_totals_by_contrast = cell(1,c);Uncued_totals_by_contrast = cell(1,c);
Cued_successes_by_contrast = cell(1,c);Uncued_successes_by_contrast = cell(1,c);
Cued_performance_discrim_by_contrast = cell(1,c);Uncued_performance_discrim_by_contrast = cell(1,c);
Cued_performance_by_session = nan(c,n);
Uncued_performance_by_session = nan(c,n);
for ii = 1:n
    Tc = cell2mat(TC(ii));
    Tu = cell2mat(TU(ii));
    Sc = cell2mat(SC(ii));
    Su = cell2mat(SU(ii));
    Pdc = cell2mat(PDC(ii));
    Pdu = cell2mat(PDU(ii));
    for jj = 1:c %for each cosumntrast tested
        k = find(cell2mat(SCV(ii)) == most_contrasts(jj));
        if ~isempty(k)%if this contrast was tested in this session, add it to the pile!
            X = cell2mat(Cued_totals_by_contrast(jj));
            if isempty(X)
                de = 0;
            else
                de = size(X,3);
            end
            X(:,:,de+1) = Tc(:,:,k);
            Cued_totals_by_contrast(jj) = {X};
            
            X = cell2mat(Uncued_totals_by_contrast(jj));
            X(:,:,de+1) = Tu(:,:,k);
            Uncued_totals_by_contrast(jj) = {X};
                        
            X = cell2mat(Cued_successes_by_contrast(jj));
            X(:,:,de+1) = Sc(:,:,k);
            Cued_successes_by_contrast(jj) = {X};
                        
            X = cell2mat(Uncued_successes_by_contrast(jj));
            X(:,:,de+1) = Su(:,:,k);
            Uncued_successes_by_contrast(jj) = {X};
                        
            X = cell2mat(Cued_performance_discrim_by_contrast(jj));
            ro = size(X,1);
            X(ro+1,:) = Pdc(k,:);
            Cued_performance_discrim_by_contrast(jj) = {X};
                        
            X = cell2mat(Uncued_performance_discrim_by_contrast(jj));
            X(ro+1,:) = Pdu(k,:);
            Uncued_performance_discrim_by_contrast(jj) = {X};
            
            Cued_performance_by_session(jj,ii) = sum(sum(Sc(:,:,k)))./sum(sum(Tc(:,:,k)));
            Uncued_performance_by_session(jj,ii) = sum(sum(Su(:,:,k)))./sum(sum(Tu(:,:,k)));
        end
    end
end

%%
%Make the first figure, contrast response functions for each discrimination
%cued_mean = zeros(1,c);cued_err = zeros(1,c);
%uncued_mean = zeros(1,c);uncued_err = zeros(1,c);
for ii = 1:c
    x = cell2mat(Cued_performance_discrim_by_contrast(ii));
    cued_mean(ii,:) = mean(x);
    cued_err(ii,:) = std(x)./sqrt(size(x,1));
        
    y = cell2mat(Uncued_performance_discrim_by_contrast(ii));
    uncued_mean(ii,:) = mean(y);
    uncued_err(ii,:) = std(y)./sqrt(size(y,1));
    
    loc_signif(ii,1) = kruskalwallis([x(:,1) y(:,1)],[],'off');
    loc_signif(ii,2) = kruskalwallis([x(:,2) y(:,2)],[],'off');
    loc_signif(ii,3) = kruskalwallis([x(:,3) y(:,3)],[],'off');
    loc_signif(ii,4) = kruskalwallis([x(:,4) y(:,4)],[],'off');
    
    x = cell2mat(Cued_successes_by_contrast(ii));
    y = cell2mat(Cued_totals_by_contrast(ii));
    cued_overall = squeeze(sum(sum(x))./sum(sum(y)));
    x = cell2mat(Uncued_successes_by_contrast(ii));
    y = cell2mat(Uncued_totals_by_contrast(ii));
    uncued_overall = squeeze(sum(sum(x))./sum(sum(y)));
    
    ov_signif(ii) = kruskalwallis([cued_overall uncued_overall],[],'off');
    
    cued_overall_mean(ii) = nanmean(cued_overall);
    cued_overall_err(ii) = nanstd(cued_overall)/sqrt(length(cued_overall));
    
    uncued_overall_mean(ii) = nanmean(uncued_overall);
    uncued_overall_err(ii) = nanstd(uncued_overall)/sqrt(length(uncued_overall));
    
    %Overall analysis with only left and right discrims
    s = cell2mat(Cued_successes_by_contrast(ii));
    t = cell2mat(Cued_totals_by_contrast(ii));

        
    x = squeeze((s(1,3,:) + s(3,1,:) + s(2,4,:) + s(4,2,:) + s(1,2,:) + s(2,1,:))./(t(1,3,:) + t(3,1,:) + t(2,4,:) + t(4,2,:) + t(1,2,:) + t(2,1,:)));
    mn_lr_c_overall(ii) = mean(x);
    er_lr_c_overall(ii) = std(x)/sqrt(length(x));
    
    s = cell2mat(Uncued_successes_by_contrast(ii));
    t = cell2mat(Uncued_totals_by_contrast(ii));


    y = squeeze((s(1,3,:) + s(3,1,:) + s(2,4,:) + s(4,2,:) + s(1,2,:) + s(2,1,:))./(t(1,3,:) + t(3,1,:) + t(2,4,:) + t(4,2,:) + t(1,2,:) + t(2,1,:)));
    mn_lr_u_overall(ii) = mean(y);
    er_lr_u_overall(ii) = std(y)/sqrt(length(y));
    lr_overall_signif(ii) = kruskalwallis([x y],[],'off');
end
ov_signif
f1 = figure;
errorbar(most_contrasts,cued_overall_mean,cued_overall_err,'r','Linewidth',2);
hold on
errorbar(most_contrasts,uncued_overall_mean,uncued_overall_err,'b','Linewidth',2);
set(gca,'XScale','log')
axis([.007 .15 .48 .82])
set(gca,'XTick',con)
xlabel('Contrast')
ylabel('Proportion correct')
box off


f2 = figure;
subplot(221)
errorbar(most_contrasts,cued_mean(:,1),cued_err(:,1),'r','Linewidth',2)
hold on
errorbar(most_contrasts,uncued_mean(:,1),uncued_err(:,1),'b','Linewidth',2)
title('Left')
set(gca,'XScale','log')
axis([.007 .15 .43 .95])
set(gca,'XTick',con)
box off


subplot(222)
errorbar(most_contrasts,cued_mean(:,2),cued_err(:,2),'r','Linewidth',2)
hold on;
errorbar(most_contrasts,uncued_mean(:,2),uncued_err(:,2),'b','Linewidth',2)
title('Up')
set(gca,'XScale','log')
axis([.007 .15 .43 .95])
set(gca,'XTick',con)
box off

subplot(224)
errorbar(most_contrasts,cued_mean(:,3),cued_err(:,3),'r','Linewidth',2)
hold on;
errorbar(most_contrasts,uncued_mean(:,3),uncued_err(:,3),'b','Linewidth',2)
title('Right')
set(gca,'XScale','log')
axis([.007 .15 .43 .95])
set(gca,'XTick',con)
box off

subplot(223)
errorbar(most_contrasts,cued_mean(:,4),cued_err(:,4),'r','Linewidth',2)
hold on;
errorbar(most_contrasts,uncued_mean(:,4),uncued_err(:,4),'b','Linewidth',2)
title('Down')
set(gca,'XScale','log')
axis([.007 .15 .43 .95])
set(gca,'XTick',con)
xlabel('Contrast')
ylabel('Proportion correct')
box off

loc_signif

%%
%Reaction time figures
for ii=1:c
    %overall successful
    x = (rt(si==1&cu==1&sc==con(ii)));
    mn_c(ii) = nanmean(x);
    er_c(ii) =nanstd(x)/sqrt(length(x));
    y = (rt(si==1&cu==0&sc==con(ii)));
    mn_u(ii) = nanmean(y);
    er_u(ii) =nanstd(y)/sqrt(length(y));
    signif_overall(ii) = kruskalwallis([x y],[ones(size(x)) ones(size(y))*2],'off');
    
    %overall all responses
        x = (rt(si~=-5&cu==1&sc==con(ii)));
    mna_c(ii) = nanmean(x);
    era_c(ii) =nanstd(x)/sqrt(length(x));
    y = (rt(si~=-5&cu==0&sc==con(ii)));
    mna_u(ii) = nanmean(y);
    era_u(ii) =nanstd(y)/sqrt(length(y));
    signif_overall_all(ii) = kruskalwallis([x y],[ones(size(x)) ones(size(y))*2],'off');
    
    %left
    x = rt(si==1&cu==1&sc==con(ii)&((sp==1&dp==3)|(sp==3&dp==1)));
    y = rt(si==1&cu==0&sc==con(ii)&((sp==1&dp==3)|(sp==3&dp==1)));
    d_mn_c(ii,1) = nanmean(x);
    d_mn_u(ii,1) = nanmean(y);
    d_er_c(ii,1) = nanstd(x)/sqrt(length(x));
    d_er_u(ii,1) = nanstd(x)/sqrt(length(x));
    signif_discrim(ii,1) = kruskalwallis([x y],[ones(size(x)) ones(size(y))*2],'off');

    %up
    x = rt(si==1&cu==1&sc==con(ii)&((sp==4&dp==3)|(sp==3&dp==4)));
    y = rt(si==1&cu==0&sc==con(ii)&((sp==4&dp==3)|(sp==3&dp==4)));
    d_mn_c(ii,2) = nanmean(x);
    d_mn_u(ii,2) = nanmean(y);
    d_er_c(ii,2) = nanstd(x)/sqrt(length(x));
    d_er_u(ii,2) = nanstd(x)/sqrt(length(x));
    signif_discrim(ii,2) = kruskalwallis([x y],[ones(size(x)) ones(size(y))*2],'off');
        
    %right
    x = rt(si==1&cu==1&sc==con(ii)&((sp==4&dp==2)|(sp==2&dp==4)));
    y = rt(si==1&cu==0&sc==con(ii)&((sp==4&dp==2)|(sp==2&dp==4)));
    d_mn_c(ii,3) = nanmean(x);
    d_mn_u(ii,3) = nanmean(y);
    d_er_c(ii,3) = nanstd(x)/sqrt(length(x));
    d_er_u(ii,3) = nanstd(x)/sqrt(length(x));
    signif_discrim(ii,3) = kruskalwallis([x y],[ones(size(x)) ones(size(y))*2],'off');
    
    %down
    x = rt(si==1&cu==1&sc==con(ii)&((sp==1&dp==2)|(sp==2&dp==1)));
    y = rt(si==1&cu==0&sc==con(ii)&((sp==1&dp==2)|(sp==2&dp==1)));
    d_mn_c(ii,4) = nanmean(x);
    d_mn_u(ii,4) = nanmean(y);
    d_er_c(ii,4) = nanstd(x)/sqrt(length(x));
    d_er_u(ii,4) = nanstd(x)/sqrt(length(x));
    signif_discrim(ii,4) = kruskalwallis([x y],[ones(size(x)) ones(size(y))*2],'off');
    
    
    %full contrast response
    x = si(sc==con(ii));
    con_perf(ii) = sum(x==1)/sum(x==1|x==-3);
    
    
end

%Overall performance
f3 = figure;
subplot(121)
errorbar(con,mn_c,er_c,'r','Linewidth',2)
hold on;
errorbar(con,mn_u,er_u,'b','Linewidth',2)
set(gca,'XScale','log')
axis([.007 .15 .29 .4])
set(gca,'XTick',con)
title('Successful responses')
box off
xlabel('Contrast')
ylabel('Reaction time (s)')

subplot(122)
errorbar(con,mna_c,era_c,'r','Linewidth',2)
hold on;
errorbar(con,mna_u,era_u,'b','Linewidth',2)
set(gca,'XScale','log')
axis([.007 .15 .29 .4])
set(gca,'XTick',con)
title('All responses')
box off


signif_overall
signif_overall_all

f4 = figure;
subplot(221)
errorbar(con,d_mn_c(:,1),d_er_c(:,1),'r','Linewidth',2)
hold on
errorbar(con,d_mn_u(:,1),d_er_u(:,1),'b','Linewidth',2)
title('Left')
set(gca,'XScale','log')
axis([.007 .15 .25 .43])
set(gca,'XTick',con)
box off

subplot(222)
errorbar(con,d_mn_c(:,2),d_er_c(:,2),'r','Linewidth',2)
hold on;
errorbar(con,d_mn_u(:,2),d_er_u(:,2),'b','Linewidth',2)
title('Up')
set(gca,'XScale','log')
axis([.007 .15 .25 .43])
set(gca,'XTick',con)
box off

subplot(224)
errorbar(con,d_mn_c(:,3),d_er_c(:,3),'r','Linewidth',2)
hold on;
errorbar(con,d_mn_u(:,3),d_er_u(:,3),'b','Linewidth',2)
title('Right')
set(gca,'XScale','log')
axis([.007 .15 .25 .43])
set(gca,'XTick',con)
box off

subplot(223)
errorbar(con,d_mn_c(:,4),d_er_c(:,4),'r','Linewidth',2)
hold on;
errorbar(con,d_mn_u(:,4),d_er_u(:,4),'b','Linewidth',2)
title('Down')
set(gca,'XScale','log')
axis([.007 .15 .25 .43])
set(gca,'XTick',con)
box off
xlabel('Contrast')
ylabel('Reaction time (s)')

signif_discrim

%%
%Overall performance over time

f5 = figure;
subplot(311)
imagesc(Uncued_performance_by_session,[.25 .86]);
title('Uncued performance')
set(gca,'YTick',1:5)
set(gca,'YTickLabel',con)
colorbar

subplot(312)
imagesc(Cued_performance_by_session,[.25 .86]);
title('Cued performance')
set(gca,'YTick',1:5)
set(gca,'YTickLabel',con)
colorbar

subplot(313)
imagesc(Cued_performance_by_session - Uncued_performance_by_session);
title('Difference between cued and uncued')
xlabel('Session')
ylabel('Contrast')
set(gca,'YTick',1:5)
set(gca,'YTickLabel',con)
colorbar

f6 = figure;
plot(con,nanmean(Cued_performance_by_session - Uncued_performance_by_session,2),'ko','Linewidth',2,'Markersize',12)
title('Mean difference by contrast')
set(gca,'XScale','log')
set(gca,'XTick',con)
xlabel('Contrast')
ylabel('Difference in proportion correct')
box off 
set(gca,'XScale','log')

%%
%basic overall figures

%contrast response
f7 = figure;
plot(con,con_perf,'ko-','Linewidth',2,'Markersize',12)
set(gca,'XScale','log')
set(gca,'XTick',con)
xlabel('Contrast')
ylabel('Proportion correct')
box off 
set(gca,'XScale','log')

%Performance in each quadrant based on discrimination
x = si(sp==1&dp==3);
qp(1) = sum(x==1)/sum(x==1|x==-3);%Left - down
x = si(sp==3&dp==1);
qp(2) = sum(x==1)/sum(x==1|x==-3);%Left - up
x = si(sp==3&dp==4);
qp(3) = sum(x==1)/sum(x==1|x==-3);%Up -left
x = si(sp==4&dp==3);
qp(4) = sum(x==1)/sum(x==1|x==-3);%Up -right
x = si(sp==4&dp==2);
qp(5) = sum(x==1)/sum(x==1|x==-3);%Right - up
x = si(sp==2&dp==4);
qp(6) = sum(x==1)/sum(x==1|x==-3);%Right -down
x = si(sp==2&dp==1);
qp(7) = sum(x==1)/sum(x==1|x==-3);%Down -right
x = si(sp==1&dp==2);
qp(8) = sum(x==1)/sum(x==1|x==-3);%Down -left
qp(9) = sum(si==1)/sum(si==1|si==-3);%All

lab = {'LD - left','LU - left','LU - up','RU - up','RU - right','RD - right','RD - down','LD - down','All'};
f8 = figure;
h = barh(qp,'EdgeColor','k','FaceColor','w');
set(gca,'YTickLabel',lab);
xlabel('Proportion correct')

%Overall cue effect on rxn time
f9 = figure;
plot(con,(mn_c-mn_u).*1000,'ko','Linewidth',2,'Markersize',12)
hold on
plot(con,(mna_c-mna_u).*1000,'go','Linewidth',2,'Markersize',12)
title('Mean rxn time difference of cue by contrast')
set(gca,'XScale','log')
set(gca,'XTick',con)
xlabel('Contrast')
ylabel('Difference in reaction time (ms)')
box off 
set(gca,'XScale','log')


%Cue effect across sessions
f10 = figure;
plot(nanmean(Cued_performance_by_session-Uncued_performance_by_session),'ko','Linewidth',2,'Markersize',12)
xlabel('Session')
ylabel('Difference between cued and uncued proportion correct')


%%
%Overall cue effect with only left and right discriminations
f11 = figure;
errorbar(con,mn_lr_c_overall,er_lr_c_overall,'r','Linewidth',2);
hold on
errorbar(con,mn_lr_u_overall,er_lr_u_overall,'b','Linewidth',2);
set(gca,'XScale','log')
axis([.007 .15 .48 .82])
set(gca,'XTick',con)
xlabel('Contrast')
ylabel('Proportion correct')
box off

lr_overall_signif

%%
bird = 63;
set_form_detection_axes

%%
%Save figures
figure(f1)
print(gcf,'-depsc2',['c' num2str(bird) '_fig1_overallPropCorr']);

figure(f2)
print(gcf,'-depsc2',['c' num2str(bird) '_fig2_discrimLocPropCorr']);

figure(f3)
print(gcf,'-depsc2',['c' num2str(bird) '_fig3_overallRxnTimes']);

figure(f4)
print(gcf,'-depsc2',['c' num2str(bird) '_fig4_discrimLocRxnTimes']);

figure(f5)
set(gcf,'renderer','opengl');
print(gcf,'-depsc2',['c' num2str(bird) '_fig5_perfOverTime']);

figure(f6)
print(gcf,'-depsc2',['c' num2str(bird) '_fig6_meanContrastEffect']);

figure(f7)
print(gcf,'-depsc2',['c' num2str(bird) '_fig7_basicCRF']);

figure(f8)
print(gcf,'-depsc2',['c' num2str(bird) '_fig8_quadrantPerf']);

figure(f9)
print(gcf,'-depsc2',['c' num2str(bird) '_fig9_meanCueEffectRxnTime']);

figure(f10)
print(gcf,'-depsc2',['c' num2str(bird) '_fig10_meanCueEffectPropCorrSessions']);

figure(f11)

keyboard