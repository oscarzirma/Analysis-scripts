%This script will set all the figure axes depending on the bird

if bird == 63
    %overall prop corr
    figure(f1)
    axis([.007 .4 .45 .8])
    
    %discrim location prop corr
    figure(f2)
    subplot(221)
    axis([.007 .4 .4 .9])
    subplot(222)
    axis([.007 .4 .4 .9])
    subplot(224)
    axis([.007 .4 .4 .9])
    subplot(223)
    axis([.007 .4 .4 .9])
    
    %overall rxn times
    figure(f3);
    subplot(121)
    axis([.007 .4 .37 .47])
    subplot(122)
    axis([.007 .4 .37 .47])

    %discrim location rxn times
    figure(f4);
    subplot(221)
    axis([.007 .4 .35 .52])
    subplot(222)
    axis([.007 .4 .35 .52])
    subplot(224)
    axis([.007 .4 .35 .52])
    subplot(223)
    axis([.007 .4 .35 .52])
    
     figure(f5)

     figure(f6)
     axis([.008 .3 -.02 .06])
     
     figure(f7)
     axis([.008 .3 .5 .8]) 
     
     figure(f8)
     axis([0 .85 0 10])
     
     figure(f9)
     axis([.008 .3 -16 6])
     
elseif bird == 81
    %overall prop corr
    figure(f1)
    axis([.007 .6 .48 .82])
    
    %discrim location prop corr
    figure(f2)
    subplot(221)
    axis([.007 .6 .42 .95])
    subplot(222)
    axis([.007 .6 .42 .95])
    subplot(224)
    axis([.007 .6 .42 .95])
    subplot(223)
    axis([.007 .6 .42 .95])
    
    %overall rxn times
    figure(f3);
    subplot(121)
    axis([.007 .6 .295 .39])
    subplot(121)
    axis([.007 .6 .295 .39])
    
    %discrim location rxn times
    figure(f4);
    subplot(221)
    axis([.007 .6 .25 .42])
    subplot(222)
    axis([.007 .6 .25 .42])
    subplot(224)
    axis([.007 .6 .25 .42])
    subplot(223)
    axis([.007 .6 .25 .42])
    
         figure(f5)

     figure(f6)
     axis([.008 .6 -.01 .05])
     
          figure(f7)
     axis([.008 .6 .5 .8]) 
     
     figure(f8)
     axis([0 .85 0 10])
     
     figure(f9)
     axis([.008 .6 -10 4])
     
%        %overall prop corr
%     figure(f1)
%     axis([.007 .15 .48 .82])
%     
%     %discrim location prop corr
%     figure(f2)
%     subplot(221)
%     axis([.007 .15 .42 .95])
%     subplot(222)
%     axis([.007 .15 .42 .95])
%     subplot(224)
%     axis([.007 .15 .42 .95])
%     subplot(223)
%     axis([.007 .15 .42 .95])
%     
%     %overall rxn times
%     figure(f3);
%     subplot(121)
%     axis([.007 .15 .295 .39])
%     subplot(121)
%     axis([.007 .15 .295 .39])
%     
%     %discrim location rxn times
%     figure(f4);
%     subplot(221)
%     axis([.007 .15 .25 .42])
%     subplot(222)
%     axis([.007 .15 .25 .42])
%     subplot(224)
%     axis([.007 .15 .25 .42])
%     subplot(223)
%     axis([.007 .15 .25 .42])
%     
%          figure(f5)
% 
%      figure(f6)
%      axis([.008 .15 -.01 .05])
%      
%           figure(f7)
%      axis([.008 .3 .5 .8]) 
%      
%      figure(f8)
%      axis([0 .85 0 10])
%      
%      figure(f9)
%     axis([.008 .15 -10 4])
end