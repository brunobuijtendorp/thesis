%function select_Classicdesign(design_Q)
function [Qdesign, coupL, coupG, tlgap, tlwidth, td, eps_sub] = select_Classicdesign(design_Q, Qdesign_in, size_multiplier)
Qdesign = Qdesign_in;
% creates all parameters to get the KID coupler length for a given SONNET
% design. Use readsonnetCoupler.m after doing SONNET sims to get the
% Qdesign matrices in this script to add a Qdesign
%
% NB: Coupler length is defined as the TOTAL length of the central line,
% incl vertical piece
%
% INPUT: 
% design_Q number describing the coupler design
% = 1: Si 6-10- KID on 8-20-8 Tline using 100 nm NbTiN 
% rest to be added


if design_Q == 1
%Coupler design for 10-6-10 ellbow coupler on line 8-20-8 (best 50 Ohm) on Si of 100 nm NbTiN, 1 pH/square 
% data = log_10(Qfactor), Qfactor=pi/2*10^(-S21dB/10)
%Silicon with eps=11.44
%NB: Coupler length is defined as the TOTAL length of the central line,
%incl vertical piece

% Qdesign = ...
%     [0,10,20,30,40,60,80,100,130,170,210,250,290,350,450,550;
%     2,7.24051794100000,6.98868794100000,6.79338794100000,6.63393794100000,6.38250794100000,6.18756794100000,6.02836794100000,5.83367794100000,5.62767794100000,5.46145794100000,5.32203794100000,5.20165794100000,5.04742794100000,4.83935794100000,4.67129794100000;
%     3,6.88824794100000,6.63639794100000,6.44109794100000,6.28163794100000,6.03019794100000,5.83524794100000,5.67603794100000,5.48131794100000,5.27527794100000,5.10899794100000,4.96952794100000,4.84910794100000,4.69481794100000,4.48658794100000,4.31841794100000;
%     4,6.63823794100000,6.38637794100000,6.19106794100000,6.03159794100000,5.78014794100000,5.58517794100000,5.42595794100000,5.23120794100000,5.02509794100000,4.85873794100000,4.71917794100000,4.59871794100000,4.44435794100000,4.23588794100000,4.06757794100000;
%     5,6.44424794100000,6.19237794100000,5.99704794100000,5.83756794100000,5.58609794100000,5.39111794100000,5.23186794100000,5.03706794100000,4.83088794100000,4.66441794100000,4.52475794100000,4.40423794100000,4.24977794100000,4.04102794100000,3.87252794100000;
%     6,6.28568794100000,6.03378794100000,5.83843794100000,5.67893794100000,5.42744794100000,5.23245794100000,5.07317794100000,4.87832794100000,4.67205794100000,4.50544794100000,4.36566794100000,4.24507794100000,4.09049794100000,3.88138794100000,3.71268794100000;
%     7,6.15154794100000,5.89962794100000,5.70425794100000,5.54473794100000,5.29321794100000,5.09820794100000,4.93889794100000,4.74398794100000,4.53759794100000,4.37084794100000,4.23090794100000,4.11024794100000,3.95553794100000,3.74601794100000,3.57707794100000;
%     8,6.03528794100000,5.78333794100000,5.58793794100000,5.42839794100000,5.17684794100000,4.98180794100000,4.82247794100000,4.62748794100000,4.42096794100000,4.25403794100000,4.11393794100000,3.99318794100000,3.83832794100000,3.62835794100000,3.45915794100000];

coupL       = 10;	%coupler line
coupG       = 6;  	%coupler gap
td          = 6; 	%metal strip between coupler and through line
tlgap       = 8;    %tline
tlwidth     =20;    %tlinegap
eps_sub     = 11.44;
disp('Si 6-10-6 KID on 8-20-8 Tline')
end

% Regular design
if design_Q == 2
    coupL = 3 * size_multiplier;	%coupler line
    coupG = 2 * size_multiplier;  	%coupler gap
    td = 3; 	%metal strip between coupler and through line
    tlgap = 8;    %tline
    tlwidth = 20;    %tlinegap
    eps_sub = 8; % 10 = a-Si
    
% 9x sized KID high Q design (larger td)
elseif design_Q == 3
    coupL = 3 * size_multiplier;	%coupler line
    coupG = 2 * size_multiplier;  	%coupler gap
    td = 32; 	%metal strip between coupler and through line
    tlgap = 8;    %tline
    tlwidth = 20;    %tlinegap
    eps_sub = 8; % 10 = a-Si
% 1x sized KID high Q design (larger td)
elseif design_Q == 4
    coupL = 3 * size_multiplier;	%coupler line
    coupG = 2 * size_multiplier;  	%coupler gap
    td = 6; 	%metal strip between coupler and through line
    tlgap = 8;    %tline
    tlwidth = 20;    %tlinegap
    eps_sub = 8; % 10 = a-Si
% 3x sized KID high Q design (larger td)
elseif design_Q == 5
    coupL = 3 * size_multiplier;	%coupler line
    coupG = 2 * size_multiplier;  	%coupler gap
    td = 16; 	%metal strip between coupler and through line
    tlgap = 8;    %tline
    tlwidth = 20;    %tlinegap
    eps_sub = 8; % 10 = a-Si    
else
    error('not implemented IDC')
end


end