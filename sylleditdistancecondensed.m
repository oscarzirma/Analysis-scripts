function [editmatrix, syllpatts] = sylleditdistancecondensed(syllablepatterns)

% import matrix output from previous program 
% take it row by row and delete zeros to get syllable pattern
% 
% try with and without this part:
% scan through pairs of syllables - when one nonmatching pair appears twice, 
%     replace it with a new number. repeat until no pairs
% 
% find most frequent number, replace with letter A. if multiple with same 
%     frequency, first one A, 2nd one B etc
% 
% for pairwise comparisons of strings, find edit distance. report.
    
    
syllpattern=syllablepatterns;

[rows,cols]=size(syllpattern);
syllstrings=cell(rows,1);
syllstrings_condensed=cell(rows,1);

for i=1:rows
    syllvector=syllpattern(i,:);

    syllvector=syllvector(syllvector~=0);
    table=zeros(length(syllvector)-1,2);
    for j=1:length(syllvector)-1
        table(j,1:2)=syllvector(j:j+1);
    end
    [b,m,n]=unique(table,'rows');
    maxnum=max(n);
%     table
%     n

    for reps=1:10
        testvector=zeros(1,maxnum);
        for k=1:maxnum
            x=find(n==k);
            if numel(x)>0
            if table(x(1),1)==table(x(1),2)
                testvector(k)=0;
            else
                testvector(k)=length(x);
            end
            end
        end
%         testvector
        if max(testvector)>1
            value=round(rand(1)*10000);
            [Y,maxvectindex]=max(testvector);
            x1=find(n==maxvectindex);
                for jj=1:length(x1)
                    syllvector(x1(jj))=value;
                    syllvector(x1(jj)+1)=0;
                end
        end
        syllvector=syllvector(syllvector~=0);
        table=zeros(length(syllvector)-1,2);
        for j=1:length(syllvector)-1
            table(j,1:2)=syllvector(j:j+1);
        end
        [b,m,n]=unique(table,'rows');
%         syllvector
%         n
%         maxnum=max(n);
%         table

    end
%         syllvector
        B=unique(syllvector);
        syllletters=zeros(1,length(syllvector));
        for j=1:length(B)
            M=mode(syllvector);
            [F,I]=find(syllvector==M);
            syllletters(I)=j+64;
            syllvector(I)=0/0; 
        end
        syllstrings_condensed{i}=char(syllletters);

end
    syllpatts = char(syllstrings_condensed)
    save syllpattsthresh.mat syllpatts 
    syll_editdistance_condensed=zeros(rows);
    for ij=1:rows
        for j=1:rows
            syll_editdistance_condensed(ij,j)=EditDist(syllstrings_condensed{ij},syllstrings_condensed{j});
%            syll_editdistance_condensed_divlength(ij,j)=EditDist(syllstrings_condensed{ij},syllstrings_condensed{j})/max(length(syllstrings_condensed{ij}),length(syllstrings_condensed{j}));
        end
    end
    editmatrix = syll_editdistance_condensed;
% % % 

% for i=1:rows
%     syllvector=syllpattern(i,:);
%     syllvector=syllvector(syllvector~=0);
%     B=unique(syllvector);
%     syllletters=zeros(1,length(syllvector));
%     for j=1:length(B)
%         M=mode(syllvector);
%         [F,I]=find(syllvector==M);
%         syllletters(I)=j+64;
%         syllvector(I)=0/0; 
%     end
%     syllstrings{i}=char(syllletters);
% end
% char(syllstrings)
% syll_editdistance=zeros(rows);
% for i=1:rows
%     for j=1:rows
%         syll_editdistance(i,j)=EditDist(syllstrings{i},syllstrings{j});
%     end
% end
% x= syll_editdistance;
% 
% 
% save 'syllstringscondensededitdistdividedsegsREGCLASSES.txt' syll_editdistance_condensed -ascii -tabs
% 
% 
% save 'syllstringseditdistdividedsegsREGCLASSES.txt' syll_editdistance -ascii -tabs
% 
%     for reps=1:5
%         syllvector=syllvector(syllvector~=0);
%         table=zeros(length(syllvector)-1,2);
%         for j=1:length(syllvector)-1
%             table(j,1:2)=syllvector(j:j+1);
%         end
%         [b,m,n]=unique(table,'rows');
% 
%         for k=1:max(n)
%             x=find(n==k);
%             value=round(rand(1)*10000);
%             if length(x)>1 && table(x(1),1)~=table(x(1),2)
%                 for jj=1:length(x)
% 
%                     syllvector(x(jj))=value;
%                     syllvector(x(jj)+1)=0;
%                 end
%             end
% 
%         end    
%     end