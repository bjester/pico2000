%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filename:    PS2000Config.m
%
% Copyright:   Pico Technology Limited 2013 - 2014
%
% Author:      HSM
%
% Description:
%   
%   Contains configuration data for setting parameters for a PicoScope 2000
%   Oscilloscope device.
%
%   Run this script in the MATLAB environment prior to connecting to the 
%   device.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SETUP PATH
% Set paths according to the operating system and architecture.
% For Windows and Mac-based versions of MATLAB, it is recommended to copy 
% the driver files into the the sub-folder corresponding to the 
% architecture e.g. win32 for 32-bit versions of MATLAB.
% For Linux versions of MATLAB, please follow the instructions to install
% the libps2000 and libpswrappers packages from http://www.picotech.com/linux.html

% Add libps2000 and MATLAB lib to path
addpath(genpath('./libps2000'));
addpath(genpath('./lib'));

% Identify architecture
archStr = computer('arch');

if ~isdir(archStr)
  mkdir(archStr);
end

cd(archStr);
copyfile('../libps2000/include/*.h', './');

% Create M files and thunk files
[ps2000NotFound, ps2000Warnings] = loadlibrary('libps2000', 'libps2000.h', ...
  'mfilename', 'ps2000MFile.m', 'alias', 'ps2000');

[ps2000WrapNotFound, ps2000WrapWarnings] = loadlibrary('libps2000Wrap', ...
  'libps2000Wrap.h', 'mfilename', 'ps2000WrapMFile.m', 'includepath', './',...
  'alias', 'ps2000Wrap');

cd ../

try

  addpath(strcat('./', archStr, '/'));
    
catch err
    
  error('Operating system not supported: please contact support@picotech.com');
    
end


%% LOAD ENUMS AND STRUCTURES

[ps2000Methodinfo, ps2000Structs, ps2000Enuminfo, ps2000ThunkLibName] = ps2000MFile;

%% PICOSCOPE SETTINGS
% Define Settings for PicoScope 2000 series.

% Channel Settings
% ----------------

% Channel A
channelSettings.channelA.enabled = PicoConstants.TRUE;
channelSettings.channelA.dc = PicoConstants.TRUE;
channelSettings.channelA.range = ps2000Enuminfo.enPS2000Range.PS2000_1V;

% Channel B
channelSettings.channelB.enabled = PicoConstants.TRUE;
channelSettings.channelB.dc = PicoConstants.TRUE;
channelSettings.channelB.range = ps2000Enuminfo.enPS2000Range.PS2000_2V;

% Simple Trigger settings
% -----------------------

% Delay and Auto Trigger are defined as Instrument Driver Trigger Group
% Properties
simpleTrigger.source = ps2000Enuminfo.enPS2000Channel.PS2000_CHANNEL_A; % Set to PS2000_NONE to disable
simpleTrigger.threshold = 500;
simpleTrigger.direction = ps2000Enuminfo.enPS2000TriggerDirection.PS2000_RISING;

% Advanced Trigger settings % TBD
% -------------------------------

% Signal Generator settings
% -------------------------

% General Signal Generator
sigGen.offsetVoltage    = 500;  %mv
sigGen.pkToPk           = 2000; %mv
sigGen.sweepType        = ps2000Enuminfo.enPS2000SweepType.PS2000_UP;
sigGen.sweeps           = 0;

% Built In 
sigGen.builtIn.waveType = ps2000Enuminfo.enPS2000WaveType.PS2000_SINE;
sigGen.builtIn.increment = 500;         % Hz
sigGen.builtIn.dwellTime = 1;           % seconds

% AWG Specific
% ------------

% Create a sin(x) + sin(2x) wave

x = [0:(2 * pi)/ (PicoConstants.AWG_BUFFER_4KS - 1):2 * pi];
y = sin(x) + sin(2*x);

% Normalise the wave
sigGen.awg.waveform = normalise(y);
clear x;
clear y;
