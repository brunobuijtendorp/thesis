
function [TL,TLB,SiO2TLB,SiNpatch]=writeTlineOnesided(H,kidheight,KIDdistance,RTL,tlgap,tlwidth,mesh,rows,cols,fid,ArrayWidthAdjust,ArrayTLShift,blockshift,writeassymbol)
%updated for HCP
%udated for odd rows
%draws also KID Tlines
global tlblength tlbwidth tlpolyw SiNpatchaw

realtlblength=tlblength+4*tlbwidth;
tlineww=tlwidth+2*SiNpatchaw;

tlpolyl=tlblength;
tlSiO2length=tlpolyl;
tlSiO2width=tlpolyw;

arraywidth=(cols)*KIDdistance+ArrayWidthAdjust;            %x, cols
arrayheight=(rows-1)*KIDdistance*cos(30*pi/180);           %y rows HCP
KIDdistanceY=KIDdistance*cos(30*pi/180);

vlineL=(KIDdistanceY-2*RTL);%shorter distance!

%drawing 1 vert part though line, right and left%
TLvpartleft{1}=shiftXY(mirr45(makeCPW(vlineL,tlwidth,tlgap)),0,0);%vertical bar around (0,0)
TLvpartleft{2}=shiftXY(mirrorhor(mirrorvert(CPWturn90(RTL,tlwidth,tlgap,mesh))),RTL,vlineL/2+RTL);%top bend
TLvpartleft{3}=shiftXY(mirrorvert((CPWturn90(RTL,tlwidth,tlgap,mesh))),RTL,-vlineL/2-RTL);%bot bend
TLvpartR{1}=shiftXY(mirr45(makeCPW(vlineL,tlwidth,tlgap)),0,0);%vertical bar around (0,0)
TLvpartR{2}=shiftXY(mirrorhor((CPWturn90(RTL,tlwidth,tlgap,mesh))),-RTL,vlineL/2+RTL);%top bend
TLvpartR{3}=shiftXY((CPWturn90(RTL,tlwidth,tlgap,mesh)),-RTL,-vlineL/2-RTL);%bot bend
%drawing 1 vert part worst = %
Wvpartleft{1}=shiftXY(mirr45(makebar(vlineL,tlineww)),0,0);%vertical bar around (0,0)
Wvpartleft{2}=shiftXY(mirrorhor(mirrorvert(barturn90(RTL,tlineww,mesh))),RTL,vlineL/2+RTL);%top bend
Wvpartleft{3}=shiftXY(mirrorvert((barturn90(RTL,tlineww,mesh))),RTL,-vlineL/2-RTL);%bot bend
WvpartR{1}=shiftXY(mirr45(makebar(vlineL,tlineww)),0,0);%vertical bar around (0,0)
WvpartR{2}=shiftXY(mirrorhor((barturn90(RTL,tlineww,mesh))),-RTL,vlineL/2+RTL);%top bend
WvpartR{3}=shiftXY((barturn90(RTL,tlineww,mesh)),-RTL,-vlineL/2-RTL);%bot bend
%drawing bridges at top and bottom vertical parts
BridgeL(1,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,vlineL/2-tlbwidth/2);%top
BridgeL(2,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,-vlineL/2+tlbwidth/2);
BridgeL(3,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),RTL,vlineL/2+RTL);
BridgeL(4,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),RTL,-vlineL/2-RTL);
BridgeR(1,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,vlineL/2-tlbwidth/2);%top
BridgeR(2,:,:)=shiftXY((makebar(realtlblength,tlbwidth)),0,-vlineL/2+tlbwidth/2);
BridgeR(3,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),-RTL,vlineL/2+RTL);
BridgeR(4,:,:)=shiftXY(mirr45(makebar(realtlblength,tlbwidth)),-RTL,-vlineL/2-RTL);
%drawing SiO2 at top and bottom vertical parts
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

%horizontal Tlines
TLpatch{1}=shiftXY((makeCPW(arraywidth,tlwidth,tlgap)),0,0);%
SiNp{1}=shiftXY((makebar(arraywidth,tlineww)),0,0);%
%TLpatch_C{1}=shiftXY((makebar(KIDdistance/2,tlinecw)),0,0);%


%rem(rows,2) always 0, always even # rows.....
%real defining
j=1;%j counts all drawn Vertical tline parts

numvparts=rows;

jj=1;

%real drawing
while j<=numvparts% i increments each Vertical tline parts! start left side
    TLB{j}=shiftXY(BridgeL,-RTL-arraywidth/2+ArrayTLShift,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);
    SiO2TLB{j}=shiftXY(SiO2L,-RTL-arraywidth/2+ArrayTLShift,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);
    for ii=1:3
        TL{(j-1)*4+ii+1}=shiftXY(TLvpartleft{ii},-RTL-arraywidth/2+ArrayTLShift,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);%
        SiNpatch{(j-1)*4+ii+1}=shiftXY(Wvpartleft{ii},-RTL-arraywidth/2+ArrayTLShift,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);%
        %TLc{(j-1)*3+ii}=shiftXY(TLC_l{ii},-RTL-arraywidth/2+ArrayTLShift,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);%
    end
    TL{(j-1)*4+1}=shiftXY(TLpatch{1},+ArrayTLShift,-kidheight-KIDdistanceY/2-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);%
    SiNpatch{(j-1)*4+1}=shiftXY(SiNp{1},+ArrayTLShift,-kidheight-KIDdistanceY/2-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);%
    
    j=j+1;jj=jj+1;
    
    if j>numvparts
        break
    else
        TLB{j}=shiftXY(BridgeR,+RTL+arraywidth/2+ArrayTLShift,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);
        SiO2TLB{j}=shiftXY(SiO2R,+RTL+arraywidth/2+ArrayTLShift,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);
        for ii=1:3
            TL{(j-1)*4+ii+1}=shiftXY(TLvpartR{ii},+RTL+arraywidth/2+ArrayTLShift,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);%
            SiNpatch{(j-1)*4+ii+1}=shiftXY(WvpartR{ii},+RTL+arraywidth/2+ArrayTLShift,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);%
            %TLc{(j-1)*3+ii}=shiftXY(TLC_r{ii},+RTL+arraywidth/2+ArrayTLShift,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);%
        end
        TL{(j-1)*4+1}=shiftXY(TLpatch{1},+ArrayTLShift,-kidheight-KIDdistanceY/2-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);%-KIDdistance/2
        SiNpatch{(j-1)*4+1}=shiftXY(SiNp{1},+ArrayTLShift,-kidheight-KIDdistanceY/2-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);%-KIDdistance/2
        j=j+1;jj=jj+1;
    end
end
j=j-1;

if rem(numvparts,2) == 1
    %we remove unnecesarry vertical part
    TL((j-1)*4+1+1:(j-1)*4+1+3)=[];
    SiNpatch((j-1)*4+1+1:(j-1)*4+1+3)=[];
    TLB(j)=[];
    SiO2TLB(j)=[];
    Bot = -arrayheight/2-kidheight;
else
    %we add a horizontal line arraywidth
    TL{(j-1)*3+4}=shiftXY(makeCPW(arraywidth,tlwidth,tlgap),0,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);
    SiNpatch{(j-1)*3+4}=shiftXY(makebar(arraywidth,tlineww),0,-kidheight-KIDdistanceY-(jj-1.5)*1*KIDdistanceY+arrayheight/2+blockshift);
    Bot = -arrayheight/2-kidheight - KIDdistanceY;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Connect to chip. NB: Square array is cenetred aroun (0,0)!
%parameters
horL = 1000;
Top = arrayheight/2-kidheight;

Left = -arraywidth/2+ArrayTLShift;
Right = arraywidth/2+ArrayTLShift;
XLIMChip = 9250; %distance from chip center to chip edge bond pad)

laatseL = XLIMChip - arraywidth/2 -2*RTL - horL;
if laatseL<0
    error('writeTLineOnesidedSquare: chip does not fit');
end
nj=(j-1)*3+3+1;

% Top right: straight - bend - vert - bend horz
TL{nj} =  shiftXY(makeCPW(horL,tlwidth,tlgap),Right+horL/2,Top); 
SiNpatch{nj} =  shiftXY(makebar(horL,tlineww),Right+horL/2,Top); 
newX = Right+horL;
%
TL{nj+1} = shiftXY((mirrorhor(CPWturn90(RTL,tlwidth,tlgap,mesh))),newX,Top);%top bend shiftXY(mirrorhor((CPWturn90(RTL,tlwidth,tlgap,mesh))),-RTL,vlineL/2+RTL);%top bend
SiNpatch{nj+1} = shiftXY((mirrorhor(barturn90(RTL,tlineww,mesh))),newX,Top);%top bend shiftXY(mirrorhor((CPWturn90(RTL,tlwidth,tlgap,mesh))),-RTL,vlineL/2+RTL);%top bend
TLB{j}=shiftXY(STBridgeR,newX+RTL,Top-RTL);
SiO2TLB{j}=shiftXY(STSiO2R,newX+RTL,Top-RTL);
j=j+1;    
newX = newX + RTL;newY = Top - RTL;
%
VertConH = Top - 2*RTL;
TL{nj+2} = shiftXY(mirr45(makeCPW(VertConH,tlwidth,tlgap)),newX,newY-(VertConH)/2);%vertical bar 
SiNpatch{nj+2} = shiftXY(mirr45(makebar(VertConH,tlineww)),newX,newY-(VertConH)/2);%vertical bar 
newY = newY-(VertConH);
%
TL{nj+3} = shiftXY(mirrorvert((CPWturn90(RTL,tlwidth,tlgap,mesh))),newX+RTL,newY-RTL);%bot bend
SiNpatch{nj+3} = shiftXY(mirrorvert((barturn90(RTL,tlineww,mesh))),newX+RTL,newY-RTL);%bot bend
TLB{j}=shiftXY(mirrorvert(SBBridgeR),newX,newY);
SiO2TLB{j}=shiftXY(mirrorvert(SBSiO2R),newX,newY);
j=j+1; 
newX = newX + RTL;newY = newY - RTL;
%
TL{nj+4} =  shiftXY(makeCPW(laatseL,tlwidth,tlgap),newX+laatseL/2,newY); 
SiNpatch{nj+4} =  shiftXY(makebar(laatseL,tlineww),newX+laatseL/2,newY); 
[TL{nj+5},SiNpatch{nj+5}] = bondpad(tlineww,tlwidth,tlgap,XLIMChip,0,1);
TLB{j}=shiftXY(mirrorvert(SBBridgeR(2,:,:)),newX- RTL + laatseL - tlSiO2width,newY + RTL);
SiO2TLB{j}=shiftXY(mirrorvert(SBSiO2R(2,:,:)),newX - RTL + laatseL - tlSiO2width,newY + RTL);
j=j+1; 
nj=nj+6;
% 

% bottom left left
TL{nj} =  shiftXY(makeCPW(horL,tlwidth,tlgap),Left-horL/2,Bot);
SiNpatch{nj} =  shiftXY(makebar(horL,tlineww),Left-horL/2,Bot);
newX = Left-horL;
%
TL{nj+1} = shiftXY((mirrorvert(CPWturn90(RTL,tlwidth,tlgap,mesh))),newX,Bot);%bend
SiNpatch{nj+1} = shiftXY((mirrorvert(barturn90(RTL,tlineww,mesh))),newX,Bot);%bend
TLB{j}=shiftXY(SBBridgeL,newX-RTL,Bot+RTL);
SiO2TLB{j}=shiftXY(SBSiO2L,newX-RTL,Bot+RTL);
newX = newX - RTL;newY = Bot + RTL;
VertConH = -Bot - 2*RTL;
j=j+1;  
%
TL{nj+2} = shiftXY(mirr45(makeCPW(VertConH,tlwidth,tlgap)),newX,newY+(VertConH)/2);%vertical bar 
SiNpatch{nj+2} = shiftXY(mirr45(makebar(VertConH,tlineww)),newX,newY+(VertConH)/2);%vertical bar 
newY = newY+(VertConH);
%
TL{nj+3} = shiftXY((mirrorhor(CPWturn90(RTL,tlwidth,tlgap,mesh))),newX-RTL,newY+RTL);%bot bend
SiNpatch{nj+3} = shiftXY((mirrorhor(barturn90(RTL,tlineww,mesh))),newX-RTL,newY+RTL);%bot bend
TLB{j}=shiftXY(mirrorvert(STBridgeL),newX,newY);
SiO2TLB{j}=shiftXY(mirrorvert(STSiO2L),newX,newY);
newX = newX - RTL;newY = newY + RTL;
j=j+1; 
%
TL{nj+4} =  shiftXY(makeCPW(laatseL,tlwidth,tlgap),newX-laatseL/2,newY); 
SiNpatch{nj+4} =  shiftXY(makebar(laatseL,tlineww),newX-laatseL/2,newY); 
%
[TL{nj+5},SiNpatch{nj+5}] = bondpad(tlineww,tlwidth,tlgap,-XLIMChip,0,0);
TLB{j}=shiftXY(mirrorvert(SBBridgeR(2,:,:)),newX - RTL - laatseL + tlSiO2width,newY + RTL);
SiO2TLB{j}=shiftXY(mirrorvert(SBSiO2R(2,:,:)),newX - RTL - laatseL + tlSiO2width,newY + RTL);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if writeassymbol==0
    writetofile(TL,fid,1);
    writetofile(SiNpatch,fid,2);
    
    writetofile(TLB,fid,4);
    writetofile(SiO2TLB,fid,6);
    
    if H
        writetofile(TL,fid,5);%5 is layer 5
    end
end

end
