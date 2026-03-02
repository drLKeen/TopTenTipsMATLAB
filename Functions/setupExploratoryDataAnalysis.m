function setupExploratoryDataAnalysis
% 
% setupExploratoryDataAnalysis downloads data for this course.
%
dataZIP = "StormEvents.zip";   
dataURL = "https://www.mathworks.com/supportfiles/" + ... 
            "practicaldsmatlab/weather_events/StormEvents.zip";

% Get the location of this script 
[fileFolder,~,~] = fileparts(mfilename('fullpath'));

dataFolder = fileFolder; 

% Use the code below if the zip file does not contain the same folder name
% % Get the name of the zip file (without .zip) 
% [~,dataFolderName,~] = fileparts(dataURL); 
% % Create a data folder inside the location of this script 
% dataFolder = fullfile(fileFolder,dataFolderName); 


%% 
% Check if the zip file already exists. If it does not, try downloading it. 
% If it does, skip to unzip. 

if isempty(dir(dataZIP))
    fprintf("Downloading ""%s""...",dataZIP)
    try
        websave(dataZIP,dataURL);
    catch ME % Error on download failure
        fprintf("Failed\n");
        
        % Delete any possibly corrupt zip file 
        cleanUpOnError

        errorMsg = replace(ME.message,"\","\\");
        error("The setup could not be completed. The file """ + ...
            dataZIP + """ could not be downloaded successfully. " + ...
            "(""" + errorMsg + """)");
    end
end

%% 
% Try to unzip the data zip 

fprintf("Extracting ""%s""...",dataZIP)
try
    %Flights.zip contains Flights folder so use fileFolder not dataFolder
    unzip(dataZIP,dataFolder); 
catch ME
    fprintf("Failed\n")
    % Delete the zip file 
    disp("Deleting """ + dataZIP + """")
    cleanUpOnError 
 
    % Show error
    errorMsg = replace(ME.message,"\","\\");
    error("The setup could not be completed because the " + ...
        "file """ + dataZIP + """ could not be unzipped, and has " + ...
        "been deleted. Rerun this setup script to redownload the " + ...
        "zip file and try again. (" + errorMsg + ")");
end

% fprintf("Done\n")
%%
% Add the folders to the path and save it
fprintf("Setting up path...")
addpath(genpath(fileFolder)); 
savepath; 
fprintf("Done\n")
%% 
% That's it, we're all done!
disp("All setup tasks completed.")
disp(newline)

%%
% Error clean up function 
    function cleanUpOnError
        if ~isempty(dir(dataZIP))
            try
                delete(dataZIP); 
            catch 
                warning("""" + dataZIP +  """ could not be deleted. " + ... 
                    "Manually delete this file before running " + ...
                    "this setup script again.") 
            end
        end 
        
    end

end
%% 
% _Copyright 2022 The MathWorks, Inc._