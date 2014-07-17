% combine_eye_calibration_workspaces
%this script will combine two eye calibration workspaces

clear leftEye i

first = uigetfile(pwd,'Select first workspace');
load(first)
mdataA=mdata;
mdata2A=mdata2;
get_eyelink
leftEyeA=leftEye;
clear leftEye;

second = uigetfile(pwd,'Select second workspace');
load(second)
mdataB=mdata;
mdata2B=mdata2;
get_eyelink
leftEyeB=leftEye;

td=median(diff(mdataB(1,:)));
n=length(mdataB(1,:));
t = mdataA(1,end)+td:td:mdataA(1,end)+td.*n;
mdataB(1,:) = t;
mdata2B(1,:) = t;

mdata = [mdataA mdataB];
mdata2 = [mdata2A mdata2B];

td=median(diff(leftEyeB(1,:)));

leftEyeB(1,:)=leftEyeB(1,:)+td+leftEyeA(1,end);
leftEye = [leftEyeA leftEyeB];

save(['Combined_' first '_' second],'mdata','mdata2','leftEye');

clear first mdataA mdata2A leftEyeA second mdataB mdata2B leftEyeB td n t