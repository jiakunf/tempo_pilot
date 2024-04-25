function [datasetInd,infoH5]=isH5Dataset(h5filepath,datasetName)
% HELP ISH5DATASET.M
% Checking if dataset exists in h5 file (used by h5append function).
% returns 0 if does not exist
% returns positive integer with the index of corresponding h5 dataset
% SYNTAX
%[datasetInd,summary]= isH5Dataset(h5filepath,datasetName)
%
% INPUTS:
% - h5filepath - file path
% - datasetName - e.g. '\mov' or 'mov'
%
% OUTPUTS:
% - datasetInd - 0 if doesn't exist positive intiger if exists 
% - summary - %


% HISTORY
% - 20-06-14 02:43:56 - originally created within h5append by Radek Chrapkiewicz (radekch@stanford.edu
% - 27-Apr-2021 15:39:51 - made a standalone function RC



infoH5=h5info(h5filepath);
datasetInd=0; % not exist - on default

if datasetName(1)=='/'
    datasetName=datasetName(2:end);
end

for ii=1:length(infoH5.Datasets)
    if strcmp(infoH5.Datasets(ii).Name,datasetName)
        datasetInd=ii;
        break;
    end
end
        

end