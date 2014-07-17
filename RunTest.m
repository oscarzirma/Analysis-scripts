
function [loadfile,loadbackground,loadbinary,loadpellet]=RunTest(loadfile,loadbackground,loadbinary,loadpellet)

if(strcmp(loadfile,'LoadFileOff'))
    loadfile=0;
else 
    loadfile=1;
end
if(strcmp(loadbackground,'LoadBackgroundOff'))
    loadbackground=0;
else
    loadfile=1;
end
if(strcmp(loadbinary,'LoadBinaryOff'))
    loadbinary=0;
else
    loadfile=1;
end
if(strcmp(loadpellet,'LoadPelletOff'))
    loadpellet=0;
else
    loadpellet=1;
end
return