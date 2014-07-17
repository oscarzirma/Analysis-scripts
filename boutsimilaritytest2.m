function [analyzed_wav_file_numbers,boutsimilarity,syllable_overlap]=boutsimilaritytest2(analyzed_numbers,analyzed_wav_files,onset_cells,offset_cells)

%import a directory of wav files
directoryname = uigetdir('C:\Documents and Settings\nicole\My Documents\MATLAB','Choose a directory that contains the directory testseg'); 

directoryname 
subdir='./thesissegmentssecondtest/'
%subdir='./thesisbouttest/'
files = dir([subdir '*.wav']);

F=length(files)+1

%%%%define overarching variables here


analyzed_numbers(find(analyzed_numbers==0))=[];
analyzed_numbers=[1 analyzed_numbers];
analyzed_wav_files=analyzed_wav_files(analyzed_numbers);
onset_cells=onset_cells(analyzed_numbers);
offset_cells=offset_cells(analyzed_numbers);
char(analyzed_wav_files);

analyzed_wav_file_numbers=regexprep(analyzed_wav_files,'_\d\d-.*wav','_','ignorecase');
analyzed_wav_file_numbers=regexprep(analyzed_wav_file_numbers,'_\d-.*wav','_','ignorecase');
analyzed_wav_file_numbers=regexprep(analyzed_wav_file_numbers,'-','');
analyzed_wav_file_numbers=regexprep(analyzed_wav_file_numbers,'''','');
analyzed_wav_file_numbers=regexprep(analyzed_wav_file_numbers,'[a-z]*_','','ignorecase');
analyzed_wav_file_numbers=regexprep(analyzed_wav_file_numbers,'\D*','');


[unique_files,index1,individualindices]=unique(analyzed_wav_file_numbers);
boutsimilarity=zeros(max(individualindices),1);
syllable_overlap=zeros(max(individualindices),1);
% for i=1:F-1
%     wavfile=([files(i).name]);
%     wavlist{i}=wavfile;
% end
% char(wavlist)
% % 

for i=802:F-1
    tic
    i
    individuals=find(individualindices==i)
    numindividuals=length(individuals);
    bout_individual_similarity=zeros(numindividuals,numindividuals);
    syllable_similarity=zeros(numindividuals,numindividuals);
    if numindividuals>1
    for j=1:numindividuals
        clear sonogram*
        song1=wavread([subdir files(individuals(j)-1).name]);
        %might need to make files mono
        song1 = song1(:,1);
        %make spectrogram binary, divide by max value to get 0-1 range
        %compute spectrogram with gaussian window
        sonogram1=ifdvsonogramonly(song1,44100,1024,1010,2,1,3,5,5);  
        sonogram1(495:513,:)=0;
        % figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
        % imagesc(log(sonogram+3))
        %for desmond's analysis there is a padding on both sides
        [rows1,cols1]=size(sonogram1);
        sonogram1=sonogram1./max(max(sonogram1)); 

        syll_onsets_one=onset_cells{individuals(j)}-150;
        syll_offsets_one=offset_cells{individuals(j)}-150;
        
        
            sonogram_self_similarity_one=zeros(1,length(syll_onsets_one));
            for h=1:length(syll_onsets_one)
                sonogram_self_similarity_one(h)=sum(sum(sonogram1(:,syll_onsets_one(h):syll_offsets_one(h)).*sonogram1(:,syll_onsets_one(h):syll_offsets_one(h))));
            end

        for k=1:numindividuals
        %get sonogram for pairs of individuals, overlap whole sonograms with longer one padded 
        %get syllables overlaps for pairs of syllables

 
            song2=wavread([subdir files(individuals(k)-1).name]);

            %might need to make files mono
            song2 = song2(:,1);
            %make spectrogram binary, divide by max value to get 0-1 range
            %compute spectrogram with gaussian window
            sonogram2=ifdvsonogramonly(song2,44100,1024,1010,2,1,3,5,5);  
            sonogram2(495:513,:)=0;
            % figure('Position',[1 scrsz(4)/2 scrsz(3) (scrsz(4)/2-100)])
            % imagesc(log(sonogram+3))
            %for desmond's analysis there is a padding on both sides
            [rows2,cols2]=size(sonogram2);
            sonogram2=sonogram2./max(max(sonogram2)); 

            
            if j==k
                bout_individual_similarity(j,k)=sum(sum(sonogram1.*sonogram2));
                syllable_similarity(j,k)=1;
            elseif j>k

            syll_onsets_two=onset_cells{individuals(k)}-150;
            syll_offsets_two=offset_cells{individuals(k)}-150;

            sonogram_self_similarity_two=zeros(1,length(syll_onsets_two));
            for h=1:length(syll_onsets_two)
                sonogram_self_similarity_two(h)=sum(sum(sonogram2(:,syll_onsets_two(h):syll_offsets_two(h)).*sonogram2(:,syll_onsets_two(h):syll_offsets_two(h))));
            end

            lengthsyll(1)=cols1;
            lengthsyll(2)=cols2;
            [maxlength,whichsylllonger]=max(lengthsyll);
            if whichsylllonger==1
                sonogrampadded1=zeros(rows1,cols1+1000);
                sonogrampadded1(:,501:cols1+500)=sonogram1;
                [rows1p,cols1p]=size(sonogrampadded1);
                lengthsyll(1)=cols1p;
            end
            
            if whichsylllonger==2
                sonogrampadded2=zeros(rows2,cols2+1000);
                sonogrampadded2(:,501:cols2+500)=sonogram2;
                [rows2p,cols2p]=size(sonogrampadded2);
                lengthsyll(2)=cols2p;
            end

            
            
            
            [minlength,whichsyllshorter]=min(lengthsyll);
            shiftfactor1=abs(lengthsyll(1)-lengthsyll(2));
            if lengthsyll(1)==lengthsyll(2)
                shiftfactor1=1;
            end
%             selfsim(1)=onesyll_selfsim(j);
%             selfsim(2)=onesyll_selfsim(k);
%             maxoverlap=max(selfsim);
          

            if whichsyllshorter==1
                 syllsim_align=zeros(1,shiftfactor1);
                for m=1:shiftfactor1
                    syllsim_align(m)=((sum(sum(sonogram1(:,(1:minlength)).*sonogrampadded2(:,(m:minlength+(m-1)))))));
                end

            end

            
            if whichsyllshorter==2
                syllsim_align=zeros(1,shiftfactor1);
                for m=1:shiftfactor1
                    syllsim_align(m)=((sum(sum(sonogrampadded1(:,(m:(m-1)+minlength)).*sonogram2(:,(1:minlength))))));
                end
            end
     
            bout_individual_similarity(j,k)=max(syllsim_align);

            
            

            individual_syll_similarity=zeros(length(syll_onsets_one),length(syll_onsets_two));
            for t=1:length(syll_onsets_one)
                for u=1:length(syll_onsets_two)
                    lengthsyll(1)=syll_offsets_one(t)-syll_onsets_one(t);
                    lengthsyll(2)=syll_offsets_two(u)-syll_onsets_two(u);
                    [minlength,whichsyllshorter]=min(lengthsyll);
                    shiftfactor1=abs(lengthsyll(1)-lengthsyll(2));
                    if lengthsyll(1)==lengthsyll(2)
                        shiftfactor1=1;
                    end
                    selfsim(1)=sonogram_self_similarity_one(t);
                    selfsim(2)=sonogram_self_similarity_two(u);
                    maxoverlap=max(selfsim);
                    if whichsyllshorter==1
                         syllsim_align=zeros(1,shiftfactor1);
                        for m=1:shiftfactor1
                            syllsim_align(m)=((sum(sum(sonogram1(:,syll_onsets_one(t):syll_onsets_one(t)+minlength).*sonogram2(:,(syll_onsets_two(u)+(m-1):syll_onsets_two(u)+minlength+(m-1))))))/maxoverlap)*100;
                        end
                    end
                    if whichsyllshorter==2
                        syllsim_align=zeros(1,shiftfactor1);
                        for m=1:shiftfactor1
                            syllsim_align(m)=((sum(sum(sonogram1(:,syll_onsets_one(t)+(m-1):syll_onsets_one(t)+minlength+(m-1)).*sonogram2(:,syll_onsets_two(u):syll_onsets_two(u)+minlength))))/maxoverlap)*100;
                        end
                    end
                    individual_syll_similarity(t,u)=max(syllsim_align);
                end
            end
            individual_syll_similarity(individual_syll_similarity<50)=0;
            individual_syll_similarity(individual_syll_similarity>=50)=1;
            syllable_similarity(j,k)=((length(find(sum(individual_syll_similarity,1)))/length(syll_onsets_two))+(length(find(sum(individual_syll_similarity,2)))/length(syll_onsets_one)))/2;

            end
            
        end

    end

    bout_individual_similarity=bout_individual_similarity+tril(bout_individual_similarity,-1)';
    syllable_similarity=syllable_similarity+tril(syllable_similarity,-1)';
    

    bout_individual_similarity_scaled=bout_individual_similarity;
    for j=1:numindividuals
        for k=1:numindividuals
            selfsim(1)=bout_individual_similarity(j,j);
            selfsim(2)=bout_individual_similarity(k,k);
            maxoverlap=max(selfsim);
            bout_individual_similarity_scaled(j,k)=bout_individual_similarity(j,k)/maxoverlap;
        end
    end
    
%     bout_individual_similarity_scaled
    
    %take the mean of all the calculations except the diagonal (self)
    %values

    syllable_overlap(i)=(sum(sum(syllable_similarity))-sum(diag(syllable_similarity)))/(numindividuals*numindividuals-numindividuals);
  
    boutsimilarity(i)=(sum(sum(bout_individual_similarity_scaled))-sum(diag(bout_individual_similarity_scaled)))/(numindividuals*numindividuals-numindividuals);
    end
        
save boutsimilaritytemp.mat analyzed_wav_files analyzed_wav_file_numbers boutsimilarity syllable_overlap
toc
end


sendmail('creanza@gmail.com', 'Gmail Test', 'This is a test message.','boutsimilaritytemp.mat');


char(analyzed_wav_files(index1))
boutsimilarity
syllable_overlap