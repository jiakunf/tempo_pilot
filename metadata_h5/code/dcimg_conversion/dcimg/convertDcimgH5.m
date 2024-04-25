function [h5filePath,summary]=convertDcimgH5(filePath,varargin)
% HELP CONVERTDCIMGH5.M
% Converting dcimg file to h5 file. On default creates a converted file in the 'Preprocessed' folder.
% Function created to handle Multiscope files in the first place which is
% reflected by default options keeping the uint16 and small binning format;
% SYNTAX
%[h5filePath,summary]= convertDcimgH5(filePath) 
%[h5filePath,summary]= convertDcimgH5(filePath,'optionName',optionValue,...) - passing options using a 'Name', 'Value' paradigm frequently used by Matlab native functions.
%[h5filePath,summary]= convertDcimgH5(filePath,'options',options) - passing options as a structure.
%
% INPUTS:
% - filePath - file path to DCIMG file
%
% OUTPUTS:
% - h5path - created h5 file
% - summary - extra outputs
% OPTIONS:
% - see below the section of code showing all possible input options and comments for their meaning. 

% HISTORY
% - 14-Apr-2021 02:42:16 - created by Radek Chrapkiewicz (radekch@stanford.edu)
% - 2021-05-17 14:09:17 - overwriting  RC

%% OPTIONS (type 'help getOptions' for details)
options=struct; % add your options below 
options.binning=2; % automatic applied binning for downsizing of dcimg
options.minBinRows=800; % movie needs to have at least this number of rows to qualify for binning
options.class='uint16'; % converting to the following format 
options.maxRAM=0.05;
options.toPreprocessed=true; % creating a mirrored Preprocessed folder structure
options.overwrite=false;

%% VARIABLE CHECK 

if nargin>=2
options=getOptions(options,varargin(1:end)); % CHECK IF NUMBER OF THE OPTION ARGUMENT OK!
end
summary=initSummary(options);


%% CORE

%% seting up folder and file name
[folderIn,fileName,ext]=fileparts(filePath);
if contains(folderIn,'\Raw\') && options.toPreprocessed
    folderOut=strrep(folderIn,'\Raw\','\Preprocessed\');
    mkdirs(folderOut);
else
    folderOut=folderIn;
end
h5filePath=fullfile(folderOut,[fileName,'.h5']);

if ~options.overwrite
    if isfile(h5filePath)
        disps('h5 file already exists. terminating')
        summary=closeSummary(summary);
        return;
    end
end

%% actual convertion

metaDCIMG=infoDCIMG(filePath);
nrows=metaDCIMG.frameSize(1);
if nrows>=options.minBinRows
    binning=options.binning;
else
    binning=1;
end

optionsDCIMG.binning=binning; % replacing previous scale_factor
optionsDCIMG.outputType=options.class; %'uint16' % - 2021-04-14 02:59:29 -   RC
optionsDCIMG.cropROI=[];
% ADVANCED: not recommended to change unless you are sure what you are doing:
optionsDCIMG.chunkSize=[]; % on default empty and not overwriting the one found based on the available RAM size
optionsDCIMG.maxRAM=options.maxRAM; % relative, factor outomatically adjusting the chunk size based on the available amount of RAM
optionsDCIMG.parallel=false;

% Control display
optionsDCIMG.verbose=false;
optionsDCIMG.imshow=false; % for displaying the first frame after loading, disable on default

% Export data
optionsDCIMG.h5path=h5filePath; % if not empty doing convertion into h5 file instead of loading to memory (obsolete and deleted: optionsDCIMG.saveh5 = false ) RC
optionsDCIMG.dataset='mov';

disps('Loading chunks');
[movie,summary.loadDCIMGchunks]=loadDCIMGchunks(filePath, [],'options',optionsDCIMG);

disps('Adding extra metadata');


[fps,nDroppedFrames]=getFps1p(filePath,'dropError',false);
h5save(h5filePath,fps);
h5save(h5filePath,nDroppedFrames);


h5addmeta(h5filePath,metaDCIMG);

disps('Done');

% winopen(fileparts(h5filePath));


%% CLOSING
summary=closeSummary(summary);
end  %%% END CONVERTDCIMGH5
