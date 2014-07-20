function [edata mdata mdata2 Mov]=test_EOG_magnet_mov_binoc(duration)
%will test the eog along with taking a movie and acquiring eyelink
%eyetracking data

imaqreset;
scrsz = get(0,'ScreenSize');


rp2_file  = '../rpx/ro_rp21_two_channel.rcx';
[rp2_figure, rp2_handle] = initialize_rp2_rec (1, rp2_file,duration);
[rp2_figure2, rp2_handle2] = initialize_rp2_rec (2, rp2_file,duration);
[rp2_figure3, rp2_handle3] = initialize_rp2_rec (3, rp2_file,duration);
[zbus_figure,zbus_handle] = initialize_zbus;


num_frames = 30*duration/1000;
vid=videoinput('winvideo',1,'RGB24_720X480','FramesPerTrigger',num_frames);
tinfo = triggerinfo(vid);
triggerconfig(vid,tinfo(2));
clear tinfo;
set(vid,'ReturnedColorSpace','grayscale');
vframe=figure('Position',[scrsz(3)/2 0 scrsz(3)/2 scrsz(4)/2]);
start(vid)


t1=tic;
trigger(vid)%trigger video
invoke(zbus_handle, 'ZBUSTrigA', 0, 0, 10);%trigger recordings

while toc(t1)<(duration/1000)
    if mod(toc(t1),5)<.0002
        display([num2str(toc(t1)) ' seconds'])
    end
end
efig=figure('Position',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
mfig=figure('Position',[0 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
mfig2=figure('Position',[0 0 scrsz(3)/2 scrsz(4)/2]);title('mfig2')
figure(efig)

edata= rec_eog_data(rp2_handle);
mdata= rec_eog_data(rp2_handle2);
mdata2=rec_eog_data(rp2_handle3);
subplot(2,1,1)
if(~isempty(edata))
    plot(edata(1,:),edata(2,:))
    subplot(2,1,2)
    plot(edata(1,:),edata(3,:))
    title('efig')
end
figure(mfig)
if(~isempty(mdata))
    subplot(2,1,1)
    plot(mdata(1,:),mdata(2,:))
    subplot(2,1,2)
    plot(mdata(1,:),mdata(3,:))
    title('mfig')
end
figure(mfig2)
if(~isempty(mdata2))
    subplot(2,1,1)
    plot(mdata2(1,:),mdata2(2,:))
    subplot(2,1,2)
    plot(mdata2(1,:),mdata2(3,:))
        title('mdata2')
end


Mov=getdata(vid);
flushdata(vid);
imaqreset;
figure(vframe)
imagesc(Mov(:,:,:,1));

pause

close(vframe)
close(efig)
close(mfig)
close(mfig2)

