%data from 1 port open ended IDC sim: SONNET: save SYZ parameter file, Z param, real - imag, spreadsheet
% format 
% input:
% NbTiN.lw = 12e-6;
% NbTiN.gap = 8e-6;
% NbTiN.t = 100e-9;
% NbTiN.length = 0.0001e-3;
% Alu.lw = 1e-6;
% Alu.gap = 1e-6;
% Alu.Rs = 0.004;
% Alu.t = 40e-9;
% Alu.length = 1e-3;
% epsDielectric = 11.44;
% FwantedGHz = 5;
%
% output
%
% WIDCneeded = the IDC with in mum
% line1 = fitted data of Widc(um) - Fres(GHz) so that WIDCneeded = feval(line1,FwantedGHz);
clear variables
close all
cd('/Users/jochem/ownCloud/KID/Technology_Experiment/TestedMatlabScripts/MaskDesign/subfiles/SONNETresults');
addpath(genpath('/Users/jochem/ownCloud/KID/Technology_Experiment/TestedMatlabScripts'));
file = 'Final_IDC1b';
nheader = 2;
[data,params]=readsonnetIDC(file,nheader,1);
Freq = data{1}(:,1)*1e9;
nplot = 11;%6

% start with line
% Only single params!
close all

NbTiN.lw = 20e-6;
NbTiN.gap = 4e-6;
NbTiN.t = 100e-9;
NbTiN.length = 0.11e-3;
Alu.lw = 1e-6;
Alu.gap = 1e-6;
Alu.Rs = 0.004;
Alu.t = 40e-9;
Alu.length = [ 0.8e-3];
epsDielectric = 11.44;
FwantedGHz = 5;
plotit = 1;


% process 2 line sections
%%%%% Alu line (L1)  %%%%%
[L1, C1] = Alulayer_simple(Alu.lw,Alu.gap,Alu.Rs,Alu.t,epsDielectric);
Alu.L = L1*Alu.length;        %Kinetic+geometric indutance
Alu.C = C1*Alu.length;           %Geometric capacitance
%%%%% NbTiN line (L2)  %%%%%
[L2, C2] = NbTiNlayer_simple(NbTiN.lw,NbTiN.gap,NbTiN.t,epsDielectric);
NbTiN.L = L2*NbTiN.length;        %Kinetic+geometric indutance
NbTiN.C = C2*NbTiN.length;           %Geometric capacitance
%%%%% L1+L2  %%%%%
Line.length = NbTiN.length + Alu.length;
Line.Ltot = Alu.L + NbTiN.L;             %total kinetic inductance Line1 + Line2
Line.Ctot = Alu.C + NbTiN.C;
Line.Lpermeter = Alu.L./Line.length + NbTiN.L./Line.length;%eff value, = L1 for pure Alu line (etc)
Line.Cpermeter = Alu.C./Line.length + NbTiN.C./Line.length;
%%%%% Getting Fres  %%%%%
Line.vpeff =  1./ ( Line.Lpermeter(1) .* Line.Cpermeter(1)).^0.5 ;%parameter is line length independent
Line.Zeff = (Line.Lpermeter(1) ./ Line.Cpermeter(1)).^0.5;%parameter is line length independent

Line.Betaeff = 2*pi * Freq ./ Line.vpeff;
Line.Fres_lineonly = 0.25*( 1./(Line.Ltot.*(Line.Ctot)) ).^0.5;%rami 3.1 to check

Line.Zin = 1j*Line.Zeff * tan((2*pi.*Freq/Line.vpeff) * Line.length);



%% plot
figure(1)
clf
plot(Freq/1e9,-data{nplot}(:,3),'.r','markersize',6);hold on;
legstr{1} = ['IDC1b = ' num2str(params(nplot))];
xlim([2 8]);ylim([0 60]);
MakeGoodFigure(10,7,15);
%
Cs = 1.35e-3;
Ls = 0.2;
s = fitoptions('Method','NonlinearLeastSquares', 'Startpoint',[Cs Ls], 'MaxFunEvals',1000,'Robust','On');
%ftype = fittype('1./(2*pi* x * C) - (2*pi* x * Ls)','options', s);
ftype = fittype('1./(2*pi* x * C) - (2*pi* x * Ls)','options', s);
fitresult = fit(Freq/1e9 ,-data{nplot}(:,3),ftype);


Cp = fitresult.C/1e9
Lsp = fitresult.Ls/1e9
%
imagCp = 1./(2*pi* Freq* Cp) - (2*pi* Freq* Lsp) ;
plot(Freq/1e9,1*imagCp,'-.k');hold on;
legstr{2} = [num2str(Cp*1e12,'%.3g') ' pF + ' num2str(Lsp*1e9,'%.3g') '  nH'];

imagCp = 1./(2*pi* Freq* Cp)  ;
plot(Freq/1e9,1*imagCp,'-k');hold on;
legstr{3} = '2.1pF';
grid on

ylabel('-Imag(Z) for IDC; imag(Zin) for line');xlabel('F  (GHz)')
legend(legstr);
%%
L_NbTiN_for_Lshunt = Ls/L2*1e-6
title(['L NbTiN to get Ls = ' num2str(L_NbTiN_for_Lshunt,'%.3g') ' mm'])
