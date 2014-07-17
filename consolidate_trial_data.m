function consolidate_trial_data(varname,file_prefix,fname_data,trial_counter,delete_files)
%this function will consolidate all of the files of a given prefix from one
%to trial_counter into a given file with the name prefix. It only works
%with mat files that contain only a single variable. Container is the file
%into which all of the new files should be placed, generally a cell array
%of size trial_counter

eval([varname '=cell(trial_counter,1);']);

for i=1:trial_counter
    if exist([fname_data file_prefix num2str(i) '.mat'],'file')
        s=load([fname_data file_prefix num2str(i) '.mat']);
        f=fieldnames(s);
        eval([varname '(i)={s.(f{1})};']);
        if delete_files
            delete([fname_data file_prefix num2str(i) '.mat']);
        end
    end
    
end
save([fname_data varname],varname );