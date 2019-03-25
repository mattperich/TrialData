%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [trial_data, signal_means] = centerSignals(trial_data,params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This will center (ie mean-subtract) any (or all) time varying signals
% for the provided TD. Nothing fancy.
%
%   Can provide signals as second input instead of params struct.
%
% INPUTS:
%   trial_data : the struct
%   params     : parameter struct
%       .signals     :  which signal(s) to center
%       .use_trials  :  which trials to  use  for centering (default all)
%
% OUTPUTS:
%   trial_data  : the struct with centered signals
%   signal_means : cell array of means vectors for all signals
%
% Written by Matt Perich. Updated March 2019.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
signals     =  getTDfields(trial_data,'time');
use_trials  =  [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
verbose = false;
if nargin > 1
    if isstruct(params)
        assignParams(who,params);
    else
        signals = params;
    end
else
    signals = getTDfields(trial_data,'time');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
signals = check_signals(trial_data,signals);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(use_trials) || (ischar(use_trials) && strcmpi(use_trials,'all'))
    use_trials = 1:length(trial_data);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

signal_means = cell(1,size(signals,1));
for iSig = 1:size(signals,1)
    m = mean(getSig(trial_data,signals(iSig,:)),1);
    for trial = use_trials
        temp = getSig(trial_data(trial),signals(iSig,:));
        trial_data(trial).(signals{iSig,1}) = temp - repmat(m,size(temp,1),1);
    end
    signal_means{iSig} = m;
end
