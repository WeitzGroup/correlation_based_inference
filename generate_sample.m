function [sample, info] = generate_sample(fp_ts, fp_sample, initial_hrs, freq_hrs, numsamples)
% Samples an existing timeseries at specified frequency and saves in a new
% .mat file.
%   fp_ts - filepath of the existing timeseries (.mat file)
%   fp_sample - desired filepath of the sample (.mat file)
%   initial_hrs - initial sample time in hours
%   freq_hrs - sampling frequency in hours
%   numsamples - number of timepoints to sample
% The duration of the sample is freq_hrs*numsamples.

load(fp_ts);

% convert sampling times (hours) to indices
si = floor(initial_hrs/24/info.dt)+1; % start sampling at this index
ds = floor(freq_hrs/24/info.dt); % skip this many indices

if ds == 0
    fprintf('warning: sample frequency adjusted');
    ds = 1;
end

sf = ds*numsamples+si; % the end index;
sf_double = 2*ds*numsamples+si;

sID = si:ds:sf;
sID_double = si:ds:sf_double;

% go through the timeseries and sample
    sample.t = dyn.t(sID_double);
    sample.H = dyn.H(sID_double,:);
    sample.V = dyn.V(sID_double,:);
    
    initial_hrs_actual = sample.t(1)*24;
    freq_hrs_actual = (sample.t(2)-sample.t(1))*24;
    length_hrs_actual = (sample.t(length(sID))-sample.t(1))*24;

info.fp_sample = fp_sample;
info.initial_hrs = initial_hrs;
info.freq_hrs = freq_hrs;
info.numsamples = numsamples;
info.initial_hrs_actual = initial_hrs_actual;
info.freq_hrs_actual = freq_hrs_actual;
info.length_hrs_actual = length_hrs_actual;
info.numsamples_actual = length(sID);
info.initial_ID = si;
info.end_ID = sf;
info.freq_ID = ds;
info.sID = sID;
info.sID_double = sID_double;
save(fp_sample,'sample','info');

end