
function [KID,SiNpatch,TLBRIDGES,Polyamid,Resistpatch,Hyb,newXout,WideL,Hybl] = ...
    defineSuperTHzKID(n_2arms,WIDCtot,R,L_aluline,ed,IDCtoTline,td,Couplength,line,tlwidth,tlgap,KIDdistance,tria,antenna,NbTiNph,SinglelayerKID)
% has randimized bridges ;-)
% writes all in microns
% the resist patch will be made respatM(=3) smaller than the NbTiN gap area @
% each LR side, and respattopbot(=1) narrower top-botom. The Alu lione
% climibing will be at least 2 um high!
global   widelinewidth widegapwidth  tlbwidth IDC_height...
     TLbridges tlblength tlpolyw SiNpatchaw mesh;
tlpolyl         = tlblength;
realtlblength   = tlblength+4*tlbwidth;
minAluconW = 2; %width of the alu line  that connects the alu strip to the NbTin (could be made a parameter later)
respatM = 3; %margin of the resist patch @ each edge(only in length)
respattopbot = 1;

AluconW = max([minAluconW line]);
if SinglelayerKID == 1 && antenna ~= 0
    error('single layer KID asked with antemna, will not work');
end

%START WRITING
% start at (newX,0) coordinate
% Alu line +_ patch
newX = 0 ;
newXout = newX;
hybm=1;nn=1;
if SinglelayerKID == 0
    KID{nn}     = shiftXY(makebar(L_aluline+1*tria,NbTiNph),newX,0);
    Hyb{hybm}   = shiftXY(makebar(L_aluline,line),newX,0);%horizontal arm at (0,0) of alu
    SiNpatch{1} = shiftXY(makebar(L_aluline+2*tria,NbTiNph+2*tria),newX,0);
    Resistpatch{1} = shiftXY(makebar(L_aluline+1*tria-2*respatM,NbTiNph-2*respattopbot),newX,0);
    nn=nn+1;hybm=hybm+1;
    THyb = makeantennas(antenna, tria, AluconW, NbTiNph,L_aluline);
    
    if ~isempty(THyb)
        Hyb{hybm} = shiftXY(THyb,newX,0);
        hybm = hybm +1;
    end
    % connecing the patched section to the rest
    Hyb{hybm}   = shiftXY(makebar(tria,AluconW),newX-L_aluline/2-tria/2,0);%wider Alu sec tions
    hybm=hybm+1;
    Hyb{hybm}   = shiftXY(makebar(tria,AluconW),newX+L_aluline/2+tria/2,0); %wider Alu sec tions
    hybm=hybm+1;
    KID{nn}     = shiftXY(makeCPW(tria, widelinewidth, widegapwidth),newX-L_aluline/2-tria,0); % CPW of NbTiN
    nn=nn+1;
    if antenna == 0 && SinglelayerKID == 0%add bar to prevent NbTiN short cicrcuit
        KID{nn}     = shiftXY(makebar(tria/2, widelinewidth + 2* widegapwidth),newX-L_aluline/2-tria/4,0); % CPW of NbTiN
        nn=nn+1;
    end
    Hybl = L_aluline + 2*tria;
else%only write NbTiN
    gapwidth = (NbTiNph - line)/2; % NbTiNph         = linewidth + 2*gapwidth
    KID{nn}     = shiftXY(makeCPW(L_aluline+2*tria,line,gapwidth),newX-tria/2,0);
    Hyb{1}   = [];
    SiNpatch{1} = [];
    Resistpatch{1} = [];
    nn=nn+1;
    Hybl = 0;
end
newX = newX-L_aluline/2-1.5*tria;

%1/4 turn, left side, wide %
KID{nn} = shiftXY(mirrorhor(mirrorvert(CPWturn90(R,widelinewidth,widegapwidth,mesh))),newX,0);
newY=-R;        %new Y origin, i.e. Y coordinate where we should add next part%
newX = newX-R;
nn=nn+1;
WideL = 0.5*pi*R + ed;

%ed part left
KID{nn}=shiftXY(mirr45(makeCPW(ed,widelinewidth, widegapwidth)),newX,newY-ed/2);
nn=nn+1;
newY=newY-ed;   %new Y origin, i.e. Y coordinate where we should add next part%

%put IDC makeIDC(n_2arms, Widc);
daIDC=shiftKID(makeIDC(n_2arms,WIDCtot),newX,newY);
KID(nn:nn+length(daIDC)-1) = daIDC;
newY = newY - IDC_height;
nn=nn+length(daIDC);

%vert part to coupler
cd_kidgaps=IDCtoTline - td - widelinewidth - 2* widegapwidth; %Vert section to coupler
KID{nn}=shiftXY(mirr45(makeCPW(cd_kidgaps,widelinewidth,widegapwidth)),newX,newY-cd_kidgaps/2);%vert part to coupler
nn=nn+1;

%coupler structure
newY=newY-cd_kidgaps- widelinewidth/2 -  widegapwidth;%line/2 higher because coupler line center is line/2 higher than bottom last vertical bar%
KID{nn}=shiftXY(makeCPW(Couplength/2-widelinewidth/2,widelinewidth, widegapwidth),-Couplength/4-widelinewidth/4+newX,newY);%coupler left
nn=nn+1;
KID{nn}=shiftXY(makeCPW(Couplength/2-widelinewidth/2,widelinewidth, widegapwidth),+Couplength/4+widelinewidth/4+newX,newY);%coupler right
nn=nn+1;
%3 remaining bla's to finish the coupler
temp=makebar(widegapwidth,widelinewidth+2*widegapwidth);%bar for KID end and coupler short
KID{nn}=shiftXY(temp,-Couplength/2-widegapwidth/2+newX,newY);
nn=nn+1;
KID{nn}=shiftXY(temp,+Couplength/2+widegapwidth/2+newX,newY);
nn=nn+1;
KID{nn}=shiftXY(makebar(widelinewidth,widegapwidth),newX,newY-widelinewidth/2-widegapwidth/2);
mm=nn+1;


%now Tline; symmetric around newXout

mm=mm+1;
newY=newY-widegapwidth-widelinewidth/2-td-tlgap-tlwidth/2;%Y=0
KID{mm}=shiftXY(makebar(KIDdistance,tlgap),newXout,newY+tlgap/2+tlwidth/2);
SiNpatch{2}=shiftXY(makebar(KIDdistance,tlwidth+2*SiNpatchaw),newXout,newY);
%bottom half added
mm=mm+1;
KID{mm}=shiftXY(makebar(KIDdistance,tlgap),newXout,newY-tlgap/2-tlwidth/2);
mm=mm+1;

%Tline bridges: 
% symmetric with coupler! (newX)
Polyamid{1}=[];TLBRIDGES{1}=[];%otherwise prgram crashes
if TLbridges>0
    Xposleft=-1.0*Couplength-(1+10*rand*tria)+newX;%
    Xposright=1.0*Couplength+(1+10*rand*tria)+newX;
    Polyamid{1}=shiftXY((makebar(tlpolyw,tlpolyl)),Xposleft,newY);%tlSiO2length
    pct=2;
    TLBRIDGES{1}=shiftXY((makebar(tlbwidth,realtlblength)),Xposleft,newY);%tlSiO2length
    if TLbridges==1
        TLBRIDGES{2}=shiftXY((makebar(tlbwidth,realtlblength)),Xposright,newY);
        Polyamid{2}=shiftXY((makebar(tlpolyw,tlpolyl)),Xposright,newY);
        pct=3;
    end
    
end
%plotkid(KID,'r')
%figure(1234);plotkid(SiNpatch,'r');
end
