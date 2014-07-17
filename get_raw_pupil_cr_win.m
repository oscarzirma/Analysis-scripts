function [t rpx rpy crx cry winx winy] = get_raw_pupil_cr_win(Video_eye_position)
%accepts a cell array of eyelink raw sample and returns the raw pixel x and
%y as well as a time matrix

n=length(Video_eye_position);


for i=1:n
    V=cell2mat(Video_eye_position(i));
    
    for j=1:length(V)
        v=V(j);
        rp(j,:)=v.raw_pupil;
        tv(j)=v.time;
        cr(j,:)=v.raw_cr;
        win(j,:)=v.window_position;
    end
    
    x=rp(:,1);
    y=rp(:,2);
    
    
    x(x==-32768)=nan;
    y(y==-32768)=nan;
       
    t(i,1:length(tv))=tv;
    rpx(i,1:length(x))=x;
    rpy(i,1:length(y))=y;
    
        x=cr(:,1);
    y=cr(:,2);
    x(x==-32768)=nan;
    y(y==-32768)=nan;
    crx(i,1:length(x))=x;
    cry(i,1:length(y))=y;
    
    winx(i,1:length(win))=win(:,1);
    winy(i,1:length(win))=win(:,2);
end