%% Initialize
clear variables;
clc;

script_name = 'main.m';
output_filename = 'mask';

script_path = which(script_name);
script_dir = script_path(1:end-length(script_name));
addpath(strcat(script_dir,'functions'));
addpath(strcat(script_dir,'data/lossless'));

%% Set parameters for readsonnetCoupler
% Parameter values for readsonnetCoupler
filenames = ["190711_1_lossless", "190711_3_lossless", "190711_9_lossless"];
psort = [4 4 5];  % Selects which parameter is the coupler length
numparam = 5;  % total # of parameters of the CSV Sonnet file
numheaders = [2, 2, 2]; 

%% Set mask design parameters
% Select KID design
design_Q = 2;

% Set desired Q
Q =  {1E3 * [3 10 30 100 100], 1E3 * [3 10 30 50 50], 1E3 * [3 10 30 50 50]}; % one number for same Lc for all KIDs or array = 

% Size multipliers of the Sonnet model
size_multiplier = [1 3 9]; % Multiplier for different coupler line and gap widths

%
Fcenter_in = [6.5 5.5 4.5];
dF_in = 0.1;
KIDdistance_in = 1200;
kidheight_in = 1000;

%% Output mask designs
for i = 1:3
    KIDdistance_i = KIDdistance_in + 100 * 3^(i-1);
    kidheight_i = kidheight_in * 1.5^(i-1);

    % Read Sonnet data
    filename = filenames{i};
    numheaders_i = numheaders(i);
    psort_i = psort(i);
    Qdesign = readsonnetCoupler(filename, psort_i, numparam, numheaders_i);
    % Output mask file
    Q_i = Q{i}
    Fcenter_in_i = Fcenter_in(i);
    size_multiplier_i = size_multiplier(i);
    output_filename_i = strcat(output_filename,'_',int2str(size_multiplier_i));
    MaskGeneral_V1(design_Q, Qdesign, Q_i, strcat(script_dir, 'output'), output_filename_i, size_multiplier_i, Fcenter_in_i, dF_in, KIDdistance_i, kidheight_i);
end

%% Output mask design of Q = 100k, wide KID (5x identical because dF set to zero, just cut out one)
 
%Read Sonnet data
Q_i = 1E3 * [100 100 100 100 100]
filename = '190711_9_highQ_lossless';
 numheaders_i = 2;
 psort_i = 5;
 Qdesign = readsonnetCoupler(filename, psort_i, numparam, numheaders_i);
 % Output mask file
 Fcenter_in_i = Fcenter_in(3) +  0.1;
 dF_in = 0;
 size_multiplier_i = 9;
 design_Q = 3; % large distance to throughline design
 output_filename_i = strcat(output_filename,'_',int2str(size_multiplier_i),'_Q100k');
 MaskGeneral_V1(design_Q, Qdesign, Q_i, strcat(script_dir, 'output'), output_filename_i, size_multiplier_i, Fcenter_in_i, dF_in, KIDdistance_i, kidheight_i);
% 

%% Output mask design of Q = 100k, wide KID (5x identical because dF set to zero, just cut out one)
 
%Read Sonnet data
Q_i = 1E3 * [300 300 300 300 300]
filename = '190711_9_highQ_lossless';
 numheaders_i = 2;
 psort_i = 5;
 Qdesign = readsonnetCoupler(filename, psort_i, numparam, numheaders_i);
 % Output mask file
 Fcenter_in_i = Fcenter_in(3) + 0.2;
 dF_in = 0;
 size_multiplier_i = 9;
 design_Q = 3; % large distance to throughline design
 output_filename_i = strcat(output_filename,'_',int2str(size_multiplier_i),'_Q300k');
 MaskGeneral_V1(design_Q, Qdesign, Q_i, strcat(script_dir, 'output'), output_filename_i, size_multiplier_i, Fcenter_in_i, dF_in, KIDdistance_i, kidheight_i);
% 