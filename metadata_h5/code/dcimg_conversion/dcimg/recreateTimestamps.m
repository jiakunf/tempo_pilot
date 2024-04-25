function [timestampPath,summary]=recreateTimestamps(filePath,varargin)
% HELP RECREATETIMESTAMPS.M
% Recreateing time stamps file that may have not been created due to problems with .exe file in June 2021. Accepting dcimg or h5 tiles in the preprocessed foledr. 
% SYNTAX
%[timestampPath,summary]= recreateTimestamps(filePath) - use 2, etc.
%[timestampPath,summary]= recreateTimestamps(filePath,'optionName',optionValue,...) - passing options using a 'Name', 'Value' paradigm frequently used by Matlab native functions.
%[timestampPath,summary]= recreateTimestamps(filePath,'options',options) - passing options as a structure.
%o
% INPUTS:
% - filePath - ...
%
% OUTPUTS:
% - timestampPath - ...
% - summary - %
% OPTIONS:
% - see below the section of code showing all possible input options and comments for their meaning. 

%
% HISTORY
% - 14-Jun-2021 10:19:25 - created by Radek Chrapkiewicz (radekch@stanford.edu)

%% OPTIONS (type 'help getOptions' for details)
options=struct; % add your options below 


if nargin>=2
options=getOptions(options,varargin(1:end)); % CHECK IF NUMBER OF THE OPTION ARGUMENT OK!
end
summary=initSummary(options);


%% CORE

switch getExt(filePath)
    case '.dcimg'
        timestampPath=genTimestamps(filePath);
    case '.h5'
        filePathDcimg = findDCIMG(filePath);
        timestampPath=genTimestamps(filePathDcimg);
        [folder,fname,ext]=fileparts(timestampPath);
        expFolder=fullfile(fileparts(filePath),'LVmeta');
        newPathTimestamps=fullfile(expFolder,[fname,ext]);
        copyfile(timestampPath,newPathTimestamps);
        if isfile(newPathTimestamps)
            timestampPath=newPathTimestamps;
        end
    otherwise 
        error('Format not supported');
end
              
        


%% CLOSING
summary=closeSummary(summary);
end  %%% END RECREATETIMESTAMPS
