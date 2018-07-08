function out = processNSx(filename,signal_info)
% if isfield(signal_info,'params')
%     warning('no parameters supported for processNSx now...')
% end

NSx = openNSx_td(filename,'read');

% strip whitespace from labels
labels = {NSx.ElectrodesInfo.Label};
for i = 1:length(labels)
    temp = uint16(labels{i});
    labels{i} = labels{i}(temp ~= 0);
end

out.t = 0:1/NSx.MetaTags.SamplingFreq:NSx.MetaTags.DataDurationSec-1/NSx.MetaTags.SamplingFreq;
out.data = NSx.Data';
out.labels = labels;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%