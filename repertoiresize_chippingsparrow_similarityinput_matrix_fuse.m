
function [syllexamples,syllexampleslengths,syll_groups_matrix_fixedlength]=repertoiresize_chippingsparrow_similarityinput_matrix_fuse(analyzed_numbers,analyzed_wav_files,onset_cells,offset_cells,syllable_similarity)

%this program does not calculate the similarity matrix, but uses one that
%the user provides


%%[syllable_similarity,syllexamples,syllexampleslengths]=repertoiresize_chippingsparrow_similarity_matrix(analyzed_numbers2,analyzed_wav_files,onset_cells,offset_cells);

%ideas: length thresh; compare to every syll and find best match, put in
%the group of that one

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
directoryname = uigetdir('C:\Documents and Settings\ncreanza\My Documents\MATLAB','Choose a directory that contains the directory testseg'); 

directoryname 
%subdir='./testchippy/'
subdir='./chippingsparrowgoodfilesfourthtest/'
files = dir([subdir '*.wav']);

F=length(files)+1


analyzed_numbers(find(analyzed_numbers==0))=[];
analyzed_numbers=[1 analyzed_numbers];
analyzed_wav_files=analyzed_wav_files(analyzed_numbers);
onset_cells=onset_cells(analyzed_numbers);
offset_cells=offset_cells(analyzed_numbers);
char(analyzed_wav_files)


%%%%define overarching variables here


%syllclasses=zeros(513, 2000, 100);
syllexamples=zeros(513, 500, F);
%syllclassesaverages=zeros(513, 2000, 10);


%syllclasses(:,:,1)=SOMEPURETONE
% syllclasscounts(1)=1;
% syllclasslengths(1)=50;
% total_number_of_sylls_analyzed=0;
% syllclassselfsim(1)=1;
% newsyllables(1)=1
% syll_class_matrix=zeros(F-1,3);
syllexampleslengths=zeros(F-1,1);
onesyll_selfsim=zeros(F-1,1);

scrsz = get(0,'ScreenSize');

analyzed_wav_files{1}='test.wav';

datestr(now)

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
%char(analyzed_wav_files)

file_number=strmatch(wavlist{i}, analyzed_wav_files, 'exact')

%might need to make files mono
song1 = song1(:,1);


%make spectrogram binary, divide by max value to get 0-1 range


%compute spectrogram with gaussian window
sonogram=ifdvsonogramonly(song1,44100,1024,1010,2,1,3,5,5);    
% figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
% imagesc(log(sonogram+3))
%for desmond's analysis there is a padding on both sides
[rows,cols]=size(sonogram);
sonogrampadded=zeros(rows,cols+300);
sonogrampadded(:,151:cols+150)=sonogram;
sonogram=sonogrampadded;
[rows,cols]=size(sonogram);
numelements=rows*cols;
%numelements
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
    if syll_offsets(j)-syll_onsets(j)<50 %sets minimum syll size
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
num_syllables(file_number)=length(syll_onsets);
syll_onsets;
syll_offsets;

syllable_marks=zeros(1,length(sumsonogram_scaled));
syllable_marks(syll_onsets)=(rows+30);
syllable_marks(syll_offsets)=(rows+10);
% % 
% % 
% % % draw spectrogram with sumsonogram overlaid
figure('Position',[1 1 scrsz(3) (scrsz(4)/2-50)])
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
        figure('Position',[1 1 scrsz(3) (scrsz(4)/2-50)])
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
            [val,delete_val]=min(abs(syll_onsets_user-X3(L)))
            syll_onsets_user=syll_onsets_user(syll_onsets_user~=syll_onsets_user(delete_val));
        end

        disp('Use left mouse button to select syllable OFFSETS that should be DELETED, then press return.')
        [X4,Y4notneeded] = ginput;

        X4

        for L=1:length(X4)
            [val2,delete_val2]=min(abs(syll_offsets_user-X4(L)))
            syll_offsets_user=syll_offsets_user(syll_offsets_user~=syll_offsets_user(delete_val2));
        end

        syllable_marks=zeros(1,length(sumsonogram_scaled));
        syllable_marks(syll_onsets_user)=(rows+30);
        syllable_marks(syll_offsets_user)=(rows+10);
        % % 
        % % 
        % % % draw spectrogram with sumsonogram overlaid
        close
        figure('Position',[1 1 scrsz(3) (scrsz(4)/2-50)])
        %figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
        hold on
        imagesc(log(sonogramthresh+3))
        plot(syllable_marks,'m-')
        hold off
        pause
        close
        close

        onset_cells{file_number}=syll_onsets_user;
        offset_cells{file_number}=syll_offsets_user;

    else
        syll_onsets_user=syll_onsets;
        syll_offsets_user=syll_offsets;
        onset_cells{file_number}=syll_onsets_user;
        offset_cells{file_number}=syll_offsets_user;
        close
        close
    end
    
else
   syll_onsets_user=onset_cells{file_number};
   syll_offsets_user=offset_cells{file_number};
   close
end

syll_onsets_user=syll_onsets_user(3:3);
syll_offsets_user=syll_offsets_user(3:3);

%take sonogram (thresholded) and split it into syllables by sonogram and compare by
%multiplying values and summing and dividing by the max possible overlap 
%(bigger of the two diagonal overlaps?)

%do a gaussian blur of the thresholded sonogram
h = fspecial('gaussian',10,10);
sonogramthresh_blurred=imfilter(sonogramthresh,h);
%sonogramthresh_blurred=sonogram40;

%define the pixel overlap of syllables to themselves
%%%%go back to this if i change to more than one syll per song
% sonogram_self_similarity=zeros(1,length(syll_onsets_user));
% for j=1:length(syll_onsets_user)
%     sonogram_self_similarity(j)=sum(sum(sonogramthresh_blurred(:,syll_onsets_user(j):syll_offsets_user(j)).*sonogramthresh_blurred(:,syll_onsets_user(j):syll_offsets_user(j))));
% end
sonogram_self_similarity=sum(sum(sonogramthresh_blurred(:,syll_onsets_user(1):syll_offsets_user(1)).*sonogramthresh_blurred(:,syll_onsets_user(1):syll_offsets_user(1))));
onesyll_selfsim(i)=sonogram_self_similarity;

%store a syllable example for inspection
syllexamples(:,(1:(syll_offsets_user(1)-syll_onsets_user(1)+1)),i)=sonogramthresh_blurred(:,syll_onsets_user(1):syll_offsets_user(1));
syllexampleslengths(i)=syll_offsets_user(1)-syll_onsets_user(1)+1;

end

%%FIND PATTERN
%find pixel overlap of each syllable to every other syllable
% disp('calculating similarity')
% tic
% 
% syllable_similarity=zeros(length(syllexampleslengths),length(syllexampleslengths));
% for j=1:F-1
%     for k=1:F-1
%         lengthsyll(1)=syllexampleslengths(j);
%         lengthsyll(2)=syllexampleslengths(k);
%         [minlength,whichsyllshorter]=min(lengthsyll);
%         shiftfactor1=abs(lengthsyll(1)-lengthsyll(2));
%         if lengthsyll(1)==lengthsyll(2)
%             shiftfactor1=1;
%         end
%         selfsim(1)=onesyll_selfsim(j);
%         selfsim(2)=onesyll_selfsim(k);
%         maxoverlap=max(selfsim);
%         if whichsyllshorter==1
%              syllsim_align=zeros(1,shiftfactor1);
%             for m=1:shiftfactor1
%                 syllsim_align(m)=((sum(sum(syllexamples(:,(1:1+minlength),j).*syllexamples(:,(m:minlength+m),k))))/maxoverlap)*100;
%             end
%             
%         end
%         if whichsyllshorter==2
%             syllsim_align=zeros(1,shiftfactor1);
%             for m=1:shiftfactor1
% %                 size(sonogramthresh_blurred(:,syll_onsets(j)+(m-1):syll_onsets(j)+minlength+(m-1)))
% %                 size(syllclasses(:,1:1+minlength,k))
%                 syllsim_align(m)=((sum(sum(syllexamples(:,(m:m+minlength),j).*syllexamples(:,(1:minlength+1),k))))/maxoverlap)*100;
%             end
%         end
%         syllable_similarity(j,k)=max(syllsim_align);
%     end
% end
% 
% toc
% syllable_similarity;
% 
% save syllable_similarity_chippy.mat syllable_similarity

diagonalvector(1:length(syllable_similarity),1)=-100;
diagonalmatrix=diag(diagonalvector);
syllable_similarity=syllable_similarity+diagonalmatrix;
syllable_similarity(syllable_similarity<65)=0; %sets similarity threshold


% %make binary matrix with 55 threshold
% similaritybinarysonogram55=zeros(length(syllable_similarity));
% %woot, vectorized
% similaritybinarysonogram55(syllable_similarity>55)=1;
% for j=1:length(syllable_similarity)
%     similaritybinarysonogram55(j,j)=1;
% end
% % 


%make binary matrix with 50 threshold, only compare syllables with similar
%lengths
similarity_similarlengths=syllable_similarity;
%woot, vectorized
disp('calculating similarity length restriction')
tic

for j=1:length(syllable_similarity)
    for k=1:length(syllable_similarity)
        lengthsyll(1)=syllexampleslengths(j);
        lengthsyll(2)=syllexampleslengths(k);
        [minlength,whichsyllshorter]=min(lengthsyll);
        lengthfactor=round(minlength*0.25); 
        if abs(lengthsyll(2)-lengthsyll(1))>lengthfactor
            similarity_similarlengths(j,k)=0;
        end
    end
end

toc

similarity_similarlengths;


[Ysim,Isim]=max(syllable_similarity,[],1)
singletons=find(Ysim==0);
Isim(singletons)=singletons;
[Ysimlength,Isimlength]=max(similarity_similarlengths,[],1)
singletons2=find(Ysimlength==0);
Isimlength(singletons2)=singletons2;

nums=1:1:length(syllable_similarity);

syll_pairs1(:,1)=nums';
syll_pairs1(:,2)=Isim';

syll_length_pairs1(:,1)=nums';
syll_length_pairs1(:,2)=Isimlength';

%if sum of the column is zero, put it in its own group
%if sum of the column is greater than zero, find max
%1&4 2&3 3&6 4&5 5&1 6&3
% syll_groups_matrix=zeros(1,round(F/2));
% syll_groups_matrix(1,1:2)=syll_pairs1(1,1:2);
% 
% disp('calculating groups matrix')
% tic
% 
% for i=2:length(syllable_similarity)
%     [i1,j1]=find(syll_groups_matrix==syll_pairs1(i,1));
%     [i2,j2]=find(syll_groups_matrix==syll_pairs1(i,2));
%     if isempty(i1)==1
%         if isempty(i2)==1
%             syll_groups_matrix(size(syll_groups_matrix,1)+1,1:2)=syll_pairs1(i,1:2);
%         else
%             vectorindex=max(find(syll_groups_matrix(i2,:)))+1;
%             syll_groups_matrix(i2,vectorindex)=syll_pairs1(i,1);
%         end
%     end
%     if isempty(i2)==1
%         if isempty(i1)==0
%             vectorindex=max(find(syll_groups_matrix(i1,:)))+1;
%             syll_groups_matrix(i1,vectorindex)=syll_pairs1(i,2);
%         end
%     end
%     if isempty(i2)==0 && isempty(i1)==0 && i1~=i2
%         %if two matches are in different categories, fuse them: 
%         vectorindex=max(find(syll_groups_matrix(i1,:)))+1;
%         moveindex=find(syll_groups_matrix(i2,:));
%         syll_groups_matrix(i1,vectorindex:vectorindex+length(moveindex)-1)=syll_groups_matrix(i2,moveindex);
%         syll_groups_matrix(i2,:)=[];
%     end
% end
% 
% toc

% syll_groups_matrix;

syll_groups_matrix_fixedlength=zeros(1,round(F/2));
syll_groups_matrix_fixedlength(1,1:2)=syll_length_pairs1(1,1:2);

disp('calculating groups matrix length restricted')
tic

for i=2:length(syllable_similarity)
    [i1,j1]=find(syll_groups_matrix_fixedlength==syll_length_pairs1(i,1));
    [i2,j2]=find(syll_groups_matrix_fixedlength==syll_length_pairs1(i,2));
    if isempty(i1)==1
        if isempty(i2)==1
            syll_groups_matrix_fixedlength(size(syll_groups_matrix_fixedlength,1)+1,1:2)=syll_length_pairs1(i,1:2);
        else
            vectorindex2=max(find(syll_groups_matrix_fixedlength(i2,:)))+1;
            syll_groups_matrix_fixedlength(i2,vectorindex2)=syll_length_pairs1(i,1);
        end
    end
    if isempty(i2)==1
        if isempty(i1)==0
            vectorindex2=max(find(syll_groups_matrix_fixedlength(i1,:)))+1;
            syll_groups_matrix_fixedlength(i1,vectorindex2)=syll_pairs1(i,2);
        end    
    end
    if isempty(i2)==0 && isempty(i1)==0 && i1~=i2
        vectorindex2=max(find(syll_groups_matrix_fixedlength(i1,:)))+1;
        moveindex2=find(syll_groups_matrix_fixedlength(i2,:));
        syll_groups_matrix_fixedlength(i1,vectorindex2:vectorindex2+length(moveindex2)-1)=syll_groups_matrix_fixedlength(i2,moveindex2);
        syll_groups_matrix_fixedlength(i2,:)=[];
    end
end

toc

syll_groups_matrix_fixedlength;



disp('variables')
tic
scrsz = get(0,'ScreenSize');
numsylls=max(max(syll_groups_matrix_fixedlength));
sylltypesvector=zeros(1,numsylls);
toc

disp('making vector')
tic

for i=1:numsylls
    [ix,jx]=find(syll_groups_matrix_fixedlength==i);
    sylltypesvector(i)=ix(1);
end

toc
disp('sorting')
tic

[sylltypesvector_sorted,syllclassorder1]=sort(sylltypesvector);
syll_similarity_sorted_fixedlength=similarity_similarlengths(syllclassorder1,syllclassorder1);
[uniquesyllclasses,uniqueindex]=unique(sylltypesvector_sorted,'first');
[uniquesyllclasses2,uniqueindexlast]=unique(sylltypesvector_sorted,'last');

syllclassoverlap=zeros(length(uniqueindex));
for j=1:length(uniqueindex)
    for k=1:length(uniqueindex)
        syllclassoverlap(j,k)=mean(mean(syll_similarity_sorted_fixedlength(uniqueindex(j):uniqueindexlast(j),uniqueindex(k):uniqueindexlast(k))));
    end
end

testoverlaps=1;
figure
imagesc(syllclassoverlap)

diagonalvector2(1:length(syllclassoverlap),1)=1;
diagonalmatrix2=diag(diagonalvector2);
syllclassoverlap2=syllclassoverlap.*diagonalmatrix2;
syllclassoverlap2=syllclassoverlap2(syllclassoverlap2~=0);
mean(syllclassoverlap2)


[io,jo]=find(syllclassoverlap>40)
for j=length(io):-1:1
    if io(j) >= jo(j)
        io(j)=[]
        jo(j)=[]
%         testoverlaps(length(testoverlaps)+1)=io(j);
%         testoverlaps(length(testoverlaps)+1)=jo(j);
    end
end

pairstofuse(:,1)=io;
pairstofuse(:,2)=jo

for j=1:length(pairstofuse)
    moveindex3=find(syll_groups_matrix_fixedlength(pairstofuse(j,1),:));
    syll_groups_matrix_fixedlength(i1,vectorindex2:vectorindex2+length(moveindex2)-1)=syll_groups_matrix_fixedlength(i2,moveindex2);
    syll_groups_matrix_fixedlength(i2,:)=[];
end

% testoverlaps(1)=[];
% testoverlaps
% sylloverlaps=zeros(1,length(testoverlaps));
% for j=1:length(testoverlaps)
%     sylloverlaps(j)=find(sylltypesvector_sorted==testoverlaps(j),1,'first');
% end
% sylloverlaps

[sylltypesvector_sorted,syllclassorder]=sort(sylltypesvector);
% sylltypesvector_subsetfortest=sylltypesvector_sorted(sylloverlaps);
analyzed_wav_files_sorted=analyzed_wav_files;
analyzed_wav_files_sorted=analyzed_wav_files_sorted(syllclassorder);
analyzed_wav_files_sorted_clipped=regexprep(analyzed_wav_files_sorted,' fivesyll.wav','');
analyzed_wav_files_sorted_clipped=regexprep(analyzed_wav_files_sorted_clipped,'_\d\d\d\d\d\d\d\d\d','');
% analyzed_wav_files_subsetfortest=analyzed_wav_files_sorted_clipped(sylloverlaps);
syllexamples_sorted=syllexamples(:,:,syllclassorder);
% syllexamples_subsetfortest=syllexamples_sorted(:,:,sylloverlaps);
syllexampleslengths_sorted=syllexampleslengths(syllclassorder);
% syllexampleslengths_subsetfortest=syllexampleslengths_sorted(sylloverlaps);

% disp('making figure')
% tic
% 
% numberoffigs2=ceil(length(sylloverlaps)/40)
% 
% for f=1:numberoffigs2
% 
% figure('Position',[1 1 scrsz(3) (scrsz(4)-50)],'Name',['syllable classes ',num2str(f)])
% 
%     for j=1:40
%         fignum=(f-1)*40+j;
%         if fignum <= length(sylloverlaps)
%         subplot(5,8,j); imagesc(syllexamples_subsetfortest(:,1:syllexampleslengths_subsetfortest(fignum),fignum))
%         title(['Type ',num2str(sylltypesvector_subsetfortest(fignum)),':', char(analyzed_wav_files_subsetfortest(fignum))])
%         axis([0 400 275 500])
%         end
%     end 
% end
% toc



toc
% disp('making figure')
% tic
% 
% numberoffigs2=ceil(length(syllclassorder)/60);
% 
% for f=1:numberoffigs2
% 
% figure('Position',[1 1 scrsz(3) (scrsz(4)-50)],'Name',['syllable classes ',num2str(f)])
% 
%     for j=1:60
%         fignum=(f-1)*60+j;
%         if fignum <= length(syllclassorder)
%         subplot(6,10,j); imagesc(syllexamples_sorted(:,1:syllexampleslengths_sorted(fignum),fignum))
%         title(['Type ',num2str(sylltypesvector_sorted(fignum)),':', char(analyzed_wav_files_sorted_clipped(fignum))])
%         axis([0 400 275 500])
%         end
%     end 
% end
% toc

disp('making uniques')
tic

[uniquesyllclasses,uniqueindex]=unique(sylltypesvector_sorted,'first');
analyzed_wav_files_sorted_unique=analyzed_wav_files_sorted(uniqueindex);
analyzed_wav_files_sorted_clipped_unique=analyzed_wav_files_sorted_clipped(uniqueindex);
syllexamples_sorted_unique=syllexamples_sorted(:,:,uniqueindex);
syllexampleslengths_sorted_unique=syllexampleslengths_sorted(uniqueindex);

toc
disp('making unique figure')
% tic
% 
% numberoffigs3=ceil(length(uniqueindex)/60);
% 
% for f=1:numberoffigs3
% 
% figure('Position',[1 1 scrsz(3) (scrsz(4)-50)],'Name',['unique syllable classes ',num2str(f)])
% 
%     for j=1:60
%         fignum=(f-1)*60+j;
%         if fignum <= length(uniquesyllclasses)
%         subplot(6,10,j); imagesc(syllexamples_sorted_unique(:,1:syllexampleslengths_sorted_unique(fignum),fignum))
%         title(['Type ',num2str(uniquesyllclasses(fignum)),':', char(analyzed_wav_files_sorted_clipped_unique(fignum))])
%         axis([0 400 275 500])
%         end
%     end 
% end
% toc




% 
% 
% for j=1:length(syllable_similarity)
% %    n=find(similaritybinarysonogram40(:,j),1,'first');
%     n=find(similaritybinarysonogram55_similarlengths(:,j),1,'first');
% %    pattern_matrix_sonogram40(i,j)=n;
%     pattern_vector_simlengths(j)=n;
% end
% 
% pattern_vector_simlengths
% 
% 
% pattern_vector_simlengths_backcheck=pattern_vector_simlengths;
% for j=1:length(pattern_vector_simlengths)
%     if pattern_vector_simlengths(j)<j
%         pattern_vector_simlengths_backcheck(j)=pattern_vector_simlengths(pattern_vector_simlengths(j));
%     else
%         pattern_vector_simlengths_backcheck(j)=pattern_vector_simlengths(j);
%     end
% end
% 
% 
% pattern_vector_simlengths_backcheck
% 
% 
% [pattern_matrix_sorted,syllclassorder]=sort(pattern_vector);
% analyzed_wav_files_sorted=analyzed_wav_files;
% analyzed_wav_files_sorted(1)=[];
% analyzed_wav_files_sorted=analyzed_wav_files_sorted(syllclassorder);
% analyzed_wav_files_sorted_clipped=regexprep(analyzed_wav_files_sorted,' fivesyll.wav','');
% syllexamples_sorted=syllexamples(:,:,syllclassorder);
% syllexampleslengths_sorted=syllexampleslengths(syllclassorder);
% 
% numberoffigs2=ceil(length(syllclassorder)/60);
% 
% for f=1:1%numberoffigs2
% 
% figure('Position',[1 1 scrsz(3) (scrsz(4)-50)])
% 
%     for j=1:60
%         fignum=(f-1)*60+j+1;
%         if fignum <= length(syllclassorder)
%         subplot(6,10,j); imagesc(syllexamples_sorted(:,1:syllexampleslengths_sorted(fignum),fignum))
%         title(['Type ',num2str(pattern_matrix_sorted(fignum)),':', char(analyzed_wav_files_sorted_clipped(fignum))])
%         axis([0 400 275 500])
%         end
%     end 
% end
% 
% [pattern_matrix_sorted,syllclassorder2]=sort(pattern_vector_backcheck);
% analyzed_wav_files_sorted=analyzed_wav_files;
% analyzed_wav_files_sorted(1)=[];
% analyzed_wav_files_sorted=analyzed_wav_files_sorted(syllclassorder2);
% analyzed_wav_files_sorted_clipped=regexprep(analyzed_wav_files_sorted,' fivesyll.wav','');
% syllexamples_sorted=syllexamples(:,:,syllclassorder2);
% syllexampleslengths_sorted=syllexampleslengths(syllclassorder2);
% 
% for f=1:1%numberoffigs2
% 
% figure('Position',[1 1 scrsz(3) (scrsz(4)-50)])
% 
%     for j=1:60
%         fignum=(f-1)*60+j+1;
%         if fignum <= length(syllclassorder)
%         subplot(6,10,j); imagesc(syllexamples_sorted(:,1:syllexampleslengths_sorted(fignum),fignum))
%         title(['Type ',num2str(pattern_matrix_sorted(fignum)),':', char(analyzed_wav_files_sorted_clipped(fignum))])
%         axis([0 400 275 500])
%         end
%     end 
% end
% 
% [pattern_matrix_sorted,syllclassorder3]=sort(pattern_vector_simlengths);
% analyzed_wav_files_sorted=analyzed_wav_files;
% analyzed_wav_files_sorted(1)=[];
% analyzed_wav_files_sorted=analyzed_wav_files_sorted(syllclassorder3);
% analyzed_wav_files_sorted_clipped=regexprep(analyzed_wav_files_sorted,' fivesyll.wav','');
% syllexamples_sorted=syllexamples(:,:,syllclassorder3);
% syllexampleslengths_sorted=syllexampleslengths(syllclassorder3);
% 
% for f=1:1%numberoffigs2
% 
% figure('Position',[1 1 scrsz(3) (scrsz(4)-50)])
% 
%     for j=1:60
%         fignum=(f-1)*60+j+1;
%         if fignum <= length(syllclassorder)
%         subplot(6,10,j); imagesc(syllexamples_sorted(:,1:syllexampleslengths_sorted(fignum),fignum))
%         title(['Type ',num2str(pattern_matrix_sorted(fignum)),':', char(analyzed_wav_files_sorted_clipped(fignum))])
%         axis([0 400 275 500])
%         end
%     end 
% end
% 
% [pattern_matrix_sorted,syllclassorder4]=sort(pattern_vector_simlengths_backcheck);
% analyzed_wav_files_sorted=analyzed_wav_files;
% analyzed_wav_files_sorted(1)=[];
% analyzed_wav_files_sorted=analyzed_wav_files_sorted(syllclassorder4);
% analyzed_wav_files_sorted_clipped=regexprep(analyzed_wav_files_sorted,' fivesyll.wav','');
% syllexamples_sorted=syllexamples(:,:,syllclassorder4);
% syllexampleslengths_sorted=syllexampleslengths(syllclassorder4);
% 
% for f=1:1%numberoffigs2
% 
% figure('Position',[1 1 scrsz(3) (scrsz(4)-50)])
% 
%     for j=1:60
%         fignum=(f-1)*60+j+1;
%         if fignum <= length(syllclassorder)
%         subplot(6,10,j); imagesc(syllexamples_sorted(:,1:syllexampleslengths_sorted(fignum),fignum))
%         title(['Type ',num2str(pattern_matrix_sorted(fignum)),':', char(analyzed_wav_files_sorted_clipped(fignum))])
%         axis([0 400 275 500])
%         end
%     end 
% end
% 
% 
