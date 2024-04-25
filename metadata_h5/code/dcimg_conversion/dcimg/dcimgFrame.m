function [frame,totalframes]=dcimgFrame(filePath,iFrame)
% HELP DCIMGFRAME.M
% The simplest load of a single frame from a dcimg file without dependencies (apart from MEX).
% SYNTAX
% [frame]=dcimgFrame(filePath) % loading first frame
% [frame]=dcimgFrame(filePath,iFrame)
%
% INPUTS:
% - filePath - path to dcimg 
% - iFrame* - frame to load
%
% OUTPUTS:
% - frame - 2D matrix

% HISTORY
% - 31-Mar-2021 01:15:59 - created by Radek Chrapkiewicz (radekch@stanford.edu)

if nargin==1
    iFrame=1;
end

startframe=int32(iFrame-1);
[frame,totalframes]=  dcimgmatlab(startframe, filePath); % that's the mex file that should be on a path
frame=frame';


