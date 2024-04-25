function [movie,metadata,summary]=h5loadMovie(filePath,frameRange)
% HELP H5LOADMOVIE.M
% Simple, higher level wrapper for h5load for loading movies from h5 files independently on their structures.
% SYNTAX
% [movie,metadata,summary]=h5loadMovie(filePath)
%
% INPUTS:
% - filePath - path to h5 file
% - framerange* - optional frame range (standard parsing)
%
% OUTPUTS:
% - movie - matrix 
% - metadata - structure with extra datasets stored in h5

% HISTORY
% - 06-Feb-2021 17:42:11 - created by Radek Chrapkiewicz (radekch@stanford.edu)
% - 2021-05-17 16:03:43 - added summary  RC

options.dataset='/mov';
summary=initSummary(options);

if nargin<=1
    frameRange=[];
end

metadata=h5readmeta(filePath);
movieSize=h5moviesize(filePath);

[movie,summary.h5readchunk]=h5readchunk(filePath,frameRange,'dataset',options.dataset);



summary.frameRangeOut=parseFrameRange(frameRange,movieSize(3));
disps('H5 movie loaded');

summary=closeSummary(summary);

% obsolete implementation:% - 2021-03-24 08:45:56 -   RC
% metadata=[];
% movie=h5load(filePath);
% 
% if isstruct(movie)
%     metadata=movie;
%     movie=movie.mov;
%     metadata.mov='Copied to separate variable with "h5loadMovie" function'; % erasing from the structure to save memory
% end

end  %%% END H5LOADMOVIE