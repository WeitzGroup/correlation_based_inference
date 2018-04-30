% Every figure script runs this script first. Sets plot sizing and
% save/load directories.

% plot sizing
L = 2; % plot size
lw = .75; % linewidth
fs = 6; % fontsize
Fs = 1.5*fs; % big fontsize for labels
dL = L/10; % plot spacing
fL = 1/3; % font margins
cL = L/11; % colorbar width
bL = L/20; % colorbar spacing
ms = 3; % markersize
aL = L/2; % arrow spacing

% data directories and filepaths
save_dir = 'manuscript'; % save directory
qID = 3; % ID of example networks to show
