function cued_reaction_time_analysis(OUT,SUCC)
%This function will compare reaction times between cued and uncued trials

success = SUCC.index == 1; %get successful go trials

cued = OUT.cue == 1;%get cued trials

sp = OUT.stim_positions;

figure
scatter(OUT.stim_positions(success&cued),OUT.reaction_time(success&cued),'r');
hold on
scatter(OUT.stim_positions(success&~cued),OUT.reaction_time(success&~cued),'b');
title('Cued (red) and uncued (blue) response times by quadrant');


 for i = 1:4
     c = OUT.reaction_time(sp==i&success&cued);
     u = OUT.reaction_time(sp==i&success&~cued);
     
     cued_mean(i) = mean(c);
     uncued_mean(i) = mean(u);
     
     cued_sem(i) = std(c)/sqrt(length(c));
     uncued_sem(i) = std(u)/sqrt(length(u));
     
     wilcox_cue_uncue(i) = ranksum(c,u);
     
      for j = i:4
         wilcox_quadrant(i,j) = ranksum(OUT.reaction_time(sp == i&success),OUT.reaction_time(sp==j&success));
      end
     
     CUED(i) = {c};
     UNCUED(i) = {u};
 end
 
 errorbar(1:4,cued_mean,cued_sem,'r')
 errorbar(1:4,uncued_mean,uncued_sem,'b')
 
 display(['Ranksum test of cued vs uncued: ' num2str(wilcox_cue_uncue)])
 
 wilcox_quadrant
