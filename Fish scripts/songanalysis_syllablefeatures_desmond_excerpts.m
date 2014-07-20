
function [x,analyzed_wav_files,onset_cells,offset_cells]=songanalysis_syllablefeatures_desmond_excerpts(analyzed_numbers,analyzed_wav_files,onset_cells,offset_cells)

% import a directory of song files

%%% would like to do a thing here where i caclulate the max size
%%% spectrogram that can be computed with available memory and either say
%%% the max length of file or chunk file into appropriate segments

% make a spectrogram

% make the spectrogram real and threshold the spectrogram to eliminate
% noise (user generated?)

% segment the song into syllables and subsyllables

% segment the spectrogram into subimages

%%% scale the images to uniform length IF SPECIFIED

%%% check dif frequencies IF SPECIFIED???

%%% store first syllable image as syllable class 1

%%% for all comparisons - multiply images (binarized?) and divide by bigger
%%% selfsim

%%% compare next image to first --> if same, index of syll class 1 goes up,
%%% if different, create new syll class

%%% create vector where length is number of syllables and enter a 1 when
%%% the syllable is new

%%% plot frequency of new syllables per 20(??) syllables analyzed

%%% give total number of syllables (repertoire size)

%%% display unique syllables with number of instances/frequency




%import a directory of wav files
directoryname = uigetdir('C:\Documents and Settings\nicole\My Documents\MATLAB','Choose a directory that contains the directory testseg'); 

directoryname 
subdir='./chippingsparrowgoodfilesfourthtest/'
files = dir([subdir '*.wav']);

F=length(files)+1

%%%%define overarching variables here

%species_ID=[1,1,1,1,1,2,2,2,2,3,3,3,3,3];%either input this or write a script to look at file names

analyzed_numbers(find(analyzed_numbers==0))=[];
analyzed_numbers=[1 analyzed_numbers];
analyzed_wav_files=analyzed_wav_files(analyzed_numbers);
onset_cells=onset_cells(analyzed_numbers);
offset_cells=offset_cells(analyzed_numbers);
char(analyzed_wav_files)
syll_length=zeros(F,300);

mean_syll_durations=zeros(F,1);
mean_silence_durations=zeros(F,1);
num_unique_sylls=zeros(F,1);
avg_syll_length=zeros(F,1);
longest_syll=zeros(F,1);
shortest_syll=zeros(F,1);
duration_of_bout=zeros(F,1);
numsylls_dividedby_boutduration=zeros(F,1);
numsylls_dividedby_numuniques=zeros(F,1);
sequential_repetition=zeros(F,2);

freq_range_upper=zeros(F,300);
freq_range_lower=zeros(F,300);
syll_shape_class=zeros(F,300);
syll_entropy=zeros(F,300);
avg_entropy=zeros(F,1);
avg_low_freq=zeros(F,1);
avg_up_freq=zeros(F,1);
syll_shape_dist=zeros(F,15);

pattern_matrix_sonogram50=zeros(F,500);
pattern_matrix_sonogram50_back=zeros(F,500);
stereotypy_sylls=zeros(F,499);
durations_matrix=zeros(F,500);
num_syllables=zeros(F,1);
stereotypy=zeros(F,2);
note_length=zeros(F,500);
avg_note_length=zeros(F,1);
longest_note=zeros(F,1);
shortest_note=zeros(F,1);
number_of_notes=zeros(F,1);
notes_per_syll=zeros(F,1);
freq_range_upper=zeros(F,500);
freq_range_lower=zeros(F,500);
mean_freq_modulation=zeros(F,1);
max_freq=zeros(F,1);
min_freq=zeros(F,1);
avg_low_freq=zeros(F,1);
avg_up_freq=zeros(F,1);
freq_range=zeros(F,1);
flat_sylls=zeros(F,1);
upsweeps=zeros(F,1);
downsweeps=zeros(F,1);
parabolas=zeros(F,1);
temp_all_vars=zeros(F,27);
scrsz = get(0,'ScreenSize');

analyzed_wav_files{1}='test.wav';
onset_cells{1}=1;
offset_cells{1}=1;

for i=1:F-1
i

%%%%%clear any iterating variables here
clear sonogram*
      
    wavfile=([files(i).name]);
    song1=wavread([subdir files(i).name]);


wavfile
wavlist{i}=wavfile;

test_if_analyzed=strmatch(wavlist{i}, analyzed_wav_files, 'exact')
if isempty(test_if_analyzed)==1
    analyzed_wav_files=[analyzed_wav_files wavlist{i}];
end
char(analyzed_wav_files);
file_number=strmatch(wavlist{i}, analyzed_wav_files, 'exact')


%might need to make files mono
song1 = song1(:,1);


%make spectrogram binary, divide by max value to get 0-1 range


%compute spectrogram with gaussian window
sonogram=ifdvsonogramonly(song1,44100,1024,1010,2,1,3,5,5);    
% figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
% imagesc(log(sonogram+3))
% pause
%for desmond's analysis there is a padding on both sides
[rows,cols]=size(sonogram);
sonogrampadded=zeros(rows,cols+300);
sonogrampadded(:,151:cols+150)=sonogram;
sonogram=sonogrampadded;

[rows,cols]=size(sonogram);
numelements=rows*cols;
sonogrambinary=sonogram./max(max(sonogram)); 

%scale sonogram so that top 1% is maximized and bottom 40% is 0
sonogramvector=reshape(sonogrambinary,numelements,1);
sonogramvectorsorted=sort(sonogramvector);
fortypercent=sonogramvectorsorted(round(numelements/2.5));
s40=ge(sonogrambinary,fortypercent);
sonogram40=s40.*sonogrambinary;

ninetyninepercent=sonogramvectorsorted(numelements-round(numelements/100));
sonogramthresh=zeros(rows,cols);
%look mom, i vectorized
sonogramthresh(sonogrambinary<ninetyninepercent)=0;
sonogramthresh(sonogrambinary>ninetyninepercent)=1;


% figure 
% imagesc(sonogramthresh)
% 
% figure('Position',[1 1 scrsz(3) (scrsz(4)/2-50)])
% % se = strel('line', 3, 90);
% % sonogrameroded = imerode(sonogramthresh, se);
% sonogrameroded = bwulterode(sonogramthresh);

% sonogrameroded = bwmorph(sonogramthresh, 'erode', 1); 
% sonogramdilated = bwmorph(sonogrameroded, 'dilate', 3);

% sonogrameroded2 = bwmorph(sonogramthresh, 'erode', 2); 
% % sonogramdilated2 = bwmorph(sonogrameroded2, 'dilate', 1);
% [L2,NUM2]=bwlabel(sonogrameroded2,4);

% colormap(jet)
% NUM
% pause 
% figure('Position',[1 1 scrsz(3) (scrsz(4)/2-50)])
% imagesc(L2)
% colormap(jet)
% NUM2

%sonogram summed
% sonogram_multiplied=sonogramthresh.*sonogramthresh;
sumsonogram=sum(sonogramthresh(:,:));
sumsonogram_scaled=(sumsonogram./max(sumsonogram).*rows);



if isempty(test_if_analyzed)==1


%create a vector that equals 1 when amplitude exceeds threshold and 0 when it is below
high_amp=sumsonogram_scaled>4;
high_amp(1)=0;
high_amp(length(high_amp))=0;
onsets=find(diff(high_amp)==(1));
offsets=find(diff(high_amp)==(-1));
offsets2=zeros(1,length(offsets)+1);
for j=1:length(offsets)
    offsets2(j+1)=offsets(j);
end
offsets2(1)=1;
onsets(length(onsets)+1)=length(sumsonogram_scaled);

%define silence durations
silence_durations = zeros(1,(length(onsets)-1));
for j=1:(length(onsets)-1)
silence_durations(1,j)=onsets(j)-offsets2(j);
end
mean_silence_durations(file_number)=mean(silence_durations);
%define syllable onsets and offsets
syll_onsets = zeros(1,length(onsets));
syll_offsets = zeros(1,length(onsets));
for j=1:(length(silence_durations))
    if silence_durations(1,j)>25     %sets minimum silence
        syll_onsets(j)=onsets(j);
        syll_offsets(j)=offsets2(j);
    end
end
syll_offsets(1)=0;
syll_offsets(length(silence_durations)+1)=offsets2(length(offsets2));

%remove zeros
syll_onsets = syll_onsets(syll_onsets ~=0);
syll_offsets = syll_offsets(syll_offsets ~=0);
if syll_offsets(1)<syll_onsets(1)
    syll_offsets(1)=[];
end
for j=1:length(syll_offsets-1)
    if syll_offsets(j)-syll_onsets(j)<25 %sets minimum syll size
        syll_offsets(j)=0;
        syll_onsets(j)=0;
    end
end
syll_onsets = syll_onsets(syll_onsets ~=0);
syll_offsets = syll_offsets(syll_offsets ~=0);
syllable_durations=syll_offsets-syll_onsets;
for j=1:length(syllable_durations)
    durations_matrix(file_number,j)=syllable_durations(j);
end
mean_syll_durations(file_number)=mean(syllable_durations);
longest_syll(file_number)=max(syllable_durations);
shortest_syll(file_number)=min(syllable_durations);
duration_of_bout(file_number)=syll_offsets(length(syll_offsets))-syll_onsets(1);
num_syllables(file_number)=length(syll_onsets);
numsylls_dividedby_boutduration(file_number)=num_syllables(file_number)/duration_of_bout(file_number);
% syll_onsets
% syll_offsets

syllable_marks=zeros(1,length(sumsonogram_scaled));
syllable_marks(syll_onsets)=(rows+30);
syllable_marks(syll_offsets)=(rows+10);
% 
% 
% % draw spectrogram with sumsonogram overlaid
figure('Position',[1 50 scrsz(3) (scrsz(4)/2-75)])
%figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
hold on
imagesc(log(sonogramthresh+3))
plot(syllable_marks,'m-')
hold off

disp('Click with left mouse button IF segmentation errors exist, then press return.')
[X0,Y0notneeded] = ginput;

    if isempty(X0)==0


        disp('Use left mouse button to select syllable ONSETS that should be ADDED, then press return.')
        [X1,Y1notneeded] = ginput;

        X1
        syll_onsets_user=sort([syll_onsets round(X1')])

        disp('Use left mouse button to select syllable OFFSETS that should be ADDED, then press return.')
        [X2,Y2notneeded] = ginput;

        X2
        syll_offsets_user=sort([syll_offsets round(X2')])

        %add x1 to onset vector, add x2 to offset vector

        syllable_marks=zeros(1,length(sumsonogram_scaled));
        syllable_marks(syll_onsets_user)=(rows+30);
        syllable_marks(syll_offsets_user)=(rows+10);
        % % 
        % % 
        % % % draw spectrogram with sumsonogram overlaid
        close
        figure('Position',[1 50 scrsz(3) (scrsz(4)/2-75)])
        %figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
        hold on
        imagesc(log(sonogramthresh+3))
        plot(syllable_marks,'m-')
        hold off

        %%%find values closest to these and delete them
        disp('Use left mouse button to select syllable ONSETS that should be DELETED, then press return.')
        [X3,Y3notneeded] = ginput;

        X3

        for L=1:length(X3)
            [val,delete_val]=min(abs(syll_onsets_user-X3(L)));
            syll_onsets_user=syll_onsets_user(syll_onsets_user~=syll_onsets_user(delete_val));
        end

        disp('Use left mouse button to select syllable OFFSETS that should be DELETED, then press return.')
        [X4,Y4notneeded] = ginput;

        X4

        for L=1:length(X4)
            [val2,delete_val2]=min(abs(syll_offsets_user-X4(L)));
            syll_offsets_user=syll_offsets_user(syll_offsets_user~=syll_offsets_user(delete_val2));
        end

        if length(syll_onsets_user)~=length(syll_offsets_user)
            syllable_marks=zeros(1,length(sumsonogram_scaled));
            syllable_marks(syll_onsets_user)=(rows+30);
            syllable_marks(syll_offsets_user)=(rows+10);
            close
            figure('Position',[1 50 scrsz(3) (scrsz(4)/2-75)])
            %figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
            hold on
            imagesc(log(sonogramthresh+3))
            plot(syllable_marks,'m-')
            hold off
            disp('Number of onsets does not match number of offsets. Please try again.')
            disp('Use left mouse button to select syllable ONSETS that should be ADDED, then press return.')
            [X1,Y1notneeded] = ginput;
            syll_onsets_user=sort([syll_onsets_user round(X1')])
            disp('Use left mouse button to select syllable OFFSETS that should be ADDED, then press return.')
            [X2,Y2notneeded] = ginput;
            syll_offsets_user=sort([syll_offsets_user round(X2')])
            %add x1 to onset vector, add x2 to offset vector
            syllable_marks=zeros(1,length(sumsonogram_scaled));
            syllable_marks(syll_onsets_user)=(rows+30);
            syllable_marks(syll_offsets_user)=(rows+10);
            % % 
            % % 
            % % % draw spectrogram with sumsonogram overlaid
            close
            figure('Position',[1 50 scrsz(3) (scrsz(4)/2-75)])
            %figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
            hold on
            imagesc(log(sonogramthresh+3))
            plot(syllable_marks,'m-')
            hold off
            %%%find values closest to these and delete them
            disp('Use left mouse button to select syllable ONSETS that should be DELETED, then press return.')
            [X3,Y3notneeded] = ginput;
            for L=1:length(X3)
                [val,delete_val]=min(abs(syll_onsets_user-X3(L)));
                syll_onsets_user=syll_onsets_user(syll_onsets_user~=syll_onsets_user(delete_val));
            end
            disp('Use left mouse button to select syllable OFFSETS that should be DELETED, then press return.')
            [X4,Y4notneeded] = ginput;
            for L=1:length(X4)
                [val2,delete_val2]=min(abs(syll_offsets_user-X4(L)));
                syll_offsets_user=syll_offsets_user(syll_offsets_user~=syll_offsets_user(delete_val2));
            end
        end

        if length(syll_onsets_user)~=length(syll_offsets_user)
            syllable_marks=zeros(1,length(sumsonogram_scaled));
            syllable_marks(syll_onsets_user)=(rows+30);
            syllable_marks(syll_offsets_user)=(rows+10);
            close
            figure('Position',[1 50 scrsz(3) (scrsz(4)/2-75)])
            %figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
            hold on
            imagesc(log(sonogramthresh+3))
            plot(syllable_marks,'m-')
            hold off
            disp('Number of onsets does not match number of offsets. Please try again.')
            disp('Use left mouse button to select syllable ONSETS that should be ADDED, then press return.')
            [X1,Y1notneeded] = ginput;
            syll_onsets_user=sort([syll_onsets_user round(X1')])
            disp('Use left mouse button to select syllable OFFSETS that should be ADDED, then press return.')
            [X2,Y2notneeded] = ginput;
            syll_offsets_user=sort([syll_offsets_user round(X2')])
            %add x1 to onset vector, add x2 to offset vector
            syllable_marks=zeros(1,length(sumsonogram_scaled));
            syllable_marks(syll_onsets_user)=(rows+30);
            syllable_marks(syll_offsets_user)=(rows+10);
            % % 
            % % 
            % % % draw spectrogram with sumsonogram overlaid
            close
            figure('Position',[1 50 scrsz(3) (scrsz(4)/2-75)])
            %figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
            hold on
            imagesc(log(sonogramthresh+3))
            plot(syllable_marks,'m-')
            hold off
            %%%find values closest to these and delete them
            disp('Use left mouse button to select syllable ONSETS that should be DELETED, then press return.')
            [X3,Y3notneeded] = ginput;
            for L=1:length(X3)
                [val,delete_val]=min(abs(syll_onsets_user-X3(L)));
                syll_onsets_user=syll_onsets_user(syll_onsets_user~=syll_onsets_user(delete_val));
            end
            disp('Use left mouse button to select syllable OFFSETS that should be DELETED, then press return.')
            [X4,Y4notneeded] = ginput;
            for L=1:length(X4)
                [val2,delete_val2]=min(abs(syll_offsets_user-X4(L)));
                syll_offsets_user=syll_offsets_user(syll_offsets_user~=syll_offsets_user(delete_val2));
            end
        end

        syllable_marks=zeros(1,length(sumsonogram_scaled));
        syllable_marks(syll_onsets_user)=(rows+30);
        syllable_marks(syll_offsets_user)=(rows+10);
        % % 
        % % 
        % % % draw spectrogram with sumsonogram overlaid
        close
        figure('Position',[1 50 scrsz(3) (scrsz(4)/2-75)])
        %figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
        hold on
        imagesc(log(sonogramthresh+3))
        plot(syllable_marks,'m-')
        hold off
        pause

        close
        close

        onset_cells{file_number}=syll_onsets_user
        offset_cells{file_number}=syll_offsets_user

    else
        syll_onsets_user=syll_onsets
        syll_offsets_user=syll_offsets
        onset_cells{file_number}=syll_onsets_user
        offset_cells{file_number}=syll_offsets_user
        close
        close
    end
    
else
   syll_onsets_user=onset_cells{file_number};
   syll_offsets_user=offset_cells{file_number};
   close
end


%%%%CAUTION - this is only for 5 syllable chipping sparrow excerpts%%%%%%
%for desmond's analysis, use the middle three syllables
syll_onsets_user=syll_onsets_user(2:4);
syll_offsets_user=syll_offsets_user(2:4);


%define silence durations
silence_durations = zeros(1,(length(syll_onsets_user)-1));
for j=1:(length(syll_onsets_user)-1)
silence_durations(1,j)=syll_offsets_user(j+1)-syll_onsets_user(j);
end
mean_silence_durations(file_number)=mean(silence_durations);


syllable_durations=syll_offsets_user-syll_onsets_user;
for j=1:length(syllable_durations)
    durations_matrix(file_number,j)=syllable_durations(j);
end
mean_syll_durations(file_number)=mean(syllable_durations);
longest_syll(file_number)=max(syllable_durations);
shortest_syll(file_number)=min(syllable_durations);
duration_of_bout(file_number)=syll_offsets_user(length(syll_offsets_user))-syll_onsets_user(1);
num_syllables(file_number)=length(syll_onsets_user);
numsylls_dividedby_boutduration(file_number)=num_syllables(file_number)/duration_of_bout(file_number);

%take sonogram (thresholded) and split it into syllables by sonogram and compare by
%multiplying values and summing and dividing by the max possible overlap 
%(bigger of the two diagonal overlaps?)

%do a gaussian blur of the thresholded sonogram
%h = fspecial('gaussian',10,10);
sonogramthresh_blurred=sonogramthresh;
%sonogramthresh_blurred=imfilter(sonogramthresh,h);


%define the pixel overlap of syllables to themselves
sonogram_self_similarity=zeros(1,length(syll_onsets_user));
for j=1:length(syll_onsets_user)
    sonogram_self_similarity(j)=sum(sum(sonogram40(:,syll_onsets_user(j):syll_offsets_user(j)).*sonogram40(:,syll_onsets_user(j):syll_offsets_user(j))));
end
% sonogram_self_similarity

%%FIND PATTERN
%find pixel overlap of each syllable to every other syllable
sonogram_similarity=zeros(length(syll_onsets_user),length(syll_onsets_user));
for j=1:length(syll_onsets_user)
    for k=1:length(syll_onsets_user)
        lengthsyll(1)=syll_offsets_user(j)-syll_onsets_user(j);
        lengthsyll(2)=syll_offsets_user(k)-syll_onsets_user(k);
        [minlength,whichsyllshorter]=min(lengthsyll);
        shiftfactor1=abs(lengthsyll(1)-lengthsyll(2));
        if lengthsyll(1)==lengthsyll(2)
            shiftfactor1=1;
        end
        selfsim(1)=sonogram_self_similarity(j);
        selfsim(2)=sonogram_self_similarity(k);
        maxoverlap=max(selfsim);
        if whichsyllshorter==1
             syllsim_align=zeros(1,shiftfactor1);
            for m=1:shiftfactor1
                syllsim_align(m)=((sum(sum(sonogramthresh_blurred(:,syll_onsets_user(j):syll_onsets_user(j)+minlength).*sonogramthresh_blurred(:,(syll_onsets_user(k)+(m-1):syll_onsets_user(k)+minlength+(m-1))))))/maxoverlap)*100;
            end
        %pad the bigger syllable by adding either the distance to the
        %previous offset, next onset, or 50, whichever is smaller
%             if numel(syll_onsets_user)>k
%                 shifttest2(1)=syll_onsets_user(k+1)-syll_offsets_user(k);
%             else
%                 shifttest2(1)=cols-syll_offsets_user(k);
%             end
%             if k>1
%                 shifttest2(2)=syll_onsets_user(k)-syll_offsets_user(k-1);
%             else
%                 shifttest2(2)=syll_onsets_user(k)-1;
%             end
%             shifttest2(3)=50;
%             shifttest=min(shifttest2);
%             for n=1-shifttest:shiftfactor1+shifttest
%                 syllsim_align_bigger(n+shifttest+1)=((sum(sum(sonogramthresh_blurred(:,syll_onsets_user(j):syll_onsets_user(j)+minlength).*sonogramthresh_blurred(:,(syll_onsets_user(k)+(n-1):syll_onsets_user(k)+minlength+(n-1))))))/maxoverlap)*100;
%             end
            
        end
        if whichsyllshorter==2
            syllsim_align=zeros(1,shiftfactor1);
            for m=1:shiftfactor1
%                 size(sonogramthresh_blurred(:,syll_onsets(j)+(m-1):syll_onsets(j)+minlength+(m-1)))
%                 size(syllclasses(:,1:1+minlength,k))
                syllsim_align(m)=((sum(sum(sonogramthresh_blurred(:,syll_onsets_user(j)+(m-1):syll_onsets_user(j)+minlength+(m-1)).*sonogramthresh_blurred(:,syll_onsets_user(k):syll_onsets_user(k)+minlength))))/maxoverlap)*100;
            end
%             if numel(syll_onsets_user)>j
%                 shifttest2(1)=syll_onsets_user(j+1)-syll_offsets_user(j);
%             else
%                 shifttest2(1)=cols-syll_offsets_user(j);
%             end
%             if j>1
%                 shifttest2(2)=syll_onsets_user(j)-syll_offsets_user(j-1);
%             else
%                 shifttest2(2)=syll_onsets_user(j)-1;
%             end
%             shifttest2(3)=50;
%             shifttest=min(shifttest2)
%             for n=(1-shifttest):shiftfactor1+shifttest
%                 syllsim_align_bigger(n+shifttest+1)=((sum(sum(sonogramthresh_blurred(:,syll_onsets_user(j)+(n-1):syll_onsets_user(j)+minlength+(n-1)).*sonogramthresh_blurred(:,syll_onsets_user(k):syll_onsets_user(k)+minlength))))/maxoverlap)*100;
%             end
        end
        sonogram_similarity(j,k)=max(syllsim_align);
%         sonogram_similarity_biggerwindow(j,k)=max(syllsim_align_bigger);
    end
end

% %define the pixel overlap of syllables to themselves
% sonogram_self_similarity=zeros(1,length(syll_onsets_user));
% for j=1:length(syll_onsets_user)
%     sum(sum(sonogramthresh_blurred(:,syll_onsets_user(j):syll_offsets_user(j))))
%     sonogram_self_similarity(j)=sum(sum(sonogramthresh_blurred(:,syll_onsets_user(j):syll_offsets_user(j)).*sonogramthresh_blurred(:,syll_onsets_user(j):syll_offsets_user(j))));
% end
% % sonogram_self_similarity
% 
% %%FIND PATTERN
% %find pixel overlap of each syllable to every other syllable
% sonogram_similarity=zeros(length(syll_onsets_user),length(syll_onsets_user));
% for j=1:length(syll_onsets_user)
%     for k=1:length(syll_onsets_user)
%         lengthsyll(1)=syll_offsets_user(j)-syll_onsets_user(j);
%         lengthsyll(2)=syll_offsets_user(k)-syll_onsets_user(k);
%         minlength=min(lengthsyll);
%         selfsim(1)=sonogram_self_similarity(j);
%         selfsim(2)=sonogram_self_similarity(k);
%         maxoverlap=max(selfsim);
% %         sonogram_similarity(j,k)=((sum(sum(sonogramthresh_blurred(:,syll_onsets(j):syll_onsets(j)+minlength).*sonogramthresh_blurred(:,syll_onsets(k):syll_onsets(k)+minlength))))/maxoverlap)*100;
%         syllsim_align(1)=((sum(sum(sonogramthresh_blurred(:,syll_onsets_user(j):syll_onsets_user(j)+minlength).*sonogramthresh_blurred(:,syll_onsets_user(k):syll_onsets_user(k)+minlength))))/maxoverlap)*100;
%         syllsim_align(2)=((sum(sum(sonogramthresh_blurred(:,syll_offsets_user(j)-(minlength-1):syll_offsets_user(j)).*sonogramthresh_blurred(:,syll_offsets_user(k)-(minlength-1):syll_offsets_user(k)))))/maxoverlap)*100;
%         sonogram_similarity(j,k)=max(syllsim_align);
%     end
% end

% sonogram_similarity

%make binary matrix with 50 threshold
similaritybinarysonogram50=zeros(length(sonogram_similarity));
%woot, vectorized
similaritybinarysonogram50(sonogram_similarity>50)=1;
for j=1:length(sonogram_similarity)
    similaritybinarysonogram50(j,j)=1;
end
% 

for j=1:length(sonogram_similarity)
%    n=find(similaritybinarysonogram40(:,j),1,'first');
    n=find(similaritybinarysonogram50(:,j),1,'first');
%    pattern_matrix_sonogram40(i,j)=n;
    pattern_matrix_sonogram50(file_number,j)=n;
end

pattern_matrix_vector=pattern_matrix_sonogram50(file_number,:);
pattern_matrix_vector=pattern_matrix_vector(pattern_matrix_vector~=0);
pattern_matrix_vector=pattern_matrix_vector(pattern_matrix_vector~=500);
num_unique_sylls(file_number)=length(unique(pattern_matrix_vector));
numsylls_dividedby_numuniques(file_number)=num_syllables(file_number)/num_unique_sylls(file_number);
sequential_repetition(file_number,1)=length(find(diff(pattern_matrix_vector)==0))/length(pattern_matrix_vector);
sequential_repetition(file_number,2)=length(find(diff(diff(pattern_matrix_vector))==0))/length(pattern_matrix_vector);



pattern_matrix_sonogram50(pattern_matrix_sonogram50==0)=500;

% for h=1:F
    for j=1:500%change this if i change dimension of pattern matrix
        if pattern_matrix_sonogram50(file_number,j)<j
            pattern_matrix_sonogram50_back(file_number,j)=pattern_matrix_sonogram50(file_number,pattern_matrix_sonogram50(file_number,j));
        else
            pattern_matrix_sonogram50_back(file_number,j)=pattern_matrix_sonogram50(file_number,j);
        end
    end
% end
%pattern_matrix_sonogram40_back
%pattern_matrix_sonogram50_back


%for pattern_matrix_sonogram50_back, find all instances of each syllable and
%if greater than 1 instance, average the similarity values in
%sonogram_similarity

for j=1:499
    xpatt=find(pattern_matrix_sonogram50_back(file_number,:)==j);
    stereotypy_vals=zeros(499);
    if length(xpatt)>1
        for k=1:length(xpatt)
            for h=1:length(xpatt)
            stereotypy_vals(k,h)=sonogram_similarity(xpatt(k),xpatt(h));
            end
        end
    end
    stereotypy_vals(stereotypy_vals>499)=0;
    stereotypy_vals=stereotypy_vals(stereotypy_vals~=0);
    %stereotypy_vals
    stereotypy_sylls(file_number,j)=mean(stereotypy_vals);
%     stereotypy_max(i,j)=max(max(stereotypy_vals));
%     stereotypy_min(i,j)=min(min(stereotypy_vals));
end
%stereotypy_sylls


sonogramthresh_threesylls=sonogramthresh(:,syll_onsets_user(1):syll_offsets_user(3));

[L,NUM]=bwlabel(sonogramthresh_threesylls,4);


% 
% figure('Position',[1 1 scrsz(3) (scrsz(4)/2-50)])
% 
% imagesc(L)
% colormap(hot)
% pause 
% close

for j=1:NUM
        sonogramonesyll=L;
        sonogramonesyll(sonogramonesyll ~= j) = 0;
        zerocols=all(~sonogramonesyll);
        sonogramonesyll(:,zerocols)=[];
        zerorows=all(~sonogramonesyll,2);
        freq_range_upper(file_number,j)=find(zerorows==0,1,'first');
        freq_range_lower(file_number,j)=find(zerorows==0,1,'last');
        sonogramonesyll(zerorows,:)=[];
        
        sonogramonesyll=sonogramonesyll./j;
        [rowsonesyll,colsonesyll]=size(sonogramonesyll);
%         colsonesyll

        if rowsonesyll*colsonesyll>150 %made this bigger for chipping sparrows
        
            note_length(file_number,j)=colsonesyll;
 %model the syll as a line
 %longest string of ones in a column - average index values and record y coord in a vector
            syllvals=zeros(colsonesyll,1);
        for jj=1:colsonesyll
            syllvals(jj)=mean(find(sonogramonesyll(:,jj)));
        end
        xvals=(1:colsonesyll)';
        polynomialtest=fit(xvals, syllvals, 'poly2');
        polyvals=feval(polynomialtest,xvals);
        polyslope=-diff(polyvals)./diff(xvals); %negative because of axis
        sign=polyslope./abs(polyslope);
        indexfactor=floor(length(polyslope)/5);
        indexvector=1:indexfactor:length(polyslope);
        slopesample=polyslope(indexvector);
        [maxslope,maxindex]=max(abs(slopesample));
        slopefactor=1/abs(slopesample(maxindex));
        slopesample=slopesample*slopefactor;
%         slopemean=mean(slopesample)
        slopestd=std(slopesample);
    
        diffvals=diff(sign);
        diffvals=diffvals(diffvals~=0);
        if sum(diffvals)==0
            diffvals(1)=0;
        end
        index=find(diff(sign));
        if sum(index)==0
            index=0;
        end
        index=index(1);
        polypeak=index/length(sign);
        heightdif=max(polyvals)-min(polyvals);
        riseoversquare=heightdif/30;

        %classify sylls (syll_class)
        % 1 = peak in first 20%; 2-5 etc (diffvals = -2)
        % 6 = trough in first 20%; 7-10 etc (diffvals = 2) 
        % 11 = up straight; 12 = up curved (diffvals = 0, sign(1) = 1)
        % 13 = down straight; 14 = down curved (diffvals = 0, sign(1) = -1)
        % 15 = flat
        
        if diffvals(1)==-2
            %has peak
            if polypeak > 0 && polypeak < 0.2
                syll_shape_class(file_number,j)=1;
            elseif polypeak >= 0.2 && polypeak < 0.4
                syll_shape_class(file_number,j)=2;
            elseif polypeak >= 0.4 && polypeak < 0.6
                syll_shape_class(file_number,j)=3;
            elseif polypeak >= 0.6 && polypeak < 0.8
                syll_shape_class(file_number,j)=4;
            elseif polypeak >= 0.8 && polypeak <= 1
                syll_shape_class(file_number,j)=5;  
            end
                
        end
        if diffvals(1)==2
            %has trough
            if polypeak > 0 && polypeak < 0.2
                syll_shape_class(file_number,j)=6;
            elseif polypeak >= 0.2 && polypeak < 0.4
                syll_shape_class(file_number,j)=7;
            elseif polypeak >= 0.4 && polypeak < 0.6
                syll_shape_class(file_number,j)=8;
            elseif polypeak >= 0.6 && polypeak < 0.8
                syll_shape_class(file_number,j)=9;
            elseif polypeak >= 0.8 && polypeak <= 1
                syll_shape_class(file_number,j)=10;  
            end
        end
        if diffvals(1)==0
            %no peak
            if sign(1)==1
                if slopestd < 0.25
                    syll_shape_class(file_number,j)=11;
                else
                    syll_shape_class(file_number,j)=12;
                end
            elseif sign(1)==-1
                if slopestd < 0.25
                    syll_shape_class(file_number,j)=13;
                else
                    syll_shape_class(file_number,j)=14;
                end
            end
        end
        if riseoversquare<0.1
            syll_shape_class(file_number,j)=15;
        end

% need to find diff --> -2 means peak 2 means trough
% need to locate peak --> polypeak gives location of peak/trough as
% fraction of width
% if no peak --> determine pos slope or neg slope; determine slope curve
%         figure
%         imagesc(sonogramonesyll)
%         hold on
%         plot(polyvals,'m-')
%         hold off
%         pause
%         close
        
        end

end

syll_shape_vector=syll_shape_class(file_number,:);
syll_shape_vector=syll_shape_vector(syll_shape_vector~=0);

for j=1:15
syll_shape_dist(file_number,j)=sum(syll_shape_class(file_number,:)==j);
end

syll_shape_dist(file_number,:)=syll_shape_dist(file_number,:)/sum(syll_shape_dist(file_number,:));

flat_sylls(file_number)=syll_shape_dist(file_number,15);
upsweeps(file_number)=syll_shape_dist(file_number,5)+syll_shape_dist(file_number,6)+syll_shape_dist(file_number,11)+syll_shape_dist(file_number,12);
downsweeps(file_number)=syll_shape_dist(file_number,1)+syll_shape_dist(file_number,10)+syll_shape_dist(file_number,13)+syll_shape_dist(file_number,14);
parabolas(file_number)=syll_shape_dist(file_number,2)+syll_shape_dist(file_number,3)+syll_shape_dist(file_number,4)+syll_shape_dist(file_number,7)+syll_shape_dist(file_number,8)+syll_shape_dist(file_number,9);

note_length_vector=note_length(file_number,:);
note_length_vector=note_length_vector(note_length_vector~=0);
if isempty(note_length_vector)==1
    note_length_vector=1
end
avg_note_length(file_number)=mean(note_length_vector);
longest_note(file_number)=max(note_length_vector);
shortest_note(file_number)=min(note_length_vector);
number_of_notes(file_number)=length(note_length_vector);
notes_per_syll(file_number)=number_of_notes(file_number)/num_syllables(file_number);

freq_factor=22050/513;
freq_up_vector=freq_range_upper(file_number,:);
freq_up_vector=freq_up_vector(freq_up_vector~=0);
freq_up_vector=(513-freq_up_vector)*freq_factor;
avg_up_freq(file_number)=mean(freq_up_vector);
max_freq(file_number)=max(freq_up_vector);

freq_low_vector=freq_range_lower(file_number,:);
freq_low_vector=freq_low_vector(freq_low_vector~=0);
freq_low_vector=(513-freq_low_vector)*freq_factor;
avg_low_freq(file_number)=mean(freq_low_vector);
min_freq(file_number)=min(freq_low_vector);
freq_range(file_number)=max_freq(file_number)-min_freq(file_number);
freq_modulation_per_syll=freq_up_vector-freq_low_vector;
mean_freq_modulation(file_number)=mean(freq_modulation_per_syll);


temp_all_vars(file_number,1)=mean_syll_durations(file_number);
temp_all_vars(file_number,2)=longest_syll(file_number);
temp_all_vars(file_number,3)=shortest_syll(file_number);
temp_all_vars(file_number,4)=mean_silence_durations(file_number);
temp_all_vars(file_number,5)=duration_of_bout(file_number);
temp_all_vars(file_number,6)=numsylls_dividedby_boutduration(file_number);
temp_all_vars(file_number,7)=num_syllables(file_number);
temp_all_vars(file_number,8)=num_unique_sylls(file_number);
temp_all_vars(file_number,9)=numsylls_dividedby_numuniques(file_number);
temp_all_vars(file_number,10)=sequential_repetition(file_number,1);
temp_all_vars(file_number,11)=sequential_repetition(file_number,2);
temp_all_vars(file_number,13)=avg_note_length(file_number);
temp_all_vars(file_number,14)=number_of_notes(file_number);
temp_all_vars(file_number,15)=shortest_note(file_number);
temp_all_vars(file_number,16)=longest_note(file_number);
temp_all_vars(file_number,17)=notes_per_syll(file_number);
temp_all_vars(file_number,18)=avg_up_freq(file_number);
temp_all_vars(file_number,19)=avg_low_freq(file_number);
temp_all_vars(file_number,20)=min_freq(file_number);
temp_all_vars(file_number,21)=max_freq(file_number);
temp_all_vars(file_number,22)=freq_range(file_number);
temp_all_vars(file_number,23)=mean_freq_modulation(file_number);
temp_all_vars(file_number,24)=flat_sylls(file_number);
temp_all_vars(file_number,25)=upsweeps(file_number);
temp_all_vars(file_number,26)=downsweeps(file_number);
temp_all_vars(file_number,27)=parabolas(file_number);
save variablestoragedesmondbouts.mat temp_all_vars
end

char(wavlist); 
char(analyzed_wav_files);
onset_cells{:,:};
offset_cells{:,:};

mean_syll_durations
longest_syll
shortest_syll
mean_silence_durations
duration_of_bout
numsylls_dividedby_boutduration
num_syllables
num_unique_sylls
numsylls_dividedby_numuniques
sequential_repetition
stereotypy_sylls
nanmean(stereotypy_sylls,2)
nanstd(stereotypy_sylls,0,2)
stereotypy(:,1)=nanmean(stereotypy_sylls,2)
stereotypy(:,2)=nanstd(stereotypy_sylls,0,2)
% %stereotypy_sylls
stereotypy
% stereotypyminmax(:,1)=min(stereotypy_min,[],2);
% stereotypyminmax(:,1)=max(stereotypy_max,[],2);
% stereotypyminmax
pattern_matrix_sonogram50_back(pattern_matrix_sonogram50_back==500)=0;


avg_note_length
number_of_notes
shortest_note
longest_note
notes_per_syll

avg_up_freq
avg_low_freq
min_freq
max_freq
freq_range
mean_freq_modulation

syll_shape_dist
flat_sylls
upsweeps
downsweeps
parabolas


all_vars(:,1)=mean_syll_durations;
all_vars(:,2)=longest_syll;
all_vars(:,3)=shortest_syll;
all_vars(:,4)=mean_silence_durations;
all_vars(:,5)=duration_of_bout;
all_vars(:,6)=numsylls_dividedby_boutduration;
all_vars(:,7)=num_syllables;
all_vars(:,8)=num_unique_sylls;
all_vars(:,9)=numsylls_dividedby_numuniques;
all_vars(:,10)=sequential_repetition(:,1);
all_vars(:,11)=sequential_repetition(:,2);
all_vars(:,12)=stereotypy(:,1);
all_vars(:,13)=avg_note_length;
all_vars(:,14)=number_of_notes;
all_vars(:,15)=shortest_note;
all_vars(:,16)=longest_note;
all_vars(:,17)=notes_per_syll;
all_vars(:,18)=avg_up_freq;
all_vars(:,19)=avg_low_freq;
all_vars(:,20)=min_freq;
all_vars(:,21)=max_freq;
all_vars(:,22)=freq_range;
all_vars(:,23)=mean_freq_modulation;
all_vars(:,24)=flat_sylls;
all_vars(:,25)=upsweeps;
all_vars(:,26)=downsweeps;
all_vars(:,27)=parabolas;

x=all_vars;

save allvariablesdesmondexcerpts.mat x

% editdistmatrix=sylleditdistancecondensed(pattern_matrix_sonogram50_back)
% editdistmatrixshapes=sylleditdistancecondensed(syll_shape_class)
% syll_shape_dist


%find closest one
% for h=1:F
%     closestsilence=abs(mean_silence_durations-mean_silence_durations(h));
%     closestsilence(h)=1000;
%     [Y,I]=min(closestsilence);
%     closest_element(h,1)=I;
%     for k=1:F
%         closestshapes(k)=sum(abs(syll_shape_dist(k,:)-syll_shape_dist(h,:)));
%     end
%     closestshapes(h)=1000;
%     [Y,I]=min(closestshapes);
%     closest_element(h,2)=I;
%     closestduration=abs(mean_syll_durations-mean_syll_durations(h));
%     closestduration(h)=1000;
%     [Y,I]=min(closestduration);
%     closest_element(h,3)=I;
%     closestnum=abs(num_syllables-num_syllables(h));
%     closestnum(h)=1000;
%     [Y,I]=min(closestnum);
%     closest_element(h,4)=I;
% end
% closest_element
%     
% for j=1:max(species_ID)
%     index=find(species_ID==j)
%     species_means(j,1)=mean(mean_silence_durations(index));
%     species_means(j,2)=mean(stereotypy(index,1));
%     species_means(j,3)=mean(num_unique_sylls(index));
%     species_means(j,4)=mean(mean_syll_durations(index));
%     species_means(j,5)=mean(num_syllables(index));
%     species_means(j,6)=mean(avg_syll_length(index));
%     species_means(j,7)=mean(avg_up_freq(index));
%     species_means(j,8)=mean(avg_low_freq(index));
%     mean_syll_shape(j,:)=mean(syll_shape_dist(index,:),1);
% end
% species_means
% mean_syll_shape
