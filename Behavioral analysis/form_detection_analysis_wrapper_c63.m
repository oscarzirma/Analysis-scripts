function form_detection_analysis_wrapper_c63()
%This function will run through a folder, import each mat file, and analyze
%cueing effect on performance

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
for ii = 1:n
    Tc = cell2mat(TC(ii));
    Tu = cell2mat(TU(ii));
    Sc = cell2mat(SC(ii));
    Su = cell2mat(SU(ii));
    Pdc = cell2mat(PDC(ii));
    Pdu = cell2mat(PDU(ii));
    for jj = 1:c %for each contrast tested
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
    
    cued_overall_mean(ii) = mean(cued_overall);
    cued_overall_err(ii) = std(cued_overall)/sqrt(length(cued_overall));
    
    uncued_overall_mean(ii) = mean(uncued_overall);
    uncued_overall_err(ii) = std(uncued_overall)/sqrt(length(uncued_overall));

end
ov_signif
f1 = figure;
errorbar(most_contrasts,cued_overall_mean,cued_overall_err,'r','Linewidth',2);
hold on
errorbar(most_contrasts,uncued_overall_mean,uncued_overall_err,'b','Linewidth',2);
set(gca,'XScale','log')
set(gca,'XTick',con)

f2 = figure;
subplot(221)
errorbar(most_contrasts,cued_mean(:,1),cued_err(:,1),'r','Linewidth',2)
hold on
errorbar(most_contrasts,uncued_mean(:,1),uncued_err(:,1),'b','Linewidth',2)
title('Left')
set(gca,'XScale','log')
axis([.007 .4 .43 .9])
set(gca,'XTick',con)

subplot(222)
errorbar(most_contrasts,cued_mean(:,2),cued_err(:,2),'r','Linewidth',2)
hold on;
errorbar(most_contrasts,uncued_mean(:,2),uncued_err(:,2),'b','Linewidth',2)
title('Up')
set(gca,'XScale','log')
axis([.007 .4 .43 .9])
set(gca,'XTick',con)

subplot(224)
errorbar(most_contrasts,cued_mean(:,3),cued_err(:,3),'r','Linewidth',2)
hold on;
errorbar(most_contrasts,uncued_mean(:,3),uncued_err(:,3),'b','Linewidth',2)
title('Right')
set(gca,'XScale','log')
axis([.007 .4 .43 .9])
set(gca,'XTick',con)

subplot(223)
errorbar(most_contrasts,cued_mean(:,4),cued_err(:,4),'r','Linewidth',2)
hold on;
errorbar(most_contrasts,uncued_mean(:,4),uncued_err(:,4),'b','Linewidth',2)
title('Down')
set(gca,'XScale','log')
axis([.007 .4 .43 .9])
set(gca,'XTick',con)

loc_signif

%%
%Reaction time figures
f3 = figure;

for ii=1:c
    x = (rt(si==1&cu==1&sc==con(ii)));
    mn_c(ii) = nanmean(x);
    er_c(ii) =nanstd(x)/sqrt(length(x));
    y = (rt(si==1&cu==0&sc==con(ii)));
    mn_u(ii) = nanmean(y);
    er_u(ii) =nanstd(y)/sqrt(length(y));
    signif_overall(ii) = kruskalwallis([x y],[ones(size(x)) ones(size(y))*2],'off');
    
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
end

%Overall performance
errorbar(con,mn_c,er_c,'r','Linewidth',2)
hold on;
errorbar(con,mn_u,er_u,'b','Linewidth',2)
set(gca,'XScale','log')
axis([.007 .4 .37 .48])
set(gca,'XTick',con)

signif_overall

f4 = figure;
subplot(221)
errorbar(con,d_mn_c(:,1),d_er_c(:,1),'r','Linewidth',2)
hold on
errorbar(con,d_mn_u(:,1),d_er_u(:,1),'b','Linewidth',2)
title('Left')
set(gca,'XScale','log')
axis([.007 .4 .35 .57])
set(gca,'XTick',con)

subplot(222)
errorbar(con,d_mn_c(:,2),d_er_c(:,2),'r','Linewidth',2)
hold on;
errorbar(con,d_mn_u(:,2),d_er_u(:,2),'b','Linewidth',2)
title('Up')
set(gca,'XScale','log')
axis([.007 .4 .35 .57])
set(gca,'XTick',con)

subplot(224)
errorbar(con,d_mn_c(:,3),d_er_c(:,3),'r','Linewidth',2)
hold on;
errorbar(con,d_mn_u(:,3),d_er_u(:,3),'b','Linewidth',2)
title('Right')
set(gca,'XScale','log')
axis([.007 .4 .35 .57])
set(gca,'XTick',con)

subplot(223)
errorbar(con,d_mn_c(:,4),d_er_c(:,4),'r','Linewidth',2)
hold on;
errorbar(con,d_mn_u(:,4),d_er_u(:,4),'b','Linewidth',2)
title('Down')
set(gca,'XScale','log')
axis([.007 .4 .35 .57])
set(gca,'XTick',con)

signif_discrim

keyboard

bird = 63;
set_form_detection_axes

