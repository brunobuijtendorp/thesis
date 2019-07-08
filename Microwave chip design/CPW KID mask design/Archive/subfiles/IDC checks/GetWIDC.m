function [WIDCmicron, line1] = GetWIDC(data, params, NbTiN, Alu, Alu_L,  epsDielectric, FwantedGHz, plotit)
% input:
% data and params are output of readsonnetIDC.m
% line pareameters
% NbTiN.lw = 12e-6;
% NbTiN.gap = 8e-6;
% NbTiN.t = 100e-9;
%$ NbTiN.rho = 100e-8 (100 ,uOhm cm normally()
% NbTiN.length = 0.0001e-3;
%
% Alu.lw = 1e-6;
% Alu.gap = 1e-6;
% Alu.Rs = 0.004;
% Alu.t = 40e-9;
% Alu_L = 1e-3; in mm
% epsDielectric = 11.44;
% FwantedGHz = 5;
%
% output
%
% WIDCneeded = the IDC with in mum
% line1 = fitted data of Widc(um) - Fres(GHz) so that WIDCneeded = feval(line1,FwantedGHz);
%
% Frequency range limited to 9 GHz
Alu.length = Alu_L;
oriFreq = data{1}(:,1)*1e9;
Flim = 9e9;
% process 2 line sections
%%%%% Alu line (L1)  %%%%%
[L1, C1] = Alulayer_simple(Alu.lw,Alu.gap,Alu.Rs,Alu.t,epsDielectric);
Alu.L = L1*Alu.length;        %Kinetic+geometric indutance
Alu.C = C1*Alu.length;           %Geometric capacitance
%%%%% NbTiN line (L2)  %%%%%
[L2, C2] = NbTiNlayer_simple(NbTiN.lw,NbTiN.gap,NbTiN.t,epsDielectric,NbTiN.rho);
NbTiN.L = L2*NbTiN.length;        %Kinetic+geometric indutance
NbTiN.C = C2*NbTiN.length;           %Geometric capacitance
%%%%% L1+L2  %%%%%
Line.length = NbTiN.length + Alu.length;
Line.Ltot = Alu.L + NbTiN.L;             %total kinetic inductance Line1 + Line2
Line.Ctot = Alu.C + NbTiN.C;
Line.Lpermeter = Alu.L./Line.length + NbTiN.L./Line.length;%eff value, = L1 for pure Alu line (etc)
Line.Cpermeter = Alu.C./Line.length + NbTiN.C./Line.length;
%%%%% Getting Fres  %%%%%
Line.vpeff =  1./ ( Line.Lpermeter .* Line.Cpermeter).^0.5 ;%parameter is line length independent
Line.Zeff = (Line.Lpermeter ./ Line.Cpermeter).^0.5;%parameter is line length independent
%Line.Betaeff = 2*pi * Freq ./ Line.vpeff;
%Line.Fres_lineonly = 0.25*( 1./(Line.Ltot.*(Line.Ctot)) ).^0.5;%rami 3.1 to check
Line.Zin = 1j*Line.Zeff * tan((2*pi.*oriFreq/Line.vpeff) * Line.length);

% catch resonances in the line itslef and limit F range
toolong = logical(imag(Line.Zin)<0);
Flimi = logical(oriFreq>Flim);
frind = toolong | Flimi;
Freq = oriFreq(~frind);

% intersecrts
Fo = zeros(size(params));Ima = zeros(size(params));
for n=1:length(params)
    [Fo(n),Ima(n)] = find_intersect_2lines(Freq/1e9,Freq/1e9,-data{n}(~frind,3),imag(Line.Zin(~frind)),'cubicinterp',0);
end
% interpolate results
line1 = fit(Fo,params,'cubicinterp');

WIDCmicron = feval(line1,FwantedGHz);

if WIDCmicron > max(params) 
    error(['IDC width = ' num2str(WIDCmicron) 'um, this is wider than max simulated width: F = ' num2str(FwantedGHz) ' GHz, LineLength = ' num2str(Line.length)])
elseif WIDCmicron < min(params)
    error(['IDC width = ' num2str(WIDCmicron) 'um, this is narrower than min simulated width: F = ' num2str(FwantedGHz) ' GHz, LineLength = ' num2str(Line.length)])
end

if plotit == 1
    % plot

    subplot(1,2,1)
    kleur = colormapJetJB(length(params));
    for n=1:length(params)
        plot(Freq/1e9,-data{n}(~frind,3),'-','color',kleur(n,:));hold on;
        legstr{n} = ['WIDC = ' num2str(params(n))];
    end
    MakeGoodFigure(18,7,15);
    
    ylim([0 40]);xlim([0 10]);grid on
    legend(legstr,'location','best')
    plot(Freq/1e9,imag(Line.Zin(~frind)),':k');
    for n=1:length(params)
        plot(Fo(n),Ima(n),'o','color',kleur(n,:),'markerfacecolor',kleur(n,:));
    end
    ylabel('-Imag(Z) for IDC; imag(Zin) for line');xlabel('F  (GHz)')
    
    subplot(1,2,2)
    plot(Fo,params,'bo');hold on;
    plot(Freq/1e9,feval(line1,Freq/1e9),'-b');
    plot(FwantedGHz,WIDCmicron,'xk','MarkerSize',8);
    grid on
    ylabel('Width IDC  (\mum)');xlabel('F  (GHz)');
    legend('Intersects Imag(Z)','Spline','requested point')
    MakeGoodFigure(18,7,15);
end
end