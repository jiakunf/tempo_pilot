clearvars -except cont NT BITI JIT goEXP minITI maxITI lambda

%%  Code to Prime Stimulus Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Stuff to manually change for the stimuli
%--------------------
% Gabor information
%--------------------
% Obvious Parameters
orientation = 45;% in degrees, the angle of the lines.
aspectRatio = 1.0;
phase = 0;
direction = 'R';
% Change the temporal frequency of the drifting gradient
desiredfrequency = 4;
% Spatial Frequency (Cycles Per Pixel)
% One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
numCycles = 8;  % change the spatial frequency of the stimuli
%contrasts = [1 .75 .5 .25  .125  .0625 .03125 .015625 .0078125 .00390625];
contrasts = [1.00  .9 .85 .75 ];
% TMM0001
%contrasts = [.12  .10 .08 .063 .055 .049 .044 .04 .03 .025 .01 0];
%contrasts = [.10 .075 .05 .04 .036 .033 .03   .0225 .015  0];

%contrasts = [100 .75 .5 .25  .1875 .125 .09375 .0625 .03125 .015625 0];
%contrasts = [.25  .1875 .125 .09375 .0625 .05 .04 .03125 .015625 0];
%contrasts = [ .175 .125 .09375 .0625 .05 .04 .03125 .023438 .015625 0];
%contrasts = [   .125  .09375  .075 .0625 0.055 .05 0.045 .04 .03125 .023438 .015625 0];
%contrasts = [ 0.075 .06   .05 0.045 .04 0.035 .03 0.025  .02 .015  0.01 0];
%contrasts = [ 0.1  0.0796 .0631  .0501 0.0398  0.0316 .0251 0.02  .0158 .0126  0.01 0];
%%contrasts = [ 0.1  0.075  .050 0.04 0.0325 .0275  .025  0.02  .015  .0125  0.01 0];
%contrasts = [ 0.09  0.075 .06  .05 0.04  0.035 .03 0.025  .02 .015  0.01 0];
%contrasts = [.06  .05  .04 .035 .03 .0275 .025 .0225 .02 .015 .01 0]; % contrast for male
%contrasts = [.09 .08 .07 .0625 .055 .05 .045 .04 .0325 .025 .015 0]; % contrast for female
%contrasts = [.15  .085  .0625 .04 .03  .025  .02 .015 .01 0]; % contrast for fem
%contrasts = [.045 .04 .035 .03 .025 .0225 .02 .0175 .015 .0125 .01 .005];  %M1
%contrasts = [.045 .04 .035 .0325 .03 .0275 .025 .0225 .02 .0175 .015 .01]; % M2
%contrasts = [.0228 .0201 .0156 .011 .0084];  %M1
%contrasts = [0.0333 0.0314 0.0281 0.0248 0.023]; % M2
%contrasts = [1  .5 .25  .125  .03125  .0078125 0];
%contrasts = [1  .5 .25  .125  0];
%contrasts = [1];
% RFM001 contrasts
%contrasts = [.0825 .0687 .0525 .0337 .0313 .0293 .0276 .026 .01 0];
%contrasts = [.0825 .065 .045 .035 .0325 .03 .028 .026 .01 0];
% RFM002 contrasts
%contrasts = [.0825 .0687 .0525  .0473 .0399 .0339 .0284 .02 .0175  .013 .01 0];
%contrasts = [.066 .0530 .04  .027 .0256 .0245 .0234 .0225 .01 0];
% RFM003 contrasts
%contrasts = [.0825 .0687 .0525 .0423 .0385  .0323 .0295 .025 .02 .015 .01 0];
%contrasts = [.066 .0530 .04  .03 .0294 .0288 .0282 .0276 .01 0]];

% RMM001 contrasts
 %contrasts =  [.09 .075 .065  .05  .045 .04 .0375 .035 .02 0];
% RMM002 contrasts
% contrasts = [.09 .075 .065  .05  .045 .04 .0375 .035 .02 0];


go = 1;
maxc = round(numel(contrasts)/2);
%%  To be run of not using exponential
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code will randomize the order of contrasts being presented
[RandomizedTrials]=RandomizeTrials_Psuedo_function(contrasts,NT,'n');

% This code will generate inter trial intervals with either random jitter
% or based on an exponential distribution
if goEXP < 1
     jit = JIT;
     jitter = rand(1,NT);
     jitter = 2*jit*(jitter- .5);
     ITIbase = BITI;
     intervals = [ones(1,NT)*ITIbase];
     intervals = intervals + jitter;
elseif goEXP > 0
     intervals = exponentialITI(1/lambda, minITI, maxITI, NT);
end

%%  Prep the stimulus presentation software
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('Preference', 'SkipSyncTests', 1);
sca;
close all;
% Setup PTB with some default values
PsychDefaultSetup(2);
% Set the screen number to the external secondary monitor if there is one connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open the screen & define it's dimensions
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey,...
    [], 32, 2, [], [], kPsychNeedRetinaResolution);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);

% Get the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', window);

% Set maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);


% Build a procedural gabor texture (Note: to get a "standard" Gabor patch
% we set a grey background offset, disable normalisation, and set a
% pre-contrast multiplier of 0.5).
% Dimension of the region where will draw the Gabor in pixels
gaborDimPix = windowRect(3);
% Sigma of Gaussian  (how much to fade around the edges)
sigma = gaborDimPix / 0;  % change the 0 value to alter the fading
phasePerFrame = desiredfrequency*360*ifi;
freq = numCycles / gaborDimPix;

backgroundOffset = [0.5 0.5 0.5 0.0];
disableNorm = 1;
preContrastMultiplier = 0.5;
gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, [],...
    backgroundOffset, disableNorm, preContrastMultiplier);

% Randomise the phase of the Gabors and make a properties matrix.
for N = 1:numel(contrasts)
propertiesMat{1,N} = [phase, freq, sigma, contrasts(N), aspectRatio, 0, 0, 0];
end

iiii = 1;
cchoice = RandomizedTrials(iiii);
cont2 = contrasts(cchoice);
pm = propertiesMat{1,1};
curtrial = 0;

%%  Build up the rectangles for the pause and hold screen
baseRect = [0 0 screenXpixels screenYpixels];
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);
rectColorB = [0 0 0];
rectColorG = [128 128 128]/255;

%%  Finalize the trial data and orders
stim_id = [ones(1,NT)*1];
reward = [ones(1,NT)*1];
meanITI = nanmean(intervals);
rand_idx1 = randperm(NT);
rand_idx2 = randperm(NT);
intervals = intervals(rand_idx2);
stim_id = stim_id(rand_idx2);
reward = reward(rand_idx2);
%%  All Done!
%  indicate that the necessary preloading of data has been completed.
stim_loaded = 1;

%%  Present the stimuli
%------------------------------------------
%    Draw stuff - button press to exit
%------------------------------------------

% FLip to the vertical retrace rate
vbl = Screen('Flip', window);
curtrial= curtrial + 1;
% We will update the stimulus on each frame
waitframes = 1;
pm = propertiesMat{1,cchoice};
frameCounter = 0;
tic
while  frameCounter < round(VSD/ifi)%~KbCheck
frameCounter = frameCounter + 1;
    % Draw the Gabor. By default PTB will draw this in the center of the screen
    % for us.
   
    Screen('DrawTextures', window, gabortex, [], [], orientation, [], [], [], [],...
        kPsychDontDoRotation, pm');

    % Flip to the screen
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    % Update the phase element of the properties matrix (we could if we
    % want update any or all of the properties on each frame. Here the
    % Gabor will drift to the left.
    %propertiesMat(1) = propertiesMat(1) + phasePerFrame;
 
     if direction == 'L'
          pm(1) = pm(1) + phasePerFrame;
     elseif direction =='R'
          pm(1) = pm(1) - phasePerFrame;
     end

end
Time(curtrial,1) = toc;
Time(curtrial,2) = frameCounter;
Time(curtrial,3) = pm(4);
vbl = Screen('Flip', window);