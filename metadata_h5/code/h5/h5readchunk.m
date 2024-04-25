function [movie,summary]=h5readchunk(fpath,framerange,varargin)
% HELP h5readchunk
% reading chunk of a movie
% SYNTAX
%[frame,summary]= h5readchunk(fpath,framerange) - use 3, etc.
%[frame,summary]= h5readchunk(fpath,framerange,'optionName',optionValue,...) - passing options using a 'Name', 'Value' paradigm frequently used by Matlab native functions.
%[frame,summary]= h5readchunk(fpath,framerange,'options',options) - passing options as a structure.
%
% INPUTS:
% - fpath - path to 
% - framerange - [first last], [maxframes] -  help parseFrameRange for the
% exact syntax
%
% OUTPUTS:
% - movie - chunk of movie
% - summary - extra outputs
% OPTIONS:
% - see below the section of code showing all possible input options and comments for their meaning. 

% HISTORY
% - 30-Jun-2020 04:10:43 - created by Radek Chrapkiewicz (radekch@stanford.edu)
% - 2020-09-15 15:28:01 - parser for frame range RC
% - 2021-05-17 16:01:46 - outputing frame range  RC

%% OPTIONS 
options=struct; % add your options below 
options.dataset='/mov';

%% VARIABLE CHECK 

if nargin>=3
options=getOptions(options,varargin(1:end)); % CHECK IF NUMBER OF THE OPTION ARGUMENT OK!
end
summary=initSummary;
summary.inputOptions=options; % saving orginally passed options to output them in the original form for potential next use

%% CORE
%The core of the function should just go here.
msize=h5moviesize(fpath,'dataset',options.dataset);
framerange_lim=parseFrameRange(framerange,msize(3));
nframes=framerange_lim(2)-framerange_lim(1)+1;
movie=h5read(fpath,options.dataset,[1,1,framerange_lim(1)],[msize(1:2),nframes]);

summary.frameRangeOut=framerange_lim;


%% CLOSING
summary=closeSummary(summary);

end  %%% END H5FRAME
