
function MaskGeneral_V1
% to do:TL bridges NEEDS RANdOMIZING FOR BIG ARRaYS for cl;assic KIDs only
% IMPORTANT FOR Superkids
% in line 185 the IDCdesign script calcualtes the Fres using the in;putted
% line and gapwidth. This does NOT acount for overetch
% if an antenna us isedm the gapwidth is forced to whatever is in the
% antenna design. The Linewdityh is NOT forced!!

%% Input parameters
global   widelinewidth widegapwidth  tlblength tlpolyw fracn mesh...
    tlbwidth maxLc TLbridges  bridgefromcoupler SuperKIDok...
    FullHybrid isl Fshift circleD SiNpatchaw BigSiN writestyle IDC_height;

addpath(genpath('subfiles'));
fclose all;close all;
format long g;

% general settings
writestyle = '% .0f, '; %  '% .0f, '  or '% .0f ' in writeofile.m (last option is clewin only, first for Layouteditor and clewin
FILE       = 'Test'; % name of output file 

%plotting options
makefigures     = 0;                  % plots the F spacing atrix
plotLcarray     = 0;                  %if set to 1 it polts the Lc vs Q array used

%Array desing general
numblocks       = 1;
BSOffset        = 0;
HexArray        = 0;                     %Hex or Square

% Array Design: HEX only
spiralencoding  = 2; %1 gives spiral encoding (ban for rows,cols<=3, 0 gives linear backl and forth +-, 2 gives snake mono increasing
isl             = 4; %=4 forHEX, mirror of the start pixels of each row to prevent diagnoal doubles. only used for spiralencoding=0
rows            = 3; % the # cols will alternate between cols and cols-1
cols            = 3;
if HexArray == 1
    disp(['HEX: nkids = ' num2str(floor(rows/2)*(cols)+ceil(rows/2)*(cols-1))]);
end
split=2;        %floor((0.5/dF)/2); 	%NEVER 0!!!split in #indices in KID aray F0. (firdst # is split n GHz) only HExagonal
% hex only: option to force the oneDarray manually. must be the same length as nKIDs
ForceOneD = 1;
oneDarrayforced = [100 150 300 350 400 225  275]';%only used if above == 1; around 125 350 250

% SQUARE only
% Frers matrix for square packing (you need to define it here)
Fresmatrix = [-2 -1 0 1 2 ]; %only for square; 

% Array general
ArrayWidthAdjust= 0;%-220;          %changes arraywidth by this number (negative is size reduction)
ArrayTLShift=0;%-62;               % changes the shift of the entire Tline. + is TL shiftto the right
writeassymbol=1;

% basic KID parameters
BigSiN          = 0; %0 for small patches, 1 for big area
epsDielectric   = 11.44;  % epsilon of the substrate, 11.44 for Si
circleD         = 1200;    % Radius of circle around antenna for absorber layer
KIDdistance     = 1000;   % in mu
linewidth       = 10;        % KID hybrid CPW, %PdV hyrbids (no antenna): 1.2 um. Antenna ~= will overwrite
gapwidth        = 6; 
SiNpatchaw      = 6;      % alignemnt tolerance (total) of patches SiN
Lc_const        = 0;       % set to 1 to m,aintain a single coupler length (classic) of coupler distance (IDC)
                        %(do NOT use with scaled Q)
KillKidTline    = 0;      %if set to 1 T;ine written in KID write is allowed to be removed
FullHybrid      = 0;      % 1 makes the central line entirely of Al
antenna         = 0; 	%
ed              = 40;	%size of last vertical part towards the antenna, will be overwritten for specific antenna
tria            = 12;   %height of triangles used to couple section sof differeht widths
SinglelayerKID  = 1;  	%=1 if single layer KID is to be written (needs checking)

% Define IDC or normal KID
IDCsuperKID     = 0;    %1 will use SuperKID shape: IDC + THz antenna, Q design parameterized for coupler distance. 0 will use old design

% only classic KID parameters
fracn           = 2;  %Alu length -1, shortest possible Al; :0<fracn<1: gives the fraction of first full arm to be narrow, option 2: fracn>=2 and integer: # meanders narrow. must be <ncurves  %
ncurves         = 7;      % number of full length horizontal KID bars in central part
cd              = 80;      %addn. distance from coupler to KID that will be wide must be larger than Cgap+Cline. Ignored for superTHz KID
vpn             = 5;       %addn. distance from coupler to KID that will be narrow. Total desitance from KID meander to coupler is cd+vpn+tria!%Ignored for superTHz KID
kidheight       = 700;    % in mu, check antenna size if ok! Use half if half wave..... IS OVERWRITTEN FOR SUPERKIDS
Qwave           = 1;      % Q wave devices. Note that KID will become 2x higher if HW. Overridden by atenna choice
design_Q        = 1; %only 1 is implemented


%only SuperKID parameters, relevant for IDC
Alu_L           = 300; %[1600 1600 1600 800 800 800 400 400 400 200 200 200]'; %in mu, total length. of the alu. Can be array
NbTiN.t         = 100e-9;
NbTiN.rho       = 100e-8; %100 uOhmcm normally)
Alu.Rs          = 0.3;
Alu.t           = 40e-9;
designIDC       = 2; %1=IDC1b,4-20-4, 6 fingers, 2 = IDC2b, ,8-40-8, 6 fingers, 3 = IDC3c, ,16-80-16, 5 fingers

% F encoding and Q
Fshift          = 1;        % multuplies with design F to coreect for kinetic inductance
Q               = [50 50 100 100 200]*1E3 ;    % one number for same Lc for all KIDs or array = 
Fcenter         = 5.2/Fshift;           % 
forbiddenrange  = [10 11]/Fshift; 	%NB!!!: SCript messes up if forbiddenrange is within first 3 MKIDs (i.e Fcenter ~=forbiddenrange)
scaled_dF       = 0;        %if =1 dF is below in fraction of Fres; if 0 then dF is in GHz
dF              = 0.01;    	%see above, fraction of Fo or in GHz
makescaledQ     = 0 ;     	%Scales Q factor
disp(['Fc df Q: ' num2str([Fcenter dF mean(Q)])]);

% %%%%%%%%%%%%%%%%%%%%%% Easy Combining for my mask design superkids 1%%%%%%%%%%%%%%%%%%%%%%
% %also check Hex array @ line 29, cannot be placed here 275
% designIDC       = 1; %1=IDC1b,4-20-4, 6 fingers
% % for Hybrids
% if designIDC == 1
%     Fresmatrix = [320 330 340;-5 0 113;118 201 206 ; 266 271 276]; %only for square idc1b,
%     Alu_L           = [2130 1500 1000 1000 1000 500 500 300 300 200 200 200]'; %this one for square idc%
%     FILE = 'IDC1Square';%IDC1Hex  IDC1Square IDC2Square
% elseif designIDC == 2
%     Fresmatrix = [40 50 60;-5 0 100;105 172 177; 221 226 231]; %only for square idc2b, ;
%     Alu_L           = [3700 1950 1000 1000 1000 500 500 300 300 200 200 200]'; %this one for square idc%
%     FILE = 'IDC2Square';%IDC1Hex  IDC1Square IDC2Square
% elseif designIDC == 3
%     Alu_L           = [2520 1600 1000 1000 1000 500 500 300 300 200 200 200]'; %this one for square idc%
%     Fresmatrix = [40 50 60;-5 0 91 ;96 153 158; 193 198 203]; %only for square idc3c, ; 
%     FILE = 'IDC3Square';%IDC1Hex  IDC1Square IDC2Square
% end
% 
% %for NbTiN only
% antenna         = 0;
% SinglelayerKID  = 1;
% Alu_L           = 20;
% ed              = 1000;
% Fresmatrix = [330 320];
% Q = 2.5e5;
% 
% KIDdistance     = 2000;   % in mu
% if designIDC == 1
%     FILE = 'IDC1SquareNbTiN';%IDC1Hex  IDC1Square IDC2Square
%     linewidth       = 20;
%     gapwidth        = 4;
%     Fresmatrix = [400 410];
% elseif designIDC == 2
%     FILE = 'IDC2SquareNbTiN';%IDC1Hex  IDC1Square IDC2Square
%     linewidth       = 40;
%     gapwidth        = 8;
% elseif designIDC == 3
%     FILE = 'IDC3SquareNbTiN';%IDC1Hex  IDC1Square IDC2Square
%     linewidth       = 80;
%     gapwidth        = 16;
%     Fresmatrix = [260 270];
%     Q = 1.0e5;
% end

%%%%%%%%%%%%%%%%%%%%%% end Easy Combining %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%other KID parameters
mesh            = 20;   %point meshing used for bends
RTL             = 200;  %though line bend radius MUST BE SMALLER THAN kidheight

% TL bridges NEEDS RANdOMIZING FOR BIG ARRaYS!
TLbridges           = 1;    %set to 0 if no bridges desired, 1 TL bridges, 2 between KIDs, 2 TLbridges, only 1 bridge in between KIDs
tlbwidth            =16;    %width of the bridges
tlpolyw             = tlbwidth+20;          %width of dielectric underneath bridge
bridgefromcoupler   = 200;	%distance of bridge from coupler
SuperKIDok          = 1;     %default ok, so it works with no antena option. DO NOT CHANGE


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if HexArray==1
    Fresmatrix=[];
elseif HexArray==0
    rows=size(Fresmatrix,1);
    cols=size(Fresmatrix,2);
end

if fracn>=ncurves
    error('fracn too large')
end

% the antenna cases are used in: defineSuperTHzKID, 
switch antenna 
    case 0
        disp('No antenna');
        SuperKIDok = 1;  
        NbTiNph         = linewidth + 2*gapwidth; %PdV hyrbids (no antenna): 6.2. if antenna ~= 0 it will be overwrittem
    case 1
        disp('SuperKID 1.55 THz antenna');
        SuperKIDok = 1;  
        linewidth       = 1;  % KID CPW, line = 1.5, gap = 2.25. OVERWRITTEN IF ANTENNA CHOSES
        gapwidth        = 1;
        NbTiNph         = 120;
        ed              = 120;
    case 2
        SuperKIDok      = 0;  
        linewidth       =1.9;
        gapwidth        =1.95;
        Qwave=1; %Total W5.3. 350 narrow line antenna Lband 2015 on Sapphire is 2-1.4-2 (5.4) in design. For TOPPAN MASK
        disp('13: 350 GHz Lband2016 Si');
    case 3
        SuperKIDok      = 1;  
        linewidth       = 1.9;
        gapwidth        = 1.95;
        Qwave           = 1; %Total W5.3. 850 GHz OZAN SiN 0.5um -Si
        disp('14: 850 GHz Hband2016 Si');
end

% set params for IDC design 
% ONLY NOW widelinewidth, widegapwidth IS DEFINED
if IDCsuperKID == 1
    [Couplength, tlgap, tlwidth, IDCtoTline, NbTiN, Alu, n_2arms, data, params, Qdesign] = ...
        selectIDCdesign(designIDC, NbTiN, Alu, ed, linewidth, gapwidth);
elseif IDCsuperKID == 0
    [Qdesign, coupL, coupG, tlgap, tlwidth, td, epsilon_substrate] = select_Classicdesign(design_Q);
    widelinewidth   = coupL;
    widegapwidth    = coupG;    
end

% automatic param not to be changed
Rkid            = widelinewidth; %turn after antenna radius, bigger than largest line!

if tlblength<tlwidth+2*tlgap+2
    error('bridges over Tline too short')
end
if makescaledQ == 1
    if Lc_const == 1
        error('Lc const not compatibel with scaled Qc')
    end
end
tlblength           = 2*tlgap+tlwidth+30; 	 %TL bridge length (section on dielectric). Pads added in sub-m file automatically.
%% Calculating KID radius and initilizing parameters
%create position matrix (x,y for all kids) and 1D array for indexing

if rows==1 && cols==1
    HexArray=0;
end

if HexArray==1
    
    if spiralencoding==0
        [positions,oneDarray,numKIDS,figs] = createmeandermatrix_HEX(rows,cols,split,makefigures);%new 2014 march, does meander back and forth +-
    elseif spiralencoding==1
        [positions,oneDarray,numKIDS,figs] = createmeandermatrix_interleaved_CenterKID(rows,cols,split,makefigures);%spiral encoding +- around center MKID
    elseif spiralencoding == 2
        [positions,oneDarray,numKIDS,figs] = createmeandermatrix_HEX_mono(rows,cols,makefigures);% no +-, snake meander miniotonic
    end
    if ForceOneD == 1
        if size(oneDarray) == size(oneDarrayforced)
            oneDarray = oneDarrayforced;
            scaled_dF=0;
        else
            error('oneDarrayforced has wrong size to use the force 1D array option')
        end
    end
    if scaled_dF==1
        F_array = create_Farray_scaled_dF(Fcenter,dF,oneDarray,forbiddenrange);
    else
        F_array = Fcenter+oneDarray*dF;
    end
    
else %Square array
    positions = create2Dpositions(rows, cols);%follows encoding of Fmatrix given
    [F_array,oneDarray] = createinputmatrix_SquareNew(rows,cols,Fcenter,dF,Fresmatrix);%
    oneDarray = oneDarray';
    numKIDS = rows*cols;
end


%created inputdata
if IDCsuperKID == 0
    inputdata = Get_Q_Lc_F0_Classic(Qdesign,F_array,Q,Lc_const,epsilon_substrate,makescaledQ,Fcenter,plotLcarray);
    Fres    = inputdata(:,3)*1000; 	%in MHz
    Lc      = inputdata(:,2);     	%coupler length from inputdata
    LKID    = inputdata(:,1);    	%kidlength
    maxLc   = max(Lc);
elseif IDCsuperKID == 1
    % F_array, Alu_L and Q can be array.
    inputdata = Get_Q_td_WIDC(Qdesign, F_array,data, params, NbTiN, Alu, Alu_L, Q, epsDielectric, Lc_const, makescaledQ, Fcenter, plotLcarray);                      
    Fres    = inputdata(:,3)*1000; 	%in MHz
    td      = inputdata(:,2);     	%coupler distance from inputdata
    WIDC    = inputdata(:,1);    	%IDCwidth
end
format short

disp(['Frange including Fshift (expected) 1: ' num2str(min(Fres)*Fshift/1000) ' - '  num2str(forbiddenrange(1)*Fshift) ])
disp(['Frange including Fshift (expected) 2: ' num2str(forbiddenrange(2)*Fshift) ' - '  num2str(max(Fres)*Fshift/1000) ])
disp(['Frange EXcluding Fshift (design) 1: ' num2str(min(Fres)/1000) ' - '  num2str(forbiddenrange(1)) ])
disp(['Frange EXcluding Fshift (design) 2: ' num2str(forbiddenrange(2)) ' - '  num2str(max(Fres)/1000) ])
disp(['nkids= ' num2str(length(Fres))])

%%%%%%%%%%%%%%%%%%%%%%%%%%%KID SHAPE DEFINING SECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if IDCsuperKID     == 1
    kidheight = IDC_height + ed + Rkid + IDCtoTline + tlwidth/2+tlgap;
    R = Rkid;
    Rlineratio = 0;
elseif IDCsuperKID     == 0 %normal case case
    %calculate parameters at Fcenter to be able to make final KID geometry
    Fres_F0=Get_Q_Lc_F0_Classic(Qdesign,Fcenter,Q,Lc_const,epsilon_substrate,makescaledQ,Fcenter,0);
    LKID_F0=Fres_F0(1,1);
    Lc_F0=Fres_F0(1,2);
    R=-(tlwidth/2+tlgap+td+coupG+cd+tria+vpn+ed-kidheight)/(3+2*ncurves);
    Larm_F0=-(-R-LKID_F0+(ncurves+3/2)*pi*R+tria+cd+ed+vpn+Lc_F0)/(ncurves+1);
    KIDLength_F0=(ncurves+1)*Larm_F0-R+(ncurves+3/2)*pi*R+tria+cd+ed+vpn+Lc_F0;%just for checking
    %          L=(ncurves+1)*Larm-   R+(ncurces+3/2)*pi*R+tria+cd+ed+vpn+Lcoup
    %checked jan 2014
    Rlineratio=2*R/(widelinewidth+2*widegapwidth);
end
%% Preparing exact positions to put MKIDs down
if HexArray==1
    if rem(rows,2)==0
        upshift=KIDdistance*cos(30*pi/180);
    else
        upshift=0;
    end
else
    upshift=0;
    %for manual square array: make sure it is centered
    positions(:,1) = positions(:,1) - (min(positions(:,1)) +max(positions(:,1)))/2;
    positions(:,2) = positions(:,2) - (min(positions(:,2)) +max(positions(:,2)))/2;
end
positions(:,1)  =KIDdistance*positions(:,1);
positions(:,2)  =KIDdistance*positions(:,2)+upshift;
if length(Alu_L) == 1 & IDCsuperKID == 1
    Alu_L = Alu_L * ones(size(WIDC));
end
cdnew=zeros(numKIDS,1)+cd;Larm=zeros(numKIDS,1);KIDlengthcalculated=zeros(numKIDS,1);KIDlengthwritten=zeros(numKIDS,1);HybridLengthwritten=zeros(numKIDS,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% drawing and writing KID by KID%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid         = iniwriteKIDtofile(FILE);
synum       = writesymbols(fid,R,mesh,linewidth,gapwidth,SinglelayerKID,ncurves,writeassymbol);
% initialize symbol  whole array
synumarray  = synum+1;
iniwrite_1_Symboltofile(fid,synumarray,FILE);

for ni=1:numKIDS %defining KIDs and writing them 1 by 1
    %defining KIDs
    if IDCsuperKID == 0 %old design
        Kid_dL=0;%NB: Kid_dL=0 because larm now changes!! Inside the functions Lsmallarm=Larm/2-R+Kid_dL = Lsmallarm=Larm/2-R so as it should be checked jan 2014
        Larm(ni)=-(-R-LKID(ni)+(ncurves+3/2)*pi*R+tria+cd+ed+vpn+Lc(ni))/(ncurves+1);
        KIDlengthcalculated(ni)=(-R+(ncurves+3/2)*pi*R+tria+cd+ed+vpn+Lc(ni)+(ncurves+1)*Larm(ni));
        %caling KID writing Fy
        [KID,SiNpatch,TLBRIDGES,SiO2,HYBRIDS,Symbols,KIDlengthwritten(ni),HybridLengthwritten(ni)]=...
            defineKID(Qwave,R,Larm(ni),Kid_dL,ed,cdnew(ni),td,Lc(ni),linewidth,gapwidth,ncurves,tlwidth,tlgap,KIDdistance,tria,coupL,coupG,vpn,antenna);
        newX = 0;%needed now!
        if SinglelayerKID == 1
            clear KID;
            KID=defineKID(Qwave,R,Larm(ni),Kid_dL,ed,cdnew(ni),td,Lc(ni),linewidth,gapwidth,ncurves,tlwidth,tlgap,KIDdistance,tria,coupL,coupG,vpn,antenna);
            if fracn<1 %removing the KID bars below the Alu layer
                KID(2)=[];
            elseif fracn>1
                KID(2*[1:1:fracn+2])=[];
                KID{5}(3,:,:)=[];
            else
                disp('WARNING: KID nonHyb not ok, see line 787 or so defineKID.m')
            end
        end
    elseif IDCsuperKID == 1 %use superkid
        [KID,SiNpatch,TLBRIDGES,SiO2,respatch,HYBRIDS,newX,KIDlengthwritten(ni),HybridLengthwritten(ni)]=...
            defineSuperTHzKID(n_2arms,WIDC(ni),R,Alu_L(ni),ed,IDCtoTline,td(ni),Couplength,linewidth,tlwidth,tlgap,KIDdistance,tria,antenna,NbTiNph,SinglelayerKID);%Ls is swept param, Tlineditance in this case
        KIDlengthcalculated(ni) = WIDC(ni);
    end
    Absorberhole=[circleD,newX,0];
    Aligncross{1}=shiftXY(makebar(circleD+30,20),newX,0);%horizontal arm at (0,0)
    Aligncross{2}=shiftXY(makebar(20,circleD+30),newX,0);%horizontal arm at (0,0)
    Aligncross{3}=shiftXY(makebar(circleD+60,4),newX,0);%horizontal arm at (0,0)
    Aligncross{4}=shiftXY(makebar(4,circleD+60),newX,0);%horizontal arm at (0,0)
    
    %Kill Tline Section maybe
    if cols~=1 && KillKidTline==1% Kill Tline written with kIDs to allow 1 Tline for all (smaller file, narrower array).
        KID(end-1:end)=[];
        SiNpatch(end:end)=[];
    end
    
    %define what is to be written to file
    KID         =shiftKID(KID,positions(ni,1),positions(ni,2));%building array bottom up!!! %
    if IDCsuperKID == 0
        Symbols     =shiftSymbolXY(Symbols,positions(ni,1),positions(ni,2));
    end
    if SinglelayerKID ~= 1
        HYBRIDS     =shiftKID(HYBRIDS,positions(ni,1),positions(ni,2));%building array bottom up!!! %
        SiNpatch    =shiftKID(SiNpatch,positions(ni,1),positions(ni,2));%building array bottom up!!! %
        if IDCsuperKID == 1
            respatch    =shiftKID(respatch,positions(ni,1),positions(ni,2));%resist patch
        end
    end
    Absorberhole=shiftCircle(Absorberhole,positions(ni,1),positions(ni,2));
    Aligncross  =shiftKID(Aligncross,positions(ni,1),positions(ni,2));
    if TLbridges>0
        SiO2=shiftKID(SiO2,positions(ni,1),positions(ni,2));%building array bottom up!!! %
        TLBRIDGES=shiftKID(TLBRIDGES,positions(ni,1),positions(ni,2));%building array bottom up!!! %
    end
    
    %%%%Write rest%%%%%%
    writetofile(KID,fid,1);         %1 NbTiN
    if SinglelayerKID ~= 1
        writetofile(SiNpatch,fid,2);    %2 SiN front
        writetofile(HYBRIDS,fid,4);     %4 Alu
    end
    writetofile(TLBRIDGES,fid,4);   %4 Alu
    if IDCsuperKID == 1
        writetofile(respatch,fid,5);    %5 Resist
    end
    writetofile(SiO2,fid,6);        %6 polyimide

    if antenna ~= 0
        writetofileCircles(Absorberhole,fid,3); %3 Backside mesh
        writetofile(Aligncross,fid,3);          %3 Backside mesh
    end

    %%%%WRITING TO array symbol the old SYMBOLS %%%%%%
    if IDCsuperKID == 0
        for jj=1:length(Symbols)
            write_Symbol_tofile(Symbols{jj},fid,jj);%index is the symbol type, not the layer
        end
    end
    %%%%END WRITING TO FILE SYMBOLS%%%%%% 
end


%% add Tline to the ARAY symbol
% adding through line bends%%%%%%%%%%%%%
putTlineinSymbol=0;
if rows>2 && HexArray==1
    [KIDTL,HYBRIDSTL,SiO2TL,SiNpatch]=writeTlineOnesided(1,kidheight,KIDdistance,RTL,tlgap,tlwidth,mesh,rows,cols,fid,ArrayWidthAdjust,ArrayTLShift,0,writeassymbol);
    putTlineinSymbol=1;
elseif rows >= 2 && HexArray==0
    writeTlineOnesidedSQUARE(SinglelayerKID,kidheight,KIDdistance,RTL,tlgap,tlwidth,mesh,rows,cols,fid)
else
    disp('not implemented type of TL, TL not drawn')
end
if putTlineinSymbol==1
    writetofile(KIDTL,fid,1);
    writetofile(SiNpatch,fid,2)
    writetofile(SiO2TL,fid,6);
    writetofile(HYBRIDSTL,fid,4);
end


%% Finishing writing symbols
closewrite_All_Symbolstofile(fid,synumarray+1);%default
    
%% determining blockshift

for nblocks=1:numblocks
    disp([ 'numblocks= ' num2str(nblocks)])
    if HexArray==1
        HeigtArray=(rows)*KIDdistance*cos(30*pi/180);%chnged from 800 to KIDdistance
    else
        HeigtArray=(rows)*KIDdistance;
    end
    if numblocks~=0
        blockshift=HeigtArray*(nblocks-1)+BSOffset;%HeigtArray=(rows)*KIDdistance*cos(30*pi/180);
    else
        blockshift=0;
    end
    Symbols{synumarray}(nblocks,:)=[0 blockshift];
end

%putting the array symbol in the file (i.e. symbol synumarray, the array)
write_Symbol_tofile(Symbols{synumarray},fid,synumarray);%index is the symbol type, not the layer

clear KID KIDnonH WORST BRIDGES HYBRIDS SiO2 TLBRIDGES;

closewriteKIDtofile(fid,synum+1);


%% writing logfiles%%%%%%%%%%%%%%%%%%%%%%%%%%

aa=[inputdata(:,1:4) KIDlengthwritten KIDlengthcalculated HybridLengthwritten Larm cdnew positions oneDarray];
if IDCsuperKID == 0
    keeswrite('Lres,Lcoupler,F0[GHz],Q,KIDlengthwritten,KIDlengthcalculated,Hyblengthwrite,Larm,CouplerD,Xpos,Ypos,indices',[FILE '_individualKIDparameters.csv']);
elseif IDCsuperKID == 1 %use superkid
        keeswrite('Lres,Lcoupler,F0[GHz],Q,WideNbTiNL,IDC width,Hyblengthwrite,Larm,CouplerD,Xpos,Ypos,indices',[FILE '_individualKIDparameters.csv']);
end
dlmwrite([FILE '_individualKIDparameters.csv'], aa, '-append','newline', 'pc', 'precision', '%.8g','delimiter', ',');

nkids=length(Fres);
bestand=[FILE '_allparam.csv'];
keeswrite('Fcenter,dF,Q,nkids,min(Fres),max(Fres),KIDdistance,kidheight,linewidth,gapwidth,widelinewidth,widegapwidth,Rlineratio,R,ncurves,cd,ed,vpn',bestand);
towrite=[Fcenter dF mean(Q) nkids min(Fres) max(Fres) KIDdistance kidheight linewidth gapwidth widelinewidth widegapwidth Rlineratio R ncurves cd ed vpn];
dlmwrite(bestand, towrite, '-append','newline', 'pc', 'precision', '%.6g','delimiter', ',');

if makefigures==1 && HexArray==1 && scaled_dF==1
    bestand=[FILE 'KIDindexingofoneDarray.fig'];
    saveas(figs(1),bestand,'fig');
    
    bestand=[FILE 'KIDindices.fig'];
    saveas(figs(2),bestand,'fig');%
    
    bestand=[FILE 'Resonancefreqs.fig'];
    saveas(figs2(1),bestand,'fig');%
    %close all;
end

format short g
if HexArray==1
    disp(['frequency range: ' num2str(min(Fres)) ' to ' num2str(max(Fres))]);
else
    disp(['frequency range: ' num2str(min(Fres)) ' to ' num2str(max(Fres))]);
end
close all;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END MAIN%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PROGRAM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [M,oneDarray,nkids,figs]=createmeandermatrix_interleaved_CenterKID(rows,cols,split,makefigures)
% rows is # rows, cols is # cols. rows must be largest

%DOES CREATE A CENTRAL RESONATOR!!

% generates M, a 1D matrix with positions (x,y) where to place the KIDs
% M creates HCP positions with rows of +1 varying length to make a rectangular fill
% M is the same as the old output of create2Dpositions_IL, still present in
% the other scripts to make masks

% generates oneDarray, matrix with F indices. Fres(n)=F0+df*oneDarray(n)
% same as the indices array in the old createinputmatrix_1Lc_IL inside the
% main scrips to make a mask

% generates plots of M and oneDarray on M (which represents the real KIDs
% as made)

% ADDITION: if split>1 the array is split in the center frequency (i.e. a
% gap is created around F0). The gap size is equal to 2+1x the parameter
% split


close all;
if nargin==0
    cols=6;rows=5;
end
%determine real number of KIDs
nkids=floor(rows/2)*(cols)+ceil(rows/2)*(cols-1);

%generate 1D array
oneDarray=zeros(nkids,1);
n=1; %for+-
m=1; %radius hexagon for extra step
oneDarray(1)=0;%center KID
oneDarray(2)=split;%
oneDarray(3)=-split;%
for i=4:nkids
    oneDarray(i)=(-1)^(i)*(n+split);
    if rem(i,2)
        n=n+1;
    end
end

%determine the limits of the array. rows need up and down condition, cols

%this is not required due to the x shift between adjecent rows
uprowlim=floor((rows-1)/2);%row 0 is the first... so lim is n-1
botrowlim=ceil((rows-1)/2);%row 0 is the first... so lim is n-1

upcollim=ceil((cols)/2);%row 0 is the first... so lim is n-1
botcollim=floor((cols)/2);%row 0 is the first... so lim is n-1
%collim=cols/2;

%generate first position at (0,0)
kn=1;%kid number
x=0;
y=0;
M(kn,1)=x;                  %col=x
M(kn,2)=y*cos(30*pi/180);   %row=y
kn=kn+1;

%generating the rest by going around the hex spiral
n=1;%radius of HEX spiral
remy2start=0; %parity of the start row (start row=0):0=even
while kn<=nkids;%does not work, as nkids is larger die to interleaved rows.  . can be optimised
    for ptd=1:1%step down right once
        y=y-1;
        x=x+0.5;
        if rem(y,2)==remy2start%row index same as start row or index same parity; these we make shorter
            xstop=0.5;
        else
            xstop=0;
        end
        if y<=uprowlim && y>=-botrowlim && x<=upcollim-xstop && x>=-(botcollim-xstop)
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;
        end
    end
    
    for ptd=1:n-1%step down left n-1 times
        y=y-1;x=x-0.5;
        if rem(y,2)==remy2start%row index same as start row or index same parity; these we make shorter
            xstop=0.5;
        else
            xstop=0;
        end
        if y<=uprowlim && y>=-botrowlim && x<=upcollim-xstop && x>=-(botcollim-xstop)
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;
        end
    end
    
    for ptd=1:n%step left n times
        x=x-1;
        if rem(y,2)==remy2start%row index same as start row or index same parity; these we make shorter
            xstop=0.5;
        else
            xstop=0;
        end
        if y<=uprowlim && y>=-botrowlim && x<=upcollim-xstop && x>=-(botcollim-xstop)
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;
        end
    end
    
    for ptd=1:n%step left up n times
        x=x-0.5;y=y+1;
        if rem(y,2)==remy2start%row index same as start row or index same parity; these we make shorter
            xstop=0.5;
        else
            xstop=0;
        end
        if y<=uprowlim && y>=-botrowlim && x<=upcollim-xstop && x>=-(botcollim-xstop)
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;
        end
    end
    
    for ptd=1:n%step right up n times(add col, subtract row) and add KID)
        x=x+0.5;y=y+1;
        if rem(y,2)==remy2start%row index same as start row or index same parity; these we make shorter
            xstop=0.5;
        else
            xstop=0;
        end
        if y<=uprowlim && y>=-botrowlim && x<=upcollim-xstop && x>=-(botcollim-xstop)
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;
        end
    end
    
    
    for ptd=1:n%step right n times(add col) and add KID)
        x=x+1;
        if rem(y,2)==remy2start%row index same as start row or index same parity; these we make shorter
            xstop=0.5;
        else
            xstop=0;
        end
        if y<=uprowlim && y>=-botrowlim && x<=upcollim-xstop && x>=-(botcollim-xstop)
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;
        end
    end
    
    for ptd=1:n%step down right n times(add row, add col) and add KID)
        x=x+0.5;y=y-1;
        if rem(y,2)==remy2start%row index same as start row or index same parity; these we make shorter
            xstop=0.5;
        else
            xstop=0;
        end
        if y<=uprowlim && y>=-botrowlim && x<=upcollim-xstop && x>=-(botcollim-xstop)
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;
        end
    end
    
    n=n+1;%radius+1
    if n>1000 %emergency catch
        disp('emergency catch')
        break;
    end
end

if nkids~=kn-1
    [nkids kn-1]
    error('something wrong in createHEXmatrixinterleaved.m')
end
if makefigures==1
    figs(1)=figure('OuterPosition',[100, 100, 800, 800]);
    for m=1:nkids
        text(M(m,1),M(m,2),num2str(oneDarray(m)));hold on
    end
    
    axis([-1.4*botcollim 1.4*upcollim -1.4*botcollim 1.4*upcollim])
    
    figs(2)=figure('OuterPosition',[100, 100, 800, 800]);
    for m=1:kn-1
        text(M(m,1),M(m,2),num2str(m));hold on
    end
    axis([-1.4*botcollim 1.4*upcollim -1.4*botcollim 1.4*upcollim])
else
    figs=0;
end
end

function [M,oneDarray,nkids,figs]=createmeandermatrix_HEX(rows,cols,split,makefigures)
% rows is # rows, cols is # cols. rows must be largest

% Creates EXACTY the same KIDp ositions as createmeandermatrix_interleaved_CenterKID
% but now in meandering like snake model
% no central KID
% +- spiral
% isl parameter jumps the edges of the array to prevent diagional nears
% neighbours

% generates M, a 1D matrix with positions (x,y) where to place the KIDs
% M creates HCP positions with rows of +1 varying length to make a rectangular fill
% M is the same as the old output of create2Dpositions_IL, still present in
% the other scripts to make masks

% generates oneDarray, matrix with F indices. Fres(n)=F0+df*oneDarray(n)
% same as the indices array in the old createinputmatrix_1Lc_IL inside the
% main scrips to make a mask

% generates plots of M and oneDarray on M (which represents the real KIDs
% as made)

% ADDITION: if split>1 the array is split in the center frequency (i.e. a
% gap is created around F0). The gap size is equal to 2+1x the parameter
% split

global isl
close all;

if isl*2>=cols
    warning('isl parameter set to 0');
    isl = 0;
end

if nargin==0
    cols=6;rows=5;
end
%determine real number of KIDs
nkids=floor(rows/2)*(cols)+ceil(rows/2)*(cols-1);

%generate 1D array
oneDarray=zeros(nkids,1);
n=1; %for+-
m=1; %radius hexagon for extra step
oneDarray(1)=0;%center KID
oneDarray(2)=split;%
oneDarray(3)=-split;%
for i=4:nkids
    oneDarray(i)=(-1)^(i)*(n+split);
    if rem(i,2)
        n=n+1;
    end
end

%determine the limits of the array. rows need up and down condition, cols

%this is not required due to the x shift between adjecent rows
uprowlim=floor((rows-1)/2);%row 0 is the first... so lim is n-1
%botrowlim=ceil((rows-1)/2);%row 0 is the first... so lim is n-1

upcollim=ceil((cols)/2);%row 0 is the first... so lim is n-1
botcollim=floor((cols)/2);%row 0 is the first... so lim is n-1
%collim=cols/2;

%generate first position at (0,0)=> this is now the top left corner
kn=1;%kid number


nrows=0;
if rem(rows,2)==1 %odd rows, first row is smaller
    y=1;x=-0.5;%first KID ref
    while nrows<rows%
        y=y-1;
        x=x+0.5;
        
        for ptd=1:(cols-1)-isl%first row, shorter.
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;x=x+1;
        end
        for ptd=isl-1:-1:0%first row, shorter
            M(kn,1)=x+2*ptd-(isl-1);%X+ptd=last pos in col, ptd-(isl-1) is reversed couter+pos coprrrction
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;x=x+1;
        end
        x=x-1;%resetting last one
        nrows=nrows+1;
        %NEXT
        x=x+0.5;
        y=y-1;
        if nrows<rows
            for ptd=1:(cols)-isl%2nd rows, shorter.
                M(kn,1)=x;%x
                M(kn,2)=y*cos(30*pi/180);%y
                kn=kn+1;x=x-1;
            end
            for ptd=isl-1:-1:0
                M(kn,1)=x-2*ptd+(isl-1);%x, no correction needed
                M(kn,2)=y*cos(30*pi/180);%y
                kn=kn+1;x=x-1;
            end
            nrows=nrows+1;
        end
        x=x+1;%resetting last one
        
        %emergency catch
        if kn>100000
            disp('emergency catch')
            break;
        end
    end
    
    
elseif rem(rows,2)==0%even cols, first row is larger
    y=1;x=0;%first KID ref
    while nrows<rows
        y=y-1;
        x=x-0.5;
        for ptd=1:(cols)-isl%first row, longer.
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;x=x+1;
        end
        for ptd=isl-1:-1:0%first row, longer
            M(kn,1)=x+2*ptd-(isl-1);%X+ptd=last pos in col, ptd-(isl-1) is reversed couter+pos coprrrction
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;x=x+1;
        end
        x=x-1;%resetting last one
        nrows=nrows+1;
        x=x-0.5;
        y=y-1;
        if nrows<rows
            for ptd=1:(cols-1)-isl%2nd rows, shorter.
                M(kn,1)=x;%x
                M(kn,2)=y*cos(30*pi/180);%y
                kn=kn+1;x=x-1;
            end
            for ptd=isl-1:-1:0
                M(kn,1)=x-2*ptd+(isl-1);%x, no correction needed
                M(kn,2)=y*cos(30*pi/180);%y
                kn=kn+1;x=x-1;
            end
            nrows=nrows+1;
        end
        x=x+1;%resetting last one
        
        %emergency catch
        if kn>100000
            disp('emergency catch')
            break;
        end
    end
    
    
end

if nkids~=kn-1
    [nkids kn-1];
    error('something wrong in createHEXmatrixinterleaved.m')
end
%now shift it as to be ok wrt old HEX versions
M(:,2)=M(:,2)+uprowlim*cos(30*pi/180);%y
M(:,1)=M(:,1)-floor(cols/2-1);

if rem(cols,2) == 1
    M(:,1)=M(:,1)-0.5;
end

if makefigures==1
    figs(1)=figure('OuterPosition',[100, 100, 800, 800]);
    for m=1:nkids
        text(M(m,1),M(m,2),num2str(oneDarray(m)));hold on
    end
    
    axis([-1.4*botcollim 1.4*upcollim -1.4*botcollim 1.4*upcollim])
    
    figs(2)=figure('OuterPosition',[100, 100, 800, 800]);
    for m=1:kn-1
        text(M(m,1),M(m,2),num2str(m));hold on
    end
    axis([-1.4*botcollim 1.4*upcollim -1.4*botcollim 1.4*upcollim])
else
    figs=0;
end
end

function [M,oneDarray,nkids,figs]=createmeandermatrix_HEX_mono(rows,cols,makefigures)
% rows is # rows, cols is # cols. rows must be largest
% simple monotonic increasing MKID number, no jumps around the edges.
% Creates EXACTY the same KIDp ositions as createmeandermatrix_interleaved_CenterKID
% but now in meandering like snake model
% no central KID
% BUT we use a simple increasing index 0...n, no +-

% generates M, a 1D matrix with positions (x,y) where to place the KIDs
% M creates HCP positions with rows of +1 varying length to make a rectangular fill
% M is the same as the old output of create2Dpositions_IL, still present in
% the other scripts to make masks

% generates oneDarray, matrix with F indices. Fres(n)=F0+df*oneDarray(n)
% same as the indices array in the old createinputmatrix_1Lc_IL inside the
% main scrips to make a mask

% generates plots of M and oneDarray on M (which represents the real KIDs
% as made)


close all;
isl = 0;

if nargin==0
    cols=6;rows=5;
end
%determine real number of KIDs
nkids=floor(rows/2)*(cols)+ceil(rows/2)*(cols-1);

%generate 1D array
oneDarray=0:1:nkids-1;
oneDarray=oneDarray';

%determine the limits of the array. rows need up and down condition, cols

%this is not required due to the x shift between adjecent rows
uprowlim=floor((rows-1)/2);%row 0 is the first... so lim is n-1
%botrowlim=ceil((rows-1)/2);%row 0 is the first... so lim is n-1

upcollim=ceil((cols)/2);%row 0 is the first... so lim is n-1
botcollim=floor((cols)/2);%row 0 is the first... so lim is n-1
%collim=cols/2;

%generate first position at (0,0)=> this is now the top left corner
kn=1;%kid number


nrows=0;
if rem(rows,2)==1 %odd rows, first row is smaller
    y=1;x=-0.5;%first KID ref
    while nrows<rows%
        y=y-1;
        x=x+0.5;
        
        for ptd=1:(cols-1)-isl%first row, shorter.
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;x=x+1;
        end
        for ptd=isl-1:-1:0%first row, shorter
            M(kn,1)=x+2*ptd-(isl-1);%X+ptd=last pos in col, ptd-(isl-1) is reversed couter+pos coprrrction
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;x=x+1;
        end
        x=x-1;%resetting last one
        nrows=nrows+1;
        %NEXT
        x=x+0.5;
        y=y-1;
        if nrows<rows
            for ptd=1:(cols)-isl%2nd rows, shorter.
                M(kn,1)=x;%x
                M(kn,2)=y*cos(30*pi/180);%y
                kn=kn+1;x=x-1;
            end
            for ptd=isl-1:-1:0
                M(kn,1)=x-2*ptd+(isl-1);%x, no correction needed
                M(kn,2)=y*cos(30*pi/180);%y
                kn=kn+1;x=x-1;
            end
            nrows=nrows+1;
        end
        x=x+1;%resetting last one
        
        %emergency catch
        if kn>100000
            disp('emergency catch')
            break;
        end
    end
    
    
elseif rem(rows,2)==0%even cols, first row is larger
    y=1;x=0;%first KID ref
    while nrows<rows
        y=y-1;
        x=x-0.5;
        for ptd=1:(cols)-isl%first row, longer.
            M(kn,1)=x;%x
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;x=x+1;
        end
        for ptd=isl-1:-1:0%first row, longer
            M(kn,1)=x+2*ptd-(isl-1);%X+ptd=last pos in col, ptd-(isl-1) is reversed couter+pos coprrrction
            M(kn,2)=y*cos(30*pi/180);%y
            kn=kn+1;x=x+1;
        end
        x=x-1;%resetting last one
        nrows=nrows+1;
        x=x-0.5;
        y=y-1;
        if nrows<rows
            for ptd=1:(cols-1)-isl%2nd rows, shorter.
                M(kn,1)=x;%x
                M(kn,2)=y*cos(30*pi/180);%y
                kn=kn+1;x=x-1;
            end
            for ptd=isl-1:-1:0
                M(kn,1)=x-2*ptd+(isl-1);%x, no correction needed
                M(kn,2)=y*cos(30*pi/180);%y
                kn=kn+1;x=x-1;
            end
            nrows=nrows+1;
        end
        x=x+1;%resetting last one
        
        %emergency catch
        if kn>100000
            disp('emergency catch')
            break;
        end
    end
    
    
end

if nkids~=kn-1
    [nkids kn-1]
    error('something wrong in createHEXmatrixinterleaved.m')
end
%now shift it as to be ok wrt old HEX versions
M(:,2)=M(:,2)+uprowlim*cos(30*pi/180);%y
M(:,1)=M(:,1)-floor(cols/2-1);
if rem(cols,2) == 1
    M(:,1)=M(:,1)-0.5;
end
if makefigures==1
    figs(1)=figure('OuterPosition',[100, 100, 800, 800]);
    for m=1:nkids
        %m
        text(M(m,1),M(m,2),num2str(oneDarray(m)));hold on
    end
    
    axis([-1.4*botcollim 1.4*upcollim -1.4*botcollim 1.4*upcollim])
    
    figs(2)=figure('OuterPosition',[100, 100, 800, 800]);
    for m=1:kn-1
        text(M(m,1),M(m,2),num2str(m));hold on
    end
    axis([-1.4*botcollim 1.4*upcollim -1.4*botcollim 1.4*upcollim])
else
    figs=0;
end
end

function keeswrite(strmat,filename)
%CASEWRITE Writes casenames from a string matrix to a file.
%   CASEWRITE(STRMAT,FILENAME) writes a list of names to a file, one per line.
%   FILENAME is the complete path to the desired file. If FILENAME does not
%   include directory information, the file will appear in the current directory.
%
%   CASEWRITE with just one input displays the File Open dialog box allowing
%   interactive naming of the file.

%   Copyright 1993-2004 The MathWorks, Inc.
%   $Revision: 2.9.2.1 $  $Date: 2003/11/01 04:25:22 $

if (nargin == 0)
    error('stats:casewrite:TooFewInputs',...
        'CASEWRITE requires at least one argument.');
end
if nargin == 1
    [F,P]=uiputfile('*');
    filename = [P,F];
end
fid = fopen(filename,'wt');

if fid == -1
    disp('Unable to open file.');
    return
end

if strcmp(computer,'MAC2')
    lf = setstr(13);
else
    lf = setstr(10);
end

lf = lf(ones(size(strmat,1),1),:);
lines  = [strmat lf]';

fprintf(fid,'%s',lines);
fclose(fid);
end

function writetofileCircles(Circle,fid,Layer)
%Circle has diameter xpos ypos 1D array (1 row)
fprintf(fid,['L L' num2str(Layer) ';\n']);%printing KIDs
fprintf(fid,'R ');
fprintf(fid,'% .0f ',1000*Circle);%to convert microns to nanometer
fprintf(fid,';\n');
end

function shiftedCircle=shiftCircle(Circle,shiftx,shifty)
%Circle has diameter xpos ypos
if ~isempty(Circle)
    shiftedCircle(1)=Circle(1);%diameter
    shiftedCircle(2)=Circle(2)+shiftx;
    shiftedCircle(3)=Circle(3)+shifty;
else
    shiftedCircle=[];
end
end

function write_Symbol_tofile(Symbol,fid,synumber)
for i=1:size(Symbol,1)
    fprintf(fid,['C ' num2str(synumber) ' T' ]);
    fprintf(fid,'% .0f ',1000*Symbol(i,1));
    fprintf(fid,' ');
    fprintf(fid,'% .0f ',1000*Symbol(i,2));
    fprintf(fid,';\n');%printing KIDs
end
end

function [Finalarray]=create_Farray_scaled_dF(Fcenter,df,oneDarray,forbiddenrange)
% creates Finiarray = F(GHz) in 1 column
% DOES do a scaled dF!!!! dF is now  a fraction of Fres!!
% needs oneDarray generated by createHEXmatrix_interleaved
%
%Updates with old version
% forbiddenrange is a 2x1 array [fstart fstop] in between which no KIDs will be placed%
% input rows 1,2,4 are oursourced to new sub-m file ([input,figs] = Get_Q_Lc_F0_Classic(input,narrayKIDs,Q,Lc_const,eps_eff))
% that has to run after this function

narrayKIDs=length(oneDarray);

deltaf = zeros(1,narrayKIDs);Finiarray = zeros(1,narrayKIDs);
Finalarray = zeros(narrayKIDs,1);
for n=1:narrayKIDs %creating initial F array
    if n==1
        if oneDarray(1)~=0
            error('first KID should be designed at Fcenter!')
        end
        deltaf(n)=NaN;
        Finiarray(n)=Fcenter;%
        Finalarray(n)=Finiarray(n);
    elseif n==2 %first two IDs are defined wrt first index in oneDarray, as a good refefernec does not exists
        deltaf(n)=Fcenter*df;
        Finiarray(n)=Fcenter+deltaf(n)*(oneDarray(n));
        Finalarray(n)=Finiarray(n);
    elseif n==3
        deltaf(n)=Fcenter*df*sign(oneDarray(n));%weird to make the plot of it look ok..
        Finiarray(n)=Fcenter+deltaf(n)*abs(oneDarray(n));
        Finalarray(n)=Finiarray(n);
    else
        deltaf(n)= input(n-2,3)*df*sign(oneDarray(n));
        Finalarray(n)=Finiarray(n-2)+deltaf(n);%wrt previous KID of same polarity
        %forbidden range
        if Finiarray(n)<forbiddenrange(1) %F is designed below our forbidden F region
            Finalarray(n)=Finiarray(n);
        else %is above the lower threshold
            Finalarray(n)=Finiarray(n)+forbiddenrange(2)-forbiddenrange(1);
        end
        if oneDarray(n-1)~=-oneDarray(n) && rem(n,2)~=0
            error('oneDarray should be 0 -n, +n or 0, +n,-n')
        end
    end
    
end

end

function [Finalarray,indices]=createinputmatrix_Square(rows,cols,Fcenter,df,Fresmatrix)
%indices is the same as oneDarray of the Hex functions
%creates FinalarrayF0[GHz] 

for n=1:rows
    indices(cols*(n-1)+1:cols*n)=Fresmatrix(n,:);%linear array of all rows of Fresmatrix appended
end
Finalarray(:,1) = Fcenter+indices*df;
end

function [Finalarray,indices]=createinputmatrix_SquareNew(rows,cols,Fcenter,df,Fresmatrix)
%indices is the same as oneDarray of the Hex functions
%creates FinalarrayF0[GHz] 

for n=1:rows
    indices(cols*(n-1)+1:cols*n)=Fresmatrix(n,:);%linear array of all rows of Fresmatrix appended
end
Finalarray(:,1) = Fcenter+indices*df;
end


function [positions]=create2Dpositions(rowss, colss)
%KIDarray is 
%calculates 1D array of the positions of each point in KID array wth
%respect to top left pixel. 1D aray poistions is filled by appending row
%after row of KIDarray
positions=zeros(rowss*colss,2);%rows cols, positions(1,:) is first row of KIDs
n=1;
for i=1:rowss%i is rows, is y
    for j=1:colss% j=cols, x
        positions(n,1)=j-1;%x
        positions(n,2)=i-1;%y
        n=n+1;
    end
end

end

function synum = writesymbols(fid,R,mesh,linewidth,gapwidth,SinglelayerKID,ncurves,writeassymbol)
%% defining symbols

% creates symbol definitions and write them to the start of mask file
% we create in the KID making function a 2 col n row matrix for each symbol
% type: Symbols{2} refers to the symbol 2 and has the nx2 array with the
% position of the symbol. These positions will be written to file
% NB: Symbols 1,2,3,4,5 are always there, the rest can be or cannot be.
% writing down a non existing symbol is fine, no data will be written.
%symbol 1: wide turn in KID
global widelinewidth widegapwidth
synum=1;
iniwrite_1_Symboltofile(fid,synum,'CPWturn180');
SCPWturn180{1}=CPWturn180(R,widelinewidth,widegapwidth,mesh);
writetofile(SCPWturn180,fid,1);
closewrite_1_Symboltofile(fid);

%symbol 2: wide turnin KID
synum=2;
iniwrite_1_Symboltofile(fid,synum,'CPWturn180mirror');
SCPWturn180mirror{1}=mirrorvert(CPWturn180(R,widelinewidth,widegapwidth,mesh));
writetofile(SCPWturn180mirror,fid,1);
closewrite_1_Symboltofile(fid);

%symbol 3: 90 degree near coupler
synum=3;
iniwrite_1_Symboltofile(fid,synum,'CPWturn90mirror');
if rem(ncurves,2)==1
    SCPWturn90{1}=mirrorvert(mirrorhor(CPWturn90(R,widelinewidth,widegapwidth,mesh)));
else
    SCPWturn90{1}=(mirrorhor(CPWturn90(R,widelinewidth,widegapwidth,mesh)));
end
writetofile(SCPWturn90,fid,1);
closewrite_1_Symboltofile(fid);

%symbol 4: first 90 degree after antenna
synum=4;
iniwrite_1_Symboltofile(fid,synum,'first90');
first90{1}=mirrorhor(mirrorvert(CPWturn90(R,linewidth,gapwidth,mesh)));
if SinglelayerKID==1
    writetofile(first90,fid,1);%1 layer KID
else
    first90Hyb{1}=mirrorhor(mirrorvert(barturn90(R,linewidth,mesh)));%Hybrid layer
    %first90SiN{1}=mirrorhor(mirrorvert(barturn90(R,linewidth+2*gapwidth+SiNpatchaw,mesh)));%Hybrid layer
    writetofile(first90Hyb,fid,4);%Hybrid
    %writetofile(first90SiN,fid,2);%Hybrid
    first90{2}=first90Hyb{1};%adding hybrid layer on KID layer to have no NbTiN below Al
    writetofile(first90,fid,1);%KID
end
closewrite_1_Symboltofile(fid);

%symbol 5: 2nd 90 degree after antenna
synum=5;
iniwrite_1_Symboltofile(fid,synum,'secnd90');
secnd90{1}=(mirrorvert(CPWturn90(R,linewidth,gapwidth,mesh)));
if SinglelayerKID==1
    writetofile(secnd90,fid,1);%1 layer KID
else
    secnd90Hyb{1}=(mirrorvert(barturn90(R,linewidth,mesh)));%Hybrid layer
    %secnd90SiN{1}=(mirrorvert(barturn90(R,linewidth+2*gapwidth+SiNpatchaw,mesh)));%Hybrid layer
    writetofile(secnd90Hyb,fid,4);%Hybrid
    %writetofile(secnd90SiN,fid,2);%Hybrid
    secnd90{2}=secnd90Hyb{1};%adding hybrid layer on KID layer to have no NbTiN below Al
    writetofile(secnd90,fid,1);%KID
end
closewrite_1_Symboltofile(fid);

%symbol 6: 180 degree after antenna (narrpw)
synum=6;
iniwrite_1_Symboltofile(fid,synum,'narrow180');
narrow180{1}=((CPWturn180(R,linewidth,gapwidth,mesh)));
if SinglelayerKID==1
    writetofile(narrow180,fid,1);%1 layer KID
else
    narrowHyb{1}=((barturn180(R,linewidth,mesh)));%Hybrid layer
    writetofile(narrowHyb,fid,4);%Hybrid
    narrow180{2}=narrowHyb{1};%adding hybrid layer on KID layer to have no NbTiN below Al
    writetofile(narrow180,fid,1);%KID
end
closewrite_1_Symboltofile(fid);

%symbol 6: 180 degree after antenna (narrpw)
synum=7;
iniwrite_1_Symboltofile(fid,synum,'narrow180mirror');
narrow180M{1}=(mirrorvert(CPWturn180(R,linewidth,gapwidth,mesh)));
if SinglelayerKID==1
    writetofile(narrow180M,fid,1);%1 layer KID
else
    narrowHybM{1}=(mirrorvert(barturn180(R,linewidth,mesh)));%Hybrid layer
    writetofile(narrowHybM,fid,4);%Hybrid
    narrow180M{2}=narrowHybM{1};%adding hybrid layer on KID layer to have no NbTiN below Al
    writetofile(narrow180M,fid,1);%KID
end
closewrite_1_Symboltofile(fid);

%symbol 8 mirror 4: first 90 degree after antenna
synum=8;
iniwrite_1_Symboltofile(fid,synum,'first90Mirror');
first90M{1}=((CPWturn90(R,linewidth,gapwidth,mesh)));
if SinglelayerKID==1
    writetofile(first90M,fid,1);%1 layer KID
else
    first90HybM{1}=((barturn90(R,linewidth,mesh)));%Hybrid layer
    writetofile(first90HybM,fid,4);%Hybrid
    first90M{2}=first90HybM{1};%adding hybrid layer on KID layer to have no NbTiN below Al
    writetofile(first90M,fid,1);%KID
end
closewrite_1_Symboltofile(fid);

%symbol 9 mirror 5: 2nd 90 degree after antenna
synum=9;
iniwrite_1_Symboltofile(fid,synum,'secnd90Mirror');
secnd90M{1}=(mirrorhor(CPWturn90(R,linewidth,gapwidth,mesh)));
if SinglelayerKID==1
    writetofile(secnd90M,fid,1);%1 layer KID
else
    secnd90HybM{1}=(mirrorhor(barturn90(R,linewidth,mesh)));%Hybrid layer
    writetofile(secnd90HybM,fid,4);%Hybrid
    secnd90M{2}=secnd90HybM{1};%adding hybrid layer on KID layer to have no NbTiN below Al
    writetofile(secnd90M,fid,1);%KID
end
closewrite_1_Symboltofile(fid);

%symbol 10: =1 with hybris
synum=10;
iniwrite_1_Symboltofile(fid,synum,'CPWturn180Hybrid');
narrow180{1}=((CPWturn180(R,widelinewidth,widegapwidth,mesh)));
if SinglelayerKID==1
    writetofile(narrow180,fid,1);%1 layer KID
else
    narrowHyb{1}=((barturn180(R,widelinewidth,mesh)));%Hybrid layer
    writetofile(narrowHyb,fid,4);%Hybrid
    narrow180{2}=narrowHyb{1};%adding hybrid layer on KID layer to have no NbTiN below Al
    writetofile(narrow180,fid,1);%KID
end
closewrite_1_Symboltofile(fid);

%symbol 11: =2 with hybrids
synum=11;
iniwrite_1_Symboltofile(fid,synum,'CPWturn180Hybridmirror');
narrow180M{1}=(mirrorvert(CPWturn180(R,widelinewidth,widegapwidth,mesh)));
if SinglelayerKID==1
    writetofile(narrow180M,fid,1);%1 layer KID
else
    narrowHybM{1}=(mirrorvert(barturn180(R,widelinewidth,mesh)));%Hybrid layer
    writetofile(narrowHybM,fid,4);%Hybrid
    narrow180M{2}=narrowHybM{1};%adding hybrid layer on KID layer to have no NbTiN below Al
    writetofile(narrow180M,fid,1);%KID
end
closewrite_1_Symboltofile(fid);

%symbol 12: 90 degree near coupler
synum=12;
iniwrite_1_Symboltofile(fid,synum,'CPWturn90mirrorH');
if rem(ncurves,2)==1
    SCPWturn90{1}=mirrorvert(mirrorhor(CPWturn90(R,widelinewidth,widegapwidth,mesh)));
else
    SCPWturn90{1}=(mirrorhor(CPWturn90(R,widelinewidth,widegapwidth,mesh)));
end
if rem(ncurves,2)==1
    SCPWturn90Hyb{1}=mirrorvert(mirrorhor(barturn90(R,widelinewidth,mesh)));
else
    SCPWturn90Hyb{1}=(mirrorhor(barturn90(R,widelinewidth,mesh)));
end
writetofile(SCPWturn90Hyb,fid,4);%Hybrid
SCPWturn90{2}=SCPWturn90Hyb{1};
writetofile(SCPWturn90,fid,1);
closewrite_1_Symboltofile(fid);


%symbol 13: first 90 degree after antenna WIDE
synum=13;
iniwrite_1_Symboltofile(fid,synum,'first90Wide');
first90Wide{1}=mirrorhor(mirrorvert(CPWturn90(R,widelinewidth,widegapwidth,mesh)));
writetofile(first90Wide,fid,1);%KID
closewrite_1_Symboltofile(fid);

%symbol 14: 2nd 90 degree after antenna WIDE
synum=14;
iniwrite_1_Symboltofile(fid,synum,'secnd90Wide');
secnd90Wide{1}=(mirrorvert(CPWturn90(R,widelinewidth,widegapwidth,mesh)));
writetofile(secnd90Wide,fid,1);%KID
closewrite_1_Symboltofile(fid);

%symbol 15: first 90 degree after antenna WIDE mirror (mirror 13)
synum=15;
iniwrite_1_Symboltofile(fid,synum,'first90WideMirror');
first90WideMirror{1}=((CPWturn90(R,widelinewidth,widegapwidth,mesh)));
writetofile(first90WideMirror,fid,1);%KID
closewrite_1_Symboltofile(fid);

%symbol 16: 2nd 90 degree after antenna WIDE mirror (mirror 14)
synum=16;
iniwrite_1_Symboltofile(fid,synum,'secnd90WideMirror');
secnd90WideMirror{1}=(mirrorhor(CPWturn90(R,widelinewidth,widegapwidth,mesh)));
writetofile(secnd90WideMirror,fid,1);%KIDclosewrite_1_Symboltofile(fid);

if writeassymbol==1
    closewrite_1_Symboltofile(fid);%KIDs will be written as symbol
elseif writeassymbol==0
    closewrite_All_Symbolstofile(fid,synum+1);%default
end
end

function iniwrite_1_Symboltofile(fid,synumber,symbolname)
%synumber is number of the symbol.
%symbolname is string with symbol name
fprintf(fid,['\nDS' num2str(synumber) ' 1 10;\n9 ' symbolname ';\n']);
end

function closewrite_1_Symboltofile(fid)
fprintf(fid,'DF;');
end

function closewrite_All_Symbolstofile(fid,synumber)
%synumber is number of the last symbol +1.
fprintf(fid,['DF;\n(Top level;);\nDS' num2str(synumber) ' 1 10;\n9 MainSymbol;\n']);
end

