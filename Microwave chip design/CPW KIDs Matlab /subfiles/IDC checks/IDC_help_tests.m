 %GetFresIDC_copy
% Handy script to play aroiund with IDC's and prepare your mask design
%input:
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
addpath(genpath('/Users/jochem/ownCloud/KID/Technology_Experiment/TestedMatlabScripts'));

% start with line
% Only single params!

file = 'SONNETresults/Final_IDC2b';
lpl = '.-';
FwantedGHz = 4.25;
WIDCwanted = 1250;

% read data IDC
nhead = 2;%normal;l 2
[data,params]=readsonnetIDC(file,nhead);
oriFreq = data{1}(:,1)*1e9;
Flim = 9e9;

disp(params)

NbTiN.lw = 20e-6;
NbTiN.gap = 4e-6;
NbTiN.t = 100e-9;
NbTiN.length = 0.04e-3 + 0.5*pi*NbTiN.lw;
NbTiN.rho=100e-8;
Alu.lw = 1.2e-6;
Alu.gap = 2.5e-6;
Alu.Rs = 0.3;
Alu.t = 40e-9;
Alu.length = 3e-3;%[0.2 0.3 0.5 1 2.5]*1e-3;
epsDielectric = 11.44;


plotit = 1;
% for getting the intersects
% 'poly1'   Linear polynomial curve
% 'poly2'   Quadratic polynomial curve
% 'linearinterp'     Piecewise linear interpolation
% 'cubicinterp'     Piecewise cubic interpolation
% 'smoothingspline'  Smoothing spline (curve) (bad for exponentials
inttype = 'cubicinterp';


% process 2 line sections
%%%%% Alu line (L1)  %%%%%
[L1, C1] = Alulayer_simple(Alu.lw,Alu.gap,Alu.Rs,Alu.t,epsDielectric);
Alu.Lt = L1*Alu.length;        %Kinetic+geometric indutance
Alu.Ct = C1*Alu.length;           %Geometric capacitance
%%%%% NbTiN line (L2)  %%%%%
[L2, C2] = NbTiNlayer_simple(NbTiN.lw,NbTiN.gap,NbTiN.t,epsDielectric,NbTiN.rho);
NbTiN.L = L2*NbTiN.length;        %Kinetic+geometric indutance
NbTiN.C = C2*NbTiN.length;           %Geometric capacitance
%%%%% L1+L2  %%%%%
Line.length = NbTiN.length + Alu.length;
Line.Ltot = Alu.Lt + NbTiN.L;             %total kinetic inductance Line1 + Line2
Line.Ctot = Alu.Ct + NbTiN.C;
Line.Lpermeter = Alu.Lt./Line.length + NbTiN.L./Line.length;%eff value, = L1 for pure Alu line (etc)
Line.Cpermeter = Alu.Ct./Line.length + NbTiN.C./Line.length;
%%%%% Getting Fres  %%%%%
Line.vpeff =  1./ ( Line.Lpermeter .* Line.Cpermeter).^0.5 ;%parameter is line length independent
Line.Zeff = (Line.Lpermeter ./ Line.Cpermeter).^0.5;%parameter is line length independent



Fo = zeros(length(params),length(Alu.length));Ima = zeros(length(params),length(Alu.length));
for mm = 1: length(Alu.length)
    Line.Zin(:,mm) = 1j*Line.Zeff(mm) * tan((2*pi.*oriFreq/Line.vpeff(mm)) * Line.length(mm));
    % intersecrts
    toolong = logical(imag(Line.Zin(:,mm))<0);
    Flimi = logical(oriFreq>Flim);
    frind = toolong | Flimi;
    Freq = oriFreq(~frind);
    
    
    for n=1:length(params)
        imagZidc = -data{n}(~frind,3);
        [Fo(n,mm),Ima(n,mm)] = find_intersect_2lines(Freq/1e9,Freq/1e9,imagZidc,imag(Line.Zin(~frind,mm)),inttype,0);
    end
    % interpolate results
    line1{mm} = fit(Fo(:,mm),params,inttype);
    line2{mm} = fit(params,Fo(:,mm),inttype);
    
    WIDCneeded(mm)  = feval(line1{mm},FwantedGHz);
    Fgetted(mm)     = feval(line2{mm},WIDCwanted); 
end



if plotit == 1
    % plot
    figure(1)
    subplot(1,2,1)
    kleur = colormapJetJB(length(params));
    for n=1:length(params)
        plot(Freq/1e9,-data{n}(~frind,3),lpl,'color',kleur(n,:));hold on;
        legstr{n} = ['WIDC = ' num2str(params(n))];
    end
    MakeGoodFigure(18,7,15);
    
    ylim([0 90]);xlim([0 10]);grid on
    legend(legstr,'location','best')
    for mm = 1:length(Alu.length)
        plot(Freq/1e9,imag(Line.Zin(~frind,mm)),'-xk');
        for n=1:length(params)
            plot(Fo(n,mm),Ima(n,mm),'o','color',kleur(n,:),'markerfacecolor',kleur(n,:));
        end
    end
    ylabel('-Imag(Z) for IDC; imag(Zin) for line');xlabel('F  (GHz)')
    
    kleur2 = colormapJetJB(length(Alu.length));
    subplot(1,2,2)
    
    for mm = 1:length(Alu.length)
        plot(Fo(:,mm),params,'o','color',kleur2(mm,:),'markerfacecolor',kleur2(mm,:));hold on;
        legstr2{mm} = ['L_{Alu} = ' num2str(Alu.length(mm)*1e3) ' mm'];
    end
    
    for mm = 1:length(Alu.length)
        plot(Freq/1e9,feval(line1{mm},Freq/1e9),lpl,'color',kleur2(mm,:));
        plot(FwantedGHz,WIDCneeded(mm),'sk','MarkerSize',8,'MarkerFaceColor','k');
        plot(Fgetted(mm),WIDCwanted,'ok','MarkerSize',8,'MarkerFaceColor','k');
    end
    plot([2 10],[WIDCwanted WIDCwanted],'k-')
    grid on
    ylabel('Width IDC  (\mum)');xlabel('F  (GHz)');
    legend(legstr2)
    xlim([0 16]);ylim([0 1600])
    title(file)
    MakeGoodFigure(18,7,15);
end
%CHECKS
for mm = 1:length(Alu.length)
    WIDCneeded_real(mm) = GetWIDC(data, params, NbTiN, Alu, Alu.length(mm),  epsDielectric, FwantedGHz, 0);
    WIDCchecked_Fgetted(mm) = GetWIDC(data, params, NbTiN, Alu, Alu.length(mm),  epsDielectric, Fgetted(mm), 0);

end
[WIDCneeded'  WIDCneeded_real']
[Fgetted' WIDCchecked_Fgetted']
format short
[Fgetted' Alu.length'*1e3 (Fgetted'-Fgetted(4))*100]

