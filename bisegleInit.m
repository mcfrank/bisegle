% init (by ADN)
function bisegleInit
clear;

% Name the paths. Store the path names in a struct variable, "thePath".
thePath.start =  pwd;
thePath.script = [thePath.start '/scripts/'];
thePath.stim = [thePath.start '/stim/'];
thePath.data = [thePath.start '/data/'];
thePath.core = [thePath.start '/core/'];
% Add relevant paths. These paths are necessary for the experiment, but
% will not be saved permanently.
addpath(thePath.start);
addpath(thePath.script);
addpath(thePath.stim);
addpath(thePath.data);
addpath(genpath((thePath.core)));
