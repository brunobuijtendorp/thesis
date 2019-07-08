
function writeTlineOnesidedSQUARE(H,kidheight,KIDdistance,RTL,tlgap,tlwidth,mesh,rows,cols,fid)

global tlblength tlbwidth tlpolyw  SiNpatchaw TLbridges

tlpolyl=tlblength;
realtlblength=tlblength+4*tlbwidth;
tlineww=tlwidth+2*SiNpatchaw;
tlSiO2length=tlpolyl;
tlSiO2width=tlpolyw;

vlineL=KIDdistance-2*RTL;
arraywidth=(cols)*KIDdistance;            %x, cols
arrayheight=(rows-1)*KIDdistance;           %y rows

%drawing 1 vert part though line, right and left%
TLvpartL{1}=shiftXY(mirr45(makeCPW(vlineL,tlwidth,tlgap)),0,0);%vertical bar around (0,0)
TLvpartL{2}=shiftXY(mirrorhor(mirrorvert(CPWturn90(RTL,tlwidth,tlgap,mesh))),RTL,vlineL/2+RTL);%top bend
TLvpartL{3}=shiftXY(mirrorvert((CPWturn90(RTL,tlwidth,tlgap,mesh))),RTL,-vlineL/2-RTL);%bot bend
TLvpartR{1}=shiftXY(mirr45(makeCPW(vlineL,tlwidth,tlgap)),0,0);%vertical bar around (0,0)
TLvpartR{2}=shiftXY(mirrorhor((CPWturn90(RTL,tlwidth,tlgap,mesh))),-RTL,vlineL/2+RTL);%top bend
TLvpartR{3}=shiftXY((CPWturn90(RTL,tlwidth,tlgap,mesh)),-RTL,-vlineL/2-RTL);%bot bend
%drawing bridges at top and bottom vertical parts
BridgeL(1,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,vlineL/2-tlbwidth/2);%top
BridgeL(2,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,-vlineL/2+tlbwidth/2);
BridgeL(3,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),RTL,vlineL/2+RTL);
BridgeL(4,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),RTL,-vlineL/2-RTL);
BridgeR(1,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,vlineL/2-tlbwidth/2);%top
BridgeR(2,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,-vlineL/2+tlbwidth/2);
BridgeR(3,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),-RTL,vlineL/2+RTL);
BridgeR(4,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),-RTL,-vlineL/2-RTL);
%drawing 1 vert part worst = %
WvpartL{1}=shiftXY(mirr45(makebar(vlineL,tlineww)),0,0);%vertical bar around (0,0)
WvpartL{2}=shiftXY(mirrorhor(mirrorvert(barturn90(RTL,tlineww,mesh))),RTL,vlineL/2+RTL);%top bend
WvpartL{3}=shiftXY(mirrorvert((barturn90(RTL,tlineww,mesh))),RTL,-vlineL/2-RTL);%bot bend
WvpartR{1}=shiftXY(mirr45(makebar(vlineL,tlineww)),0,0);%vertical bar around (0,0)
WvpartR{2}=shiftXY(mirrorhor((barturn90(RTL,tlineww,mesh))),-RTL,vlineL/2+RTL);%top bend
WvpartR{3}=shiftXY((barturn90(RTL,tlineww,mesh)),-RTL,-vlineL/2-RTL);%bot bend
%drawing bridge support
SiO2L(1,:,:)=shiftXY((makebar(tlSiO2length,tlSiO2width)),0,vlineL/2-tlbwidth/2);%top
SiO2L(2,:,:)=shiftXY((makebar(tlSiO2length,tlSiO2width)),0,-vlineL/2+tlbwidth/2);
SiO2L(3,:,:)=shiftXY(mirr45(makebar(tlSiO2length,tlSiO2width)),RTL,vlineL/2+RTL);
SiO2L(4,:,:)=shiftXY(mirr45(makebar(tlSiO2length,tlSiO2width)),RTL,-vlineL/2-RTL);
SiO2R(1,:,:)=shiftXY((makebar(tlSiO2length,tlSiO2width)),0,vlineL/2-tlbwidth/2);%top
SiO2R(2,:,:)=shiftXY((makebar(tlSiO2length,tlSiO2width)),0,-vlineL/2+tlbwidth/2);
SiO2R(3,:,:)=shiftXY(mirr45(makebar(tlSiO2length,tlSiO2width)),-RTL,vlineL/2+RTL);
SiO2R(4,:,:)=shiftXY(mirr45(makebar(tlSiO2length,tlSiO2width)),-RTL,-vlineL/2-RTL);
%simple bridges (same as left, but without shift)
STBridgeL(1,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,0-tlbwidth/2);%top
SBBridgeL(1,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,tlbwidth/2);
STBridgeL(2,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),RTL,RTL);
SBBridgeL(2,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),RTL,-RTL);
STBridgeR(1,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,-tlbwidth/2);%top
SBBridgeR(1,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,+tlbwidth/2);
STBridgeR(2,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),-RTL,RTL);
SBBridgeR(2,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),-RTL,-RTL);
STSiO2L(1,:,:)=shiftXY((makebar(tlSiO2length,tlSiO2width)),0,-tlbwidth/2);%top
SBSiO2L(1,:,:)=shiftXY((makebar(tlSiO2length,tlSiO2width)),0,+tlbwidth/2);
STSiO2L(2,:,:)=shiftXY(mirr45(makebar(tlSiO2length,tlSiO2width)),RTL,RTL);
SBSiO2L(2,:,:)=shiftXY(mirr45(makebar(tlSiO2length,tlSiO2width)),RTL,-RTL);
STSiO2R(1,:,:)=shiftXY((makebar(tlSiO2length,tlSiO2width)),0,-tlbwidth/2);%top
SBSiO2R(1,:,:)=shiftXY((makebar(tlSiO2length,tlSiO2width)),0,tlbwidth/2);
STSiO2R(2,:,:)=shiftXY(mirr45(makebar(tlSiO2length,tlSiO2width)),-RTL,RTL);
SBSiO2R(2,:,:)=shiftXY(mirr45(makebar(tlSiO2length,tlSiO2width)),-RTL,-RTL);

%real defining
j=1;%j counts all drawn Vertical tline parts
numvparts=rows-1;
jj=1;
addline = 0;
if rem(numvparts,2) == 1 %we add 1 bend in case of odd number of vertical sections
  addline = 1;
end

while j<=numvparts% i increments each Vertical tline parts!
    % R section
    % bridges (4) around the bends
    TLB{j}=shiftXY(BridgeR,arraywidth/2+RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);
    SiO2TLB{j}=shiftXY(SiO2R,arraywidth/2+RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);
    
    for ii=1:3 %3 items because TLvpartL{:} is 3 long (bend - line - bend)
        TL{(j-1)*3+ii}=shiftXY(TLvpartR{ii},arraywidth/2+RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);%
        W{(j-1)*3+ii}=shiftXY(WvpartR{ii},arraywidth/2+RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);%
    end
    
    j=j+1;jj=jj+1;
    if j>numvparts %
        break %leave the loop
    else
        %Left section
        TLB{j}=shiftXY(BridgeL,-arraywidth/2-RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);
        SiO2TLB{j}=shiftXY(SiO2L,-arraywidth/2-RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);
        for ii=1:3
            TL{(j-1)*3+ii}=shiftXY(TLvpartL{ii},-arraywidth/2-RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);
            W{(j-1)*3+ii}=shiftXY(WvpartL{ii},-arraywidth/2-RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);
        end
        j=j+1;jj=jj+1;
        
    end
end

if addline == 1 %add one more Vert section top left
    jj=0;
    %Left section
    TLB{j}=shiftXY(BridgeL,-arraywidth/2-RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);
    SiO2TLB{j}=shiftXY(SiO2L,-arraywidth/2-RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);
    for ii=1:3
        TL{(j-1)*3+ii}=shiftXY(TLvpartL{ii},-arraywidth/2-RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);
        W{(j-1)*3+ii}=shiftXY(WvpartL{ii},-arraywidth/2-RTL,arrayheight/2-kidheight-(jj-0.5)*KIDdistance);
    end
    %add horz part
    TL{(j-1)*3+4}=shiftXY(makeCPW(arraywidth,tlwidth,tlgap),0,arrayheight/2-kidheight-(jj-1)*KIDdistance);
    W{(j-1)*3+4}=shiftXY(makebar(arraywidth,tlineww),0,arrayheight/2-kidheight-(jj-1)*KIDdistance);
    nj=(j-1)*3+4+1;
    Top = arrayheight/2-kidheight+KIDdistance;j=j+1;
else
    Top = arrayheight/2-kidheight;
    nj=(j-1)*3+3+1;
end

% Connect to chip. NB: Square array is cenetred aroun (0,0)!
%parameters
horL = 1000;
Bot = -arrayheight/2-kidheight;
Left = -arraywidth/2;
Right = arraywidth/2;
XLIMChip = 9250; %distance from chip center to chip edge bond pad)

laatseL = XLIMChip - arraywidth/2 -2*RTL - horL;
if laatseL<0
    error('writeTLineOnesidedSquare: chip does not fit');
end
% Top right: straight - bend - vert - bend horz
TL{nj} =  shiftXY(makeCPW(horL,tlwidth,tlgap),Right+horL/2,Top); 
W{nj} =  shiftXY(makebar(horL,tlineww),Right+horL/2,Top); 
newX = Right+horL;
%
TL{nj+1} = shiftXY((mirrorhor(CPWturn90(RTL,tlwidth,tlgap,mesh))),newX,Top);%top bend shiftXY(mirrorhor((CPWturn90(RTL,tlwidth,tlgap,mesh))),-RTL,vlineL/2+RTL);%top bend
W{nj+1} = shiftXY((mirrorhor(barturn90(RTL,tlineww,mesh))),newX,Top);%top bend shiftXY(mirrorhor((CPWturn90(RTL,tlwidth,tlgap,mesh))),-RTL,vlineL/2+RTL);%top bend
TLB{j}=shiftXY(STBridgeR,newX+RTL,Top-RTL);
SiO2TLB{j}=shiftXY(STSiO2R,newX+RTL,Top-RTL);
j=j+1;    
newX = newX + RTL;newY = Top - RTL;
%
VertConH = Top - 2*RTL;
TL{nj+2} = shiftXY(mirr45(makeCPW(VertConH,tlwidth,tlgap)),newX,newY-(VertConH)/2);%vertical bar 
W{nj+2} = shiftXY(mirr45(makebar(VertConH,tlineww)),newX,newY-(VertConH)/2);%vertical bar 
newY = newY-(VertConH);
%
TL{nj+3} = shiftXY(mirrorvert((CPWturn90(RTL,tlwidth,tlgap,mesh))),newX+RTL,newY-RTL);%bot bend
W{nj+3} = shiftXY(mirrorvert((barturn90(RTL,tlineww,mesh))),newX+RTL,newY-RTL);%bot bend
TLB{j}=shiftXY(mirrorvert(SBBridgeR),newX,newY);
SiO2TLB{j}=shiftXY(mirrorvert(SBSiO2R),newX,newY);
j=j+1; 
newX = newX + RTL;newY = newY - RTL;
%
TL{nj+4} =  shiftXY(makeCPW(laatseL,tlwidth,tlgap),newX+laatseL/2,newY); 
W{nj+4} =  shiftXY(makebar(laatseL,tlineww),newX+laatseL/2,newY); 
[TL{nj+5},W{nj+5}] = bondpad(tlineww,tlwidth,tlgap,XLIMChip,0,1);
TLB{j}=shiftXY(mirrorvert(SBBridgeR(2,:,:)),newX- RTL + laatseL - tlSiO2width,newY + RTL);
SiO2TLB{j}=shiftXY(mirrorvert(SBSiO2R(2,:,:)),newX - RTL + laatseL - tlSiO2width,newY + RTL);
j=j+1; 
nj=nj+6;
% 

% bottom left left
TL{nj} =  shiftXY(makeCPW(horL,tlwidth,tlgap),Left-horL/2,Bot);
W{nj} =  shiftXY(makebar(horL,tlineww),Left-horL/2,Bot);
newX = Left-horL;
%
TL{nj+1} = shiftXY((mirrorvert(CPWturn90(RTL,tlwidth,tlgap,mesh))),newX,Bot);%bend
W{nj+1} = shiftXY((mirrorvert(barturn90(RTL,tlineww,mesh))),newX,Bot);%bend
TLB{j}=shiftXY(SBBridgeL,newX-RTL,Bot+RTL);
SiO2TLB{j}=shiftXY(SBSiO2L,newX-RTL,Bot+RTL);
newX = newX - RTL;newY = Bot + RTL;
VertConH = -Bot - 2*RTL;
j=j+1;  
%
TL{nj+2} = shiftXY(mirr45(makeCPW(VertConH,tlwidth,tlgap)),newX,newY+(VertConH)/2);%vertical bar 
W{nj+2} = shiftXY(mirr45(makebar(VertConH,tlineww)),newX,newY+(VertConH)/2);%vertical bar 
newY = newY+(VertConH);
%
TL{nj+3} = shiftXY((mirrorhor(CPWturn90(RTL,tlwidth,tlgap,mesh))),newX-RTL,newY+RTL);%bot bend
W{nj+3} = shiftXY((mirrorhor(barturn90(RTL,tlineww,mesh))),newX-RTL,newY+RTL);%bot bend
TLB{j}=shiftXY(mirrorvert(STBridgeL),newX,newY);
SiO2TLB{j}=shiftXY(mirrorvert(STSiO2L),newX,newY);
newX = newX - RTL;newY = newY + RTL;j=j+1;
%
TL{nj+4} =  shiftXY(makeCPW(laatseL,tlwidth,tlgap),newX-laatseL/2,newY); 
W{nj+4} =  shiftXY(makebar(laatseL,tlineww),newX-laatseL/2,newY); 
%
[TL{nj+5},W{nj+5}] = bondpad(tlineww,tlwidth,tlgap,-XLIMChip,0,0);
TLB{j}=shiftXY(mirrorvert(SBBridgeR(2,:,:)),newX - RTL - laatseL + tlSiO2width,newY + RTL);
SiO2TLB{j}=shiftXY(mirrorvert(SBSiO2R(2,:,:)),newX - RTL - laatseL + tlSiO2width,newY + RTL);

writetofile(TL,fid,1);
writetofile(W,fid,2);%worst = SiN = layer 2

if TLbridges>0
    writetofile(TLB,fid,4);
    writetofile(SiO2TLB,fid,6);
end
if H
    writetofile(TL,fid,5);%5 is layer 5
end
end
