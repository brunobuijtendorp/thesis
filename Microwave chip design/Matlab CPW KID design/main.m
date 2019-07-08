%% Initialize
clear variables;
clc;

script_name = 'main.m';
output_filename = 'mask';

script_path = which(script_name);
script_dir = script_path(1:end-length(script_name));
addpath(strcat(script_dir,'functions'));
addpath(strcat(script_dir,'data'));

%% Set parameters for readsonnetCoupler
% Parameter values for readsonnetCoupler
filenames = ["190617_1", "190617_3", "190617_9"];
psort = [5 4 4];  % Selects which parameter is the coupler length
numparam = 5;  % total # of parameters of the CSV Sonnet file
numheaders = [1, 2, 2]; 

%% Set mask design parameters
% Select KID design
design_Q = 2;

% Set desired Q
Q = 1E3 * [3 10 30 30 30];  % one number for same Lc for all KIDs or array = 

% Size multipliers of the Sonnet model
size_multiplier = [1 3 9]; % Multiplier for different coupler line and gap widths

%% Output mask designs
for i = 1:3
    % Read Sonnet data
    filename = filenames{i};
    numheaders_i = numheaders(i);
    psort_i = psort(i);
    Qdesign = readsonnetCoupler(filename, psort_i, numparam, numheaders_i);
    % Output mask file
    size_multiplier_i = size_multiplier(i);
    output_filename_i = strcat(output_filename,'_',int2str(size_multiplier_i));
    MaskGeneral_V1(design_Q, Qdesign, Q, strcat(script_dir, 'output'), output_filename_i, size_multiplier_i);
end