function rdataF=display_bar_rasters(rdata,dimension,direction)
%analyses output from the head fixed find_RF_full_bars program.

rdataF=batchhighpassFilter(rdata,300,24400);

Events=batch_threshSpikes(rdataF,3,24400);

dirv=direction(dimension==1);
dirh=direction(dimension==0);

Ev=Events(dimension==1);
Eh=Events(dimension==0);

Evd=Ev(dirv==1);
Evu=Ev(dirv==0);

Ehr=Eh(dirh==1);
Ehl=Eh(dirh==0);

subplot(221)
title('Vertical top-to-bottom')
displayEvents(Evd)
subplot(223)
title('Verticle bottom-to-top')
displayEvents(Evu)
subplot(222)
title('Horizontal left-to-right')
displayEvents(Ehr)
subplot(224)
title('Horizontal right-to-left')
displayEvents(Ehl)
