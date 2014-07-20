function deleteIfiles()
%Opens each directory in the selected folder and then each directory within that folder
%and deletes all I.mat files within.  this is for removing I.mat
%files from the behavioral analysis folders.

directory=uigetdir('/Users/behavior/Desktop/Behavior/')
cd(directory)
file=dir();
%pwd
for(i=4:length(file))
    
    cd(directory)
    if(file(i).isdir)
        cd([directory '/' file(i).name])
        %pwd
        file2=dir();
        for(j=4:length(file2))
            if(file2(j).isdir)
                [pwd '/' file2(j).name '/' file2(j).name 'Data/I.mat']
                delete([pwd '/' file2(j).name '/' file2(j).name 'Data/I.mat'])
            end
        end
    end
end
cd(directory)
return