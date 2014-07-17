function chicken_behavior_gui()
% Chicken behavior user interface
% Sridhar Devarajan, Aug 2012

fh = figure;
set(gcf, 'Position', [40 70 960 600], 'Color', [0.75 0.75 0.78]);
set(gcf, 'NumberTitle', 'off')
set(gcf, 'Name', 'Chicken Behavior GUI -- Knudsen Laboratory')
set(gcf, 'MenuBar', 'None')
set(gcf, 'ToolBar', 'None')

% eths = uicontrol(fh,'Style','text', 'FontSize',14,  ...
%                 'String','Chicken behavior GUI', ...
%                 'Position',[30, 560, 300, 30], ...
%                 'Backgroundcolor',[0.8 0.9 0.9]);

eths = uicontrol(fh,'Style','text', 'FontSize', 8, 'FontName', 'Courier New',...
                'String','Contact: Sridhar Devarajan', ... 
                'Position',[550, 2, 200, 15], ...
                'Backgroundcolor',[0.75 0.75 0.78]);
eths2 = uicontrol(fh,'Style','text', 'FontSize', 8, 'FontName', 'Courier New', 'Fontweight', 'bold',...
                'String','(dsridhar@stanford.edu)', ... 
                'Position',[750, 2, 170, 15], ...
                'Backgroundcolor',[0.75 0.75 0.78]);
% % eths = uicontrol(fh,'Style','text', 'FontSize',9,  ...
% %                 'String','Knudsen Lab, Stanford University', ... 
% %                 'Position',[20, 5, 400, 15], ...
% %                 'Backgroundcolor',[0.75 0.75 0.78]);
            
bw = 150; bh = 15;
tw = 100; th = 15;
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hp = uipanel('Title','Session: File','FontSize',11,'FontName','Trebuchet MS','Fontweight','bold', ...
             'BackgroundColor',[0.8 0.9 0.9],...
             'Position',[.05 .73 .42 .25]);
         
tx = 30; bx = 150;
ty = 90; by = 90;
yd = -35;

eths = uicontrol(hp,'Style','text','FontSize',9,...
                'String','Chicken #',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
eth = uicontrol(hp,'Style','edit',...
                'String','0',...
                'Position',[bx by bw bh], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

ty = ty + yd;
by = by + yd;

e2ths = uicontrol(hp,'Style','text','FontSize',9,...
                'String','Session #',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
e2th = uicontrol(hp,'Style','edit',...
                'String','0',...
                'Position',[bx by bw bh], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

ty = ty + yd-5;
by = by + yd-5;

e3ths = uicontrol(hp,'Style','text','FontSize',9,...
                'String','Session type',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

e3th = uicontrol(hp,'Style','popupmenu',...
                'String',{'Training','Top-down cueing','Bottom-up cueing','Inactivation'},...
                'Value',1,'Position',[bx by bw bh], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

ty = ty + yd;
by = by + yd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hp2 = uipanel('Title','Target & Cross','FontSize',11,'FontName','Trebuchet MS','Fontweight','bold', ...
             'BackgroundColor',[0.8 0.9 0.9],...
             'Position',[.05 .175 .42 .525]);

tx = 30; bx = 150;
ty = 255; by = 255;
yd = -42;

shst = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','Target duration (ms)',...
                'Position',[tx ty, tw, th], ...
            'Foregroundcolor',[1 0 0], ...    
            'Backgroundcolor',[0.8 0.9 0.9]);

shet = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','10',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

sht = uicontrol(hp2,'Style','slider',...
                'Max',1000,'Min',0,'Value',10,...
                'SliderStep',[0.01 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, shet, 10}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);

ty = ty + yd;
by = by + yd;

shsc = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','Target radius(px)',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

shec = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','8',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shc = uicontrol(hp2,'Style','slider',...
                'Max',20,'Min',1,'Value',8,...
                'SliderStep',[0.05 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, shec,1}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);

            
 
ty = ty + yd;
by = by + yd;


shsxd = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','Target X',...
                'Position',[tx ty, tw, th], ...
                     'Foregroundcolor',[1 0 0], ...  
                'Backgroundcolor',[0.8 0.9 0.9]);

shexd = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','200',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shxd = uicontrol(hp2,'Style','slider',...
                'Max',500,'Min',0,'Value',200,...
                'SliderStep',[0.01 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, shexd,5}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);


ty = ty + yd/2; by = by + yd/2;
          
shsyd = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','Target Y',...
                'Position',[tx ty, tw, th], ...
                     'Foregroundcolor',[1 0 0], ...  
                'Backgroundcolor',[0.8 0.9 0.9]);
            
sheyd = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','100',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shyd = uicontrol(hp2,'Style','slider',...
                'Max',370,'Min',0,'Value',100,...
                'SliderStep',[0.01 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, sheyd,5}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
ty = ty + yd;
by = by + yd;

shsxf = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','Cross X-offset',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

shexf = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','0',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shxf = uicontrol(hp2,'Style','slider',...
                'Max',500,'Min',-500,'Value',0,...
                'SliderStep',[0.01 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, shexf,5}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);


ty = ty + yd/2; by = by + yd/2;
          
shsyf = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','Cross Y-offset',...
                'Position',[tx ty, tw, th], ...
                     'Foregroundcolor',[1 0 0], ...  
                'Backgroundcolor',[0.8 0.9 0.9]);
            
sheyf = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','80',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shyf = uicontrol(hp2,'Style','slider',...
                'Max',370,'Min',-370,'Value',80,...
                'SliderStep',[0.01 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, sheyf,5}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
ty = ty + yd;
by = by + yd;

shsrf = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','Cross radius (px)',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

sherf = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','15',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shrf = uicontrol(hp2,'Style','slider',...
                'Max',30,'Min',0,'Value',15,...
                'SliderStep',[0.01 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, sherf,1}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);


ty = ty + yd/2; by = by + yd/2;
          
shspf = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','Cross response radius (px)',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
shepf = uicontrol(hp2,'Style','text','FontSize',9,...
                'String','45',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shpf = uicontrol(hp2,'Style','slider',...
                'Max',200,'Min',0,'Value',45,...
                'SliderStep',[0.01 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, shepf,5}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
ty = ty + yd;
by = by + yd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hp3 = uipanel('Title','Trial','FontSize',11,'FontName','Trebuchet MS','Fontweight','bold', ...
             'BackgroundColor',[0.8 0.9 0.9],...
             'Position',[.5 .525 .42 .45]);
         
tx = 30; bx = 150;
ty = 220; by = 220;
yd = -35;

shsD = uicontrol(hp3,'Style','text','FontSize',9,...
                'String','Default luminance',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

sheD = uicontrol(hp3,'Style','text','FontSize',9,...
                'String','9',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shD = uicontrol(hp3,'Style','slider',...
                'Max',9,'Min',0,'Value',9,...
                'SliderStep',[1/9 1/9],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, sheD, 1}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
ty = ty + yd;
by = by + yd;

cbh = uicontrol(hp3,'Style','checkbox',...
                'String','Fixed luminance',...
                'Value', 1,'Position',[bx by bw bh], ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
ty = ty + yd;
by = by + yd;

shsM = uicontrol(hp3,'Style','text','FontSize',9,...
                'String','Max luminance',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

sheM = uicontrol(hp3,'Style','text','FontSize',9,...
                'String','9',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shM = uicontrol(hp3,'Style','slider',...
                'Max',9,'Min',0,'Value',9,...
                'SliderStep',[1/9 1/9],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, sheM, 1}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
ty = ty + yd;
by = by + yd;

shsm = uicontrol(hp3,'Style','text','FontSize',9,...
                'String','Min luminance',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

shem = uicontrol(hp3,'Style','text','FontSize',9,...
                'String','1',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shm = uicontrol(hp3,'Style','slider',...
                'Max',9,'Min',0,'Value',1,...
                'SliderStep',[1/9 1/9],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, shem, 1}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);

ty = ty + yd;
by = by + yd;

cbhL = uicontrol(hp3,'Style','checkbox',...
                'String','L-targets',...
                'Value', 1,'Position',[bx/2+20 by bw/2 bh], ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
cbhR = uicontrol(hp3,'Style','checkbox',...
                'String','R-targets',...
                'Value', 1,'Position',[bx/2+bw/2+60 by bw/2 bh], ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
ty = ty + yd;
by = by + yd;

shsL = uicontrol(hp3,'Style','text','FontSize',9,...
                'String','100% Lower',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

shUD = uicontrol(hp3,'Style','slider',...
                'Max',100,'Min',0,'Value',50,...
                'SliderStep',[0.5 0.5],...
                'Position',[bx-15 by 0.8*bw bh], ...
                'Callback', {@sh_callback, -1, 50}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
shsU = uicontrol(hp3,'Style','text','FontSize',9,...
                'String','100% Upper',...
                'Position',[bx+0.8*bw-5 ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

ty = ty + yd;
by = by + yd;

shsT = uicontrol(hp3,'Style','text','FontSize',9,...
                'String','Trial duration (ms)',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

sheT = uicontrol(hp3,'Style','text','FontSize',9,...
                'String','2500',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shT = uicontrol(hp3,'Style','slider',...
                'Max',5000,'Min',0,'Value',2500,...
                'SliderStep',[0.01 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, sheT, 50}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
hp4 = uipanel('Title','Response','FontSize',11,'FontName','Trebuchet MS','Fontweight','bold', ...
             'BackgroundColor',[0.8 0.9 0.9],...
             'Position',[.5 .175 .42 .325]);
  
tx = 30;  bx = 150;
ty = 145; by = 145;
yd = -50;

shsr = uicontrol(hp4,'Style','text','FontSize',9,...
                'String','Response radius (px)',...
                'Position',[tx ty, tw, th], ...
                     'Foregroundcolor',[1 0 0], ...  
                'Backgroundcolor',[0.8 0.9 0.9]);

sher = uicontrol(hp4,'Style','text','FontSize',9,...
                'String','60',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shr = uicontrol(hp4,'Style','slider',...
                'Max',100,'Min',20,'Value',60,...
                'SliderStep',[0.05 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, sher,5}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);
 
ty = ty + yd;
by = by + yd;

shsxr = uicontrol(hp4,'Style','text','FontSize',9,...
                'String','Response box X',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

shexr = uicontrol(hp4,'Style','text','FontSize',9,...
                'String','150',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shxr = uicontrol(hp4,'Style','slider',...
                'Max',500,'Min',-500,'Value',150,...
                'SliderStep',[0.01 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, shexr,5}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);


ty = ty + yd/2; by = by + yd/2;
          
shsyr = uicontrol(hp4,'Style','text','FontSize',9,...
                'String','Response box Y',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
sheyr = uicontrol(hp4,'Style','text','FontSize',9,...
                'String','70',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shyr = uicontrol(hp4,'Style','slider',...
                'Max',370,'Min',-370,'Value',70,...
                'SliderStep',[0.01 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, sheyr,5}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);

ty = ty + yd;
by = by + yd;
shsN = uicontrol(hp4,'Style','text','FontSize',9,...
                'String','NoGo P(reward)',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

sheN = uicontrol(hp4,'Style','text','FontSize',9,...
                'String','33',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shN = uicontrol(hp4,'Style','slider',...
                'Max',3,'Min',0,'Value',1,...
                'SliderStep',[0.33 0.33],...
                'Position',[bx by bw bh], ...
                'Callback', {@shN_callback, sheN,1}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);
 
ty = ty + yd;
by = by + yd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hp5 = uipanel('Title','Cue','FontSize',11,'FontName','Trebuchet MS','Fontweight','bold', ...
             'BackgroundColor',[0.8 0.9 0.9],...
             'Position',[.05 .01 .43 .15]);
  
tx = 10;  bx = 130;
ty = 35;  by = 15;

cbhC = uicontrol(hp5,'Style','checkbox',...
                'String','Show cue',...
                'Value', 1,'Position',[tx ty bw bh], ...
                'Backgroundcolor',[0.8 0.9 0.9]);
        
tx = tx + 60;
bx = bx + 60;
ty = 50;  by = 50;

shscp = uicontrol(hp5,'Style','text','FontSize',9,...
                'String','# Cue pecks',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

shecp = uicontrol(hp5,'Style','text','FontSize',9,...
                'String','6',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shcp = uicontrol(hp5,'Style','slider',...
                'Max',20,'Min',0,'Value',6,...
                'SliderStep',[0.05 0.05],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, shecp,1}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);

ty = ty - 35;
by = by- 35;

shsdp = uicontrol(hp5,'Style','text','FontSize',9,...
                'String','# Delay pecks',...
                'Position',[tx ty, tw, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);

shedp = uicontrol(hp5,'Style','text','FontSize',9,...
                'String','1',...
                'Position',[bx+bw+10 by, tw-50, th], ...
                'Backgroundcolor',[0.8 0.9 0.9]);             

shdp = uicontrol(hp5,'Style','slider',...
                'Max',5,'Min',0,'Value',1,...
                'SliderStep',[0.2 0.2],...
                'Position',[bx by bw bh], ...
                'Callback', {@sh_callback, shedp,1}, ...
                'Backgroundcolor',[0.8 0.9 0.9]);
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

uicell = {e3th, eth, e2th, shD, shM, shm, ...
    shN, sht, shc, shT, shrf, shUD, shr, shpf, ... 
    shcp, shdp, shxd, shyd, shxr, shyr, shxf, shyf, ...
    cbh, cbhL, cbhR, cbhC};

pbx = 600; pby = 60;
pbw = 80; pbh = 30;

pbhs = uicontrol(fh,'Style','pushbutton','String','Start test',...
                'Backgroundcolor',[1 1 1], 'Position',[pbx pby pbw pbh], ...
                'Callback', {@start_sim, uicell});

pbx = pbx+100; 
pbhc = uicontrol(fh,'Style','pushbutton','String','Stop test',...
                'Backgroundcolor',[1 1 1], 'Position',[pbx pby pbw pbh]);

            
pbx = 600; pby = pby-30; pbh = 22; 
pbhSv = uicontrol(fh,'Style','pushbutton','String','Save config...',...
                'Backgroundcolor',[0.8 0.9 0.9], 'Position',[pbx pby pbw pbh]);

pbx = 700;
pbhLd = uicontrol(fh,'Style','pushbutton','String','Load config...',...
                'Backgroundcolor',[0.8 0.9 0.9], 'Position',[pbx pby pbw pbh]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            

% %             start test
% %             interface w/script
% %             runtime error => file overwrite
% %             
% %         TODO
% %             alignment of UI components
% %             save config
% %             load config
% %              -- save config by default, and load last config
% %             abort test
% %             pause test
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Callbacks
function sh_callback(hobj,evtdata,eh,step)
if ~exist('step', 'var')
    step = 1;
end
slval = round((get(hobj,'Value'))/step)*step;
sliderValue = num2str( slval );
if eh ~= -1
    set(eh,'String', sliderValue)
end
set(hobj,'Value', slval)

function shN_callback(hobj,evtdata,eh,step)
if ~exist('step', 'var')
    step = 1;
end
slval = round((get(hobj,'Value'))/step)*step;
sliderValue = num2str( round(100*slval/3) );
if eh ~= -1
    set(eh,'String', sliderValue)
end
set(hobj,'Value', slval)

function start_sim(hobj, evtdata, uicell)
[e3th, eth, e2th, shD, shM, shm, ...
    shN, sht, shc, shT, shrf, shUD, shr, shpf, ... 
    shcp, shdp, shxd, shyd, shxr, shyr, shxf, shyf, ...
    cbh, cbhL, cbhR, cbhC] = ...
    deal(uicell{:});

cbgui = struct;
switch get(e3th, 'Value')
    case 1
        ftype='tt';
    case 2
        ftype='tdc';
    case 3
        ftype='buc';
    case 4
        ftype='inx';
    otherwise
        ftype='unk';
end
        
cbgui.ftype = ftype;

cbgui.cnum = num2str(get(eth, 'String'));
cbgui.block_num = num2str(get(e2th, 'String'));

cbgui.default_cont_val = toBinLum(get(shD, 'Value'));
cbgui.lb_thresh = toBinLum(get(shm, 'Value'));
cbgui.ub_thresh = toBinLum(get(shM, 'Value'));

cbgui.targ_duration = get(sht, 'Value');
cbgui.trial_duration = get(shT, 'Value');

cbgui.circ_rad_targ = get(shc, 'Value');
cbgui.fix_cross_rad = get(shrf, 'Value'); 
cbgui.prob_toptarg = get(shUD, 'Value')/100;  

cbgui.permitted_radius_targ = get(shr, 'Value'); 
cbgui.permitted_radius_fix = get(shpf, 'Value');

cbgui.max_pecks_cue     = get(shcp, 'Value');
cbgui.delay_pecks         = get(shdp, 'Value');
cbgui.prob_reward_nogoresp_gotrial = get(shN, 'Value'); 

cbgui.xdisp  = 2*get(shxd, 'Value'); 
cbgui.ydisp  = get(shyd, 'Value');  

cbgui.xdispResp = 2*get(shxr, 'Value');
cbgui.ydispResp = get(shyr, 'Value');

cbgui.fixXOffset = get(shxf, 'Value');
cbgui.fixYOffset = get(shyf, 'Value');

cbgui.fixedLumFlag = get(cbh, 'Value');
cbgui.tdCueOn  = get(cbhC, 'Value');

Rt = get(cbhR, 'Value');
Lt = get(cbhL, 'Value');

cbgui.targRLflag  = Rt & Lt; %targets on both left and right?

if ~cbgui.targRLflag
    if Rt, 
        cbgui.targfixedRL = 1;
    elseif Lt,
        cbgui.targfixedRL = 2;
    elseif ~Rt && ~Lt
        error('targets must be enabled on at least one side');
    end
end

if strcmp(ftype, 'tt')
    run_behavior_training_guicb;
elseif strcmp(ftype, 'tdc')
    run_behavior_topdown_cueing_guicb;
end

function cv = toBinLum(lum_val)
cv = 1/(2^(9-lum_val));