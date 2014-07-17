function deletePNG(avi)
%Opens each directory in the selected folder and then each directory within that folder
%and deletes all *.png files within. if it is passed a '1' in the avi input it will also delete all
%*.avi files in the second directory. this is for removing avi and png
%files from the behavioral analysis folders.

directory=uigetdir('/Users/behavior/Desktop/Behavior/')
cd(directory)
file=dir();
pwd
for(i=4:length(file))
    
    cd(directory)
    if(file(i).isdir)
        cd([directory '/' file(i).name])
        pwd
        if(avi)
            delete('*.avi')
        end
        delete('*.png');
        file2=dir();
        for(j=1:length(file2))
            if(file2(j).isdir)
                delete([pwd '/' file2(j).name '/*.png'])
            end
        end
    end
end
cd(directory)
return