function formatFig()
%formats a figure according to my standard criteria.

h=gcf;
g=gca;

box off;

set(g,'LineWidth',2,'FontSize',16);

set(h,'Color','white')

% set(gca,'XTickLabel',[{''} {'1'} {'2'} {'3'} {'4'}])


end