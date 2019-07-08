
function [KID,SiNpatch,TLBRIDGES,Polyamid,Hyb,Symbols,tl,htl]=defineKID(Qwave,R,Larm,Kid_dL,ed,cd,td,Lc,line,gap,n,tlwidth,tlgap,KIDdistance,tria,coupL,coupG,vpn,antenna)
%BRIDGES IS USED TO WRITE THE CIRCLE FOR ANTENNA ABSORBER
global   widelinewidth widegapwidth  tlbwidth ...
    maxLc TLbridges bridgefromcoupler tlblength tlpolyw fracn...
    FullHybrid SiNpatchaw BigSiN;

%NB: Tline is the last 2 parts of KID struct array
Lsmallarm=Larm/2-R+Kid_dL;%KID part that varies in length = last horizontal arm to coupler. at Fres length=Larm/2-R
WR=(widelinewidth+2*widegapwidth)/(line + 2*gap);     %KID width coupler section/KIDwidth antenna section.

tlpolyl=tlblength;
realtlblength=tlblength+4*tlbwidth;

%START WRITING

if fracn<1 && fracn>=-1 %Width transition in the first part of the KID
    if fracn==-1 %new case, width transition in first line
        %first 1/2 arm
        hybm=1;nn=1;
        KID{nn}=shiftXY(makeCPW(Larm/2-tria,line,gap),-Larm/4+tria/2,0);
        Hyb{hybm}=shiftXY(makebar(Larm/2+tria/2,line),-Larm/4+tria/4,0);%horizontal arm at (0,0)
        KID{nn+1}=shiftXY(makebar(Larm/2-tria,line),-Larm/4+tria/2,0);%horizontal arm at (0,0)
        nn=nn+2;
        triangle(1,:,:)=[0 0 tria tria ;  WR*(line/2+gap) widelinewidth/2 line/2 line/2+gap];
        triangle(2,:,:)=[ 0 0 tria tria ;  -WR*(line/2+gap) -widelinewidth/2 -line/2 -(line/2+gap) ];
        triangle(3,:,:)=[tria/2 tria/2 tria tria;  (widelinewidth+line)/4 -(widelinewidth+line)/4 -line/2 line/2];
        KID{nn}=shiftXY(triangle,-Larm/2,0);
        if BigSiN == 0
            SiNpatch{1}=shiftXY(makebar(2*SiNpatchaw+tria,2*SiNpatchaw+WR*(line+2*gap)),-Larm/2+tria/2,0);
        end
        nn=nn+1;
        hybm=hybm+1;
        if FullHybrid==1
            tria_hyb(1,:,:)=[0 0 tria tria;  widelinewidth/2 -widelinewidth/2 -line/2 line/2];
            Hyb{hybm}=shiftXY(tria_hyb,-Larm/2,0);
            KID{nn}=Hyb{hybm};
            nn=nn+1;hybm=hybm+1;
        end
        tl=Larm/2;htl=Larm/2-tria/2;%l
        
        %1/4 turn, left side% wide
        Symbols{13}=[-Larm/2 0];
        newY=-R;        %new Y origin, i.e. Y coordinate where we should add next part%
        tl=tl+pi*R/2;%l
        
        %ed part left wide
        KID{nn}=shiftXY(mirr45(makeCPW(ed,widelinewidth,widegapwidth)),-R-Larm/2,newY-ed/2);
        nn=nn+1;
        if FullHybrid==1
            Hyb{hybm}=shiftXY(mirr45(makebar(ed,widelinewidth)),-R-Larm/2,newY-ed/2);%vert part left
            KID{nn}=Hyb{hybm};
            htl=tl;nn=nn+1;hybm=hybm+1;
        end
        newY=newY-ed;   %new Y origin, i.e. Y coordinate where we should add next part%
        tl=tl+ed;%l
        
        %1/4 turn, wide
        Symbols{14}=[-Larm/2,newY-1*R];
        newY=newY-R;
        sn1=1;sn2=1;sn6=1;sn7=1;sn10=1;sn11=1;
        tl=tl+pi*R/2;%l
        
        %first arm,
        %Wide
        
        KID{nn}=shiftXY(makeCPW(Larm,widelinewidth,widegapwidth),0,newY);
        nn=nn+1;
        tl=tl+Larm;%l
        if FullHybrid==1
            Hyb{hybm}=shiftXY(makebar(Larm,widelinewidth),0,newY);
            KID{nn}=Hyb{hybm};
            nn=nn+1;hybm=hybm+1;
            htl=tl;%l
        end
        
        
    elseif fracn<1 && fracn>0 %old case with fracn giving the position of transion in second arm. SiN PATCH POSSIBLE
        %1/2 arm
        hybm=1;nn=1;
        
        KID{nn}=shiftXY(makeCPW(Larm/2,line,gap),-Larm/4,0);
        %BRIDGES{1}=shiftXY(makebar(6,4),-1,0);%Bridges is the patch for the possible break!
        Hyb{hybm}=shiftXY(makebar(Larm/2+tria/2,line),-Larm/4+tria/4,0);%horizontal arm at (0,0)
        KID{nn+1}=shiftXY(makebar(Larm/2,line),-Larm/4,0);%horizontal arm at (0,0)
        hybm=hybm+1;nn=nn+2;
        tl=Larm/2;htl=tl;%l
        
        %1/4 turn, left side%
        Symbols{4}=[-Larm/2 0];
        newY=-R;        %new Y origin, i.e. Y coordinate where we should add next part%
        tl=tl+pi*R/2;htl=tl;%l
        
        %ed part left
        KID{nn}=shiftXY(mirr45(makeCPW(ed,line,gap)),-R-Larm/2,newY-ed/2);
        Hyb{hybm}=shiftXY(mirr45(makebar(ed,line)),-R-Larm/2,newY-ed/2);%vert part left
        KID{nn+1}=Hyb{hybm};
        hybm=hybm+1;nn=nn+2;
        newY=newY-ed;   %new Y origin, i.e. Y coordinate where we should add next part%
        tl=tl+ed;htl=tl;%l
        
        %1/4 turn,
        Symbols{5}=[-Larm/2,newY-1*R];
        newY=newY-R;
        sn1=1;sn2=1;sn6=1;sn7=1;sn10=1;sn11=1;
        tl=tl+pi*R/2;htl=tl;%l
        
        
        %first arm,
        %narrow part, tria+frac*Larm
        KID{nn}=shiftXY(makeCPW(-tria+fracn*Larm,line,gap),-tria/2-(1-fracn)*Larm/2,newY);
        KID{nn+1}=shiftXY(makebar(-tria+fracn*Larm,line),-tria/2-(1-fracn)*Larm/2,newY);%first arm, still narrow, tria shorter
        Hyb{hybm}=shiftXY(makebar(fracn*Larm,line),-(1-fracn)*Larm/2,newY);%first arm, still narrow, tria shorter
        %SiNpatch{hybm+1}=shiftXY(makebar(fracn*Larm+SiNpatchaw,line+2*gap+SiNpatchaw),-(1-fracn)*Larm/2+SiNpatchaw/2,newY);%first arm, still narrow, tria shorter
        
        hybm=hybm+1;nn=nn+2;
        triangle(1,:,:)=[0 0 tria tria ; line/2 line/2+gap WR*(line/2+gap) widelinewidth/2];
        triangle(2,:,:)=[ 0 0 tria tria ; -line/2 -(line/2+gap) -WR*(line/2+gap) -widelinewidth/2];
        triangle(3,:,:)=[0 0 tria/2 tria/2; -line/2 line/2 (widelinewidth+line)/4 -(widelinewidth+line)/4];
        KID{nn}=shiftXY(triangle,Larm/2-tria-(1-fracn)*Larm,newY);
        if BigSiN == 0
            SiNpatch{1}=shiftXY(makebar(2*SiNpatchaw+tria,2*SiNpatchaw+WR*(line+2*gap)),Larm/2-tria/2-(1-fracn)*Larm,newY);
        end
        nn=nn+1;
        if FullHybrid==1
            tria_hyb(1,:,:)=[0 0 tria tria; -line/2 line/2 widelinewidth/2 -widelinewidth/2];
            Hyb{hybm}=shiftXY(tria_hyb,Larm/2-tria-(1-fracn)*Larm,newY);
            KID{nn}=Hyb{hybm};
            nn=nn+1;hybm=hybm+1;
        end
        %wide part of first arm
        KID{nn}=shiftXY(makeCPW((1-fracn)*Larm,widelinewidth,widegapwidth),fracn*Larm/2,newY);
        nn=nn+1;
        tl=tl+Larm;htl=htl+fracn*Larm-tria/2;%l
        if FullHybrid==1
            Hyb{hybm}=shiftXY(makebar((1-fracn)*Larm,widelinewidth),fracn*Larm/2,newY);
            KID{nn}=Hyb{hybm};
            nn=nn+1;hybm=hybm+1;
            htl=tl;%l
        end
    end
    
    %starting to make meandering bulk %writes turn then line
    m=1;bn=6;
    while m <= n-1
        if FullHybrid==1 %half turn+arm
            Symbols{10}(sn10,:)=[Larm/2  newY-2*R];sn10=sn10+1;%1/2 turn
            newY=newY-2*R;
            KID{nn}=shiftXY(makeCPW(Larm,widelinewidth,widegapwidth),0,newY);%arm
            nn=nn+1;
            Hyb{hybm}=shiftXY(makebar(Larm,widelinewidth),0,newY);
            KID{nn}=Hyb{hybm};
            nn=nn+1;hybm=hybm+1;
            m=m+1;
            tl=tl+Larm+pi*R;htl=tl;%l
        else%no Hybrid %arm+half turn
            Symbols{1}(sn1,:)=[Larm/2  newY-2*R];sn1=sn1+1;%1/2 turn
            newY=newY-2*R;
            KID{nn}=shiftXY(makeCPW(Larm,widelinewidth,widegapwidth),0,newY);%arm
            nn=nn+1;m=m+1;
            tl=tl+Larm+pi*R;%l
        end
        if m>=n%we need to stop
            side=1;%180 bend is at right side of KID
            dx=Kid_dL;
            break
        else
            side=0;%last bend is at left side of KID
            dx=-Kid_dL;
            if FullHybrid==1 %half turn+arm
                Symbols{11}(sn11,:)=[-Larm/2  newY-2*R];sn11=sn11+1;%1/2 turn
                newY=newY-2*R;
                KID{nn}=shiftXY(makeCPW(Larm,widelinewidth,widegapwidth),0,newY);%arm
                nn=nn+1;
                Hyb{hybm}=shiftXY(makebar(Larm,widelinewidth),0,newY);
                KID{nn}=Hyb{hybm};
                nn=nn+1;hybm=hybm+1;
                m=m+1;
                tl=tl+Larm+pi*R;htl=tl;%l
            else%KID only %arm+half turn
                Symbols{2}(sn2,:)=[-Larm/2 newY-2*R];sn2=sn2+1;%1/2 turn, -1R shift because (0,0) is at bottom of 1/4 turn%
                newY=newY-2*R;
                KID{nn}=shiftXY(makeCPW(Larm,widelinewidth,widegapwidth),0,newY);%another arm
                nn=nn+1;m=m+1;
                tl=tl+Larm+pi*R;
            end
        end
    end
    
elseif fracn>1 %writes Line and then turn
    
    %first arm
    hybm=1;nn=1;
    KID{nn}=shiftXY(makeCPW(Larm/2,line,gap),-Larm/4,0);
    %BRIDGES{1}=shiftXY(makebar(6,4),-1,0);%Bridges is the patch for the possible break!
    Hyb{hybm}=shiftXY(makebar(Larm/2+tria/2,line),-Larm/4+tria/4,0);%horizontal arm at (0,0)
    KID{nn+1}=shiftXY(makebar(Larm/2,line),-Larm/4,0);%horizontal arm at (0,0)
    hybm=hybm+1;nn=nn+2;
    tl=Larm/2;htl=tl;%l
    
    
    %1/4 turn, left side%
    Symbols{4}=[-Larm/2 0];
    newY=-R;        %new Y origin, i.e. Y coordinate where we should add next part%
    tl=tl+pi*R/2;htl=tl;%l
    
    %ed part left
    KID{nn}=shiftXY(mirr45(makeCPW(ed,line,gap)),-R-Larm/2,newY-ed/2);
    Hyb{hybm}=shiftXY(mirr45(makebar(ed,line)),-R-Larm/2,newY-ed/2);%vert part left
    KID{nn+1}=Hyb{hybm};
    hybm=hybm+1;nn=nn+2;
    newY=newY-ed;   %new Y origin, i.e. Y coordinate where we should add next part%
    tl=tl+ed;htl=tl;%l
    
    %1/4 turn,
    Symbols{5}=[-Larm/2,newY-1*R];
    newY=newY-R;
    sn1=1;sn2=1;sn6=1;sn7=1;sn10=1;sn11=1;
    tl=tl+pi*R/2;htl=tl;%l
    
    m=1;%%m for correct number of turns
    firstwide=1;
    while m <= n-1
        if m<fracn
            %narrow arm; arm+half turn
            KID{nn}=shiftXY(makeCPW(Larm,line,gap),0,newY);
            Hyb{hybm}=shiftXY(makebar(Larm,line),0,newY);%first arm, still narrow, tria shorter
            KID{nn+1}=Hyb{hybm};
            hybm=hybm+1;nn=nn+2;
            Symbols{6}(sn6,:)=[Larm/2  newY-2*R];%1/2 turn
            sn6=sn6+1;
            newY=newY-2*R;
            m=m+1;
            tl=tl+Larm+pi*R;htl=tl;%l
        elseif firstwide==1 %m==fracn and we make the first wide baby)
            %second narrow arm, Larm-tria
            KID{nn}=shiftXY(makeCPW(Larm-tria,line,gap),-tria/2,newY);
            Hyb{hybm}=shiftXY(makebar(Larm,line),0,newY);%first arm, still narrow, tria shorter
            KID{nn+1}=shiftXY(makebar(Larm-tria,line),-tria/2,newY);
            nn=nn+2;hybm=hybm+1;
            triangle(1,:,:)=[0 0 tria tria; line/2 line/2+gap WR*(line/2+gap) widelinewidth/2];
            triangle(2,:,:)=[0 0 tria tria; -line/2 -(line/2+gap) -WR*(line/2+gap) -widelinewidth/2];
            triangle(3,:,:)=[0 0 tria/2 tria/2; -line/2 line/2 widelinewidth/2 -widelinewidth/2];
            KID{nn}=shiftXY(triangle,Larm/2-tria,newY);
            nn=nn+1;
            if BigSiN == 0
                SiNpatch{1}=shiftXY(makebar(2*SiNpatchaw+tria,2*SiNpatchaw+WR*(line+2*gap)),Larm/2-tria/2,newY);
            end
            %half turn
            if FullHybrid==1
                tria_hyb(1,:,:)=[0 0 tria tria; -line/2 line/2 widelinewidth/2 -widelinewidth/2];
                Hyb{hybm}=shiftXY(tria_hyb,Larm/2-tria,newY);
                KID{nn}=Hyb{hybm};
                nn=nn+1;hybm=hybm+1;
                Symbols{10}(sn10,:)=[Larm/2 newY-2*R];sn10=sn10+1;
                tl=tl+Larm+pi*R;htl=tl;%l
            else
                Symbols{1}(sn1,:)=[Larm/2 newY-2*R];sn1=sn1+1;
                tl=tl+Larm+pi*R;htl=htl+Larm-tria/2;%l
            end
            newY=newY-2*R;firstwide=0;
            m=m+1;
            
        elseif firstwide==0
            %arm+half turn
            KID{nn}=shiftXY(makeCPW(Larm,widelinewidth,widegapwidth),0,newY);
            nn=nn+1;
            if FullHybrid==1
                Hyb{hybm}=shiftXY(makebar(Larm,widelinewidth),0,newY);%first arm, still narrow, tria shorter
                KID{nn}=Hyb{hybm};
                hybm=hybm+1;
                nn=nn+1;
                Symbols{10}(sn10,:)=[Larm/2 newY-2*R];sn10=sn10+1;%half turn
                tl=tl+Larm+pi*R;htl=tl;%l
            else
                Symbols{1}(sn1,:)=[Larm/2 newY-2*R];sn1=sn1+1;%halfturn
                tl=tl+Larm+pi*R;%l
            end
            newY=newY-2*R;
            m=m+1;
        end
        
        if m>=n%we need to stop, add 1 180 bend first
            side=1;%180 bend is at right side of KID
            dx=-Kid_dL;
            break
            
        else%continue
            side=0;%last bend is at left side of KID WORKS oK
            dx=Kid_dL;
            if m<fracn
                %narrow arm +half turn
                KID{nn}=shiftXY(makeCPW(Larm,line,gap),0,newY);
                Hyb{hybm}=shiftXY(makebar(Larm,line),0,newY);%first arm, still narrow, tria shorter
                KID{nn+1}=Hyb{hybm};
                hybm=hybm+1;nn=nn+2;
                Symbols{7}(sn7,:)=[-Larm/2  newY-2*R];%1/2 turn
                sn7=sn7+1;
                newY=newY-2*R;
                m=m+1;
                tl=tl+Larm+pi*R;htl=tl;%l
            elseif firstwide==1
                %narrow arm, tria shorter +half turn
                KID{nn}=shiftXY(makeCPW(Larm-tria,line,gap),tria/2,newY);
                Hyb{hybm}=shiftXY(makebar(Larm,line),0,newY);%first arm, still narrow, tria shorter
                KID{nn+1}=shiftXY(makebar(Larm-tria,line),tria/2,newY);
                nn=nn+2;hybm=hybm+1;
                %triangle
                triangle(1,:,:)=[tria tria 0 0; line/2 line/2+gap WR*(line/2+gap) widelinewidth/2];
                triangle(2,:,:)=[tria tria 0 0; -line/2 -(line/2+gap) -WR*(line/2+gap) -widelinewidth/2];
                triangle(3,:,:)=[tria tria tria/2 tria/2; -line/2 line/2 widelinewidth/2 -widelinewidth/2];
                KID{nn}=shiftXY(triangle,-Larm/2,newY);
                nn=nn+1;
                if BigSiN == 0
                    SiNpatch{1}=shiftXY(makebar(2*SiNpatchaw+tria,2*SiNpatchaw+WR*(line+2*gap)),-(Larm/2-tria/2),newY);
                end
                %Half Turn
                if FullHybrid==1
                    tria_hyb(1,:,:)=[tria tria 0 0 ; -line/2 line/2 widelinewidth/2 -widelinewidth/2];
                    Hyb{hybm}=shiftXY(tria_hyb,-Larm/2,newY);
                    KID{nn}=Hyb{hybm};
                    nn=nn+1;hybm=hybm+1;
                    Symbols{11}(sn11,:)=[-Larm/2 newY-2*R];sn11=sn11+1;
                    tl=tl+Larm+pi*R;htl=tl;%l
                else
                    Symbols{2}(sn2,:)=[-Larm/2 newY-2*R];sn2=sn2+1;%1/2 turn, -1R shift because (0,0) is at bottom of 1/4 turn%
                    tl=tl+Larm+pi*R;htl=htl+Larm-tria/2;%l
                end
                
                newY=newY-2*R;firstwide=0;
                m=m+1;
                
            elseif firstwide==0
                %Wide arm + half turn
                KID{nn}=shiftXY(makeCPW(Larm,widelinewidth,widegapwidth),0,newY);
                nn=nn+1;
                if FullHybrid==1
                    Hyb{hybm}=shiftXY(makebar(Larm,widelinewidth),0,newY);%first arm, still narrow, tria shorter
                    KID{nn}=Hyb{hybm};
                    hybm=hybm+1;
                    nn=nn+1;
                    Symbols{11}(sn11,:)=[-Larm/2 newY-2*R];sn11=sn11+1;
                    tl=tl+Larm+pi*R;htl=tl;
                else
                    Symbols{2}(sn2,:)=[-Larm/2 newY-2*R];sn2=sn2+1;%1/2 turn, -1R shift because (0,0) is at bottom of 1/4 turn%
                    tl=tl+Larm+pi*R;
                end
                newY=newY-2*R;
                m=m+1;
            end
        end
    end
    KID{nn}=shiftXY(makeCPW(Larm,widelinewidth,widegapwidth),0,newY);
    tl=tl+Larm;
    nn=nn+1;
    if FullHybrid==1
        Hyb{hybm}=shiftXY(makebar(Larm,widelinewidth),0,newY);%first arm, still narrow, tria shorter
        KID{nn}=Hyb{hybm};
        hybm=hybm+1;
        nn=nn+1;
        htl=tl;%L
    end
else
    error('fracn wrong (inside KID defining function)')
end

%adding 1/2 turn, and Larm/2-R short section
if side
    %180 degree turn
    if FullHybrid==1
        Symbols{11}(sn11,:)=[-Larm/2 newY-2*R];sn11=sn11+1;%1/2 turn
        tl=tl+pi*R;htl=tl;%L
    else
        Symbols{2}(sn2,:)=[-Larm/2 newY-2*R];sn2=sn2+1;%1/2 turn
        tl=tl+pi*R;%L
    end
    newY=newY-2*R;
    %small arm
    KID{nn}=shiftXY(makeCPW(Lsmallarm,widelinewidth,widegapwidth),-R-Lsmallarm/2+dx,newY);%small arm
    nn=nn+1;
    tl=tl+Lsmallarm;%L
    %90 degree turn
    if FullHybrid==1
        Hyb{hybm}=shiftXY(makebar(Lsmallarm,widelinewidth),-R-Lsmallarm/2+dx,newY);
        KID{nn}=Hyb{hybm};
        nn=nn+1;hybm=hybm+1;
        Symbols{12}=[-R+dx,newY];
        tl=tl+pi*R/2;htl=tl;%L
    else
        Symbols{3}=[-R+dx,newY];%1/4 turn,);%1/4 turn %1/4 turn, polarity defined in symbol def
        tl=tl+pi*R/2;%L
    end
else
    %180 degree
    if FullHybrid==1
        Symbols{10}(sn10,:)=[Larm/2 newY-2*R];sn10=sn10+1;%1/2 turn
        tl=tl+pi*R;htl=tl;%L
    else
        Symbols{1}(sn1,:)=[Larm/2 newY-2*R];sn1=sn1+1;%1/2 turn
        tl=tl+pi*R;%L
    end
    newY=newY-2*R;
    %Small arm
    KID{nn}=shiftXY(makeCPW(Lsmallarm,widelinewidth,widegapwidth),R+Lsmallarm/2+dx,newY);%small arm
    tl=tl+Lsmallarm;%L
    nn=nn+1;
    %90 degree
    if FullHybrid==1
        Hyb{hybm}=shiftXY(makebar(Lsmallarm,widelinewidth),R+Lsmallarm/2+dx,newY);%small arm
        KID{nn}=Hyb{hybm};
        nn=nn+1;hybm=hybm+1;
        Symbols{12}=[R+dx newY];
        tl=tl+pi*R/2;htl=tl;%L
    else
        Symbols{3}=[R+dx newY];%1/4 turn, polarity defined in symbol def
        tl=tl+pi*R/2;%L
    end
end

% mirroring this part that was m,ade untill now
if ~Qwave %making it HW by mirorring existing part
    nn=nn-1;hybm=hybm-1;
    KID(nn+1:2*nn)=mirrKIDvert(mirrKIDhor(KID));
    Hyb(hybm+1:2*hybm)=mirrKIDvert(mirrKIDhor(Hyb));
    hybm=2*hybm+1;
    nn=2*nn+1;
    %mirror symbols
    Symbols=mirror_add_symbols(Symbols,R);
    %add a hor section at KID end with same length as coupler structure,
    tl=tl*2;%l
    %Add section as long as coupler+cd+1/4turn
    Ltoadd=0.5*pi*R+tria+vpn+cd+Lc;%coupL subtracted as the KID bar ends above the coupler
    temp=makebar(widegapwidth,widelinewidth+2*widegapwidth);%bar for KID end and coupler short
    tl=tl+Ltoadd-0.5*pi*R;%l. The half turn was already included in the value of tl that was doubled
    if side
        KID{nn}=shiftXY(makeCPW(Ltoadd,widelinewidth,widegapwidth),-Ltoadd/2+R+dx,-newY);%small arm
        nn=nn+1;
        if FullHybrid==1
            Hyb{hybm}=shiftXY(makebar(Ltoadd,widelinewidth),-Ltoadd/2+R+dx,-newY);%small arm
            KID{nn}=Hyb{hybm};
            nn=nn+1;hybm=hybm+1;
            htl=tl;%l
        end
        KID{nn}=shiftXY(temp,-Ltoadd+R-widegapwidth/2+dx,-newY);
        nn=nn+1;
    else
        KID{nn}=shiftXY(makeCPW(Ltoadd,widelinewidth,widegapwidth),Ltoadd/2-R+dx,-newY);%small arm
        nn=nn+1;
        if FullHybrid==1
            Hyb{hybm}=shiftXY(makebar(Ltoadd,widelinewidth),Ltoadd/2-R+dx,-newY);%small arm
            KID{nn}=Hyb{hybm};
            nn=nn+1;hybm=hybm+1;
            htl=tl;
        end
        KID{nn}=shiftXY(temp,Ltoadd-R+widegapwidth/2+dx,-newY);
        nn=nn+1;
    end
    
end

newY=newY-R;
%Vertical part to coupler
KID{nn}=shiftXY(mirr45(makeCPW(vpn,widelinewidth,widegapwidth)),+dx,newY-vpn/2);%short narrow section for bridge
nn=nn+1;
tl=tl+vpn;%l
if FullHybrid==1
    Hyb{hybm}=shiftXY(mirr45(makebar(vpn,widelinewidth)),+dx,newY-vpn/2);%short narrow section for bridge
    KID{nn}=Hyb{hybm};
    nn=nn+1;hybm=hybm+1;
    htl=tl;
end
newY=newY-vpn;

%insert triangle to Coupler, no shift needed triangle at once at correct position  %
clear triangle;
triangle(1,:,:)=[widelinewidth/2 WR*(line/2+gap) coupL/2+coupG coupL/2 ; newY newY newY-tria newY-tria];
triangle(2,:,:)=[-widelinewidth/2 -WR*(line/2+gap) -(coupL/2+coupG) -coupL/2 ; newY newY newY-tria newY-tria];
KID{nn}=shiftXY(triangle,+dx,0);
nn=nn+1;
tl=tl+tria;%l

if FullHybrid==1
    trian_Hyb(1,:,:)=[widelinewidth/2 -widelinewidth/2 -coupL/2 coupL/2 ; newY newY newY-tria newY-tria];
    Hyb{hybm}=shiftXY(trian_Hyb,dx,0);%short narrow section for bridge
    KID{nn}=Hyb{hybm};
    nn=nn+1;hybm=hybm+1;
    htl=tl;%l
end

newY=newY-tria;

%vert part to coupler
cd_kidgaps=cd-coupL-coupG;%wide vert part will be shorter than parameter cd because of coupler line and coupler gap itself
KID{nn}=shiftXY(mirr45(makeCPW(cd_kidgaps,coupL,coupG)),+dx,newY-cd_kidgaps/2);%vert part to coupler
nn=nn+1;
tl=tl+cd;%l coupG is added to the length for the central strip
if FullHybrid==1
    Hyb{hybm}=shiftXY(mirr45(makebar(cd-coupL,coupL)),+dx,newY-(cd-coupL)/2);%vert part to coupler
    KID{nn}=Hyb{hybm};
    nn=nn+1;hybm=hybm+1;
    htl=tl;
end
%coupler structure
newY=newY-cd+coupL/2;%line/2 higher because coupler line center is line/2 higher than bottom last vertical bar%
KID{nn}=shiftXY(makeCPW(Lc-coupL,coupL,coupG),(Lc-coupL)/2+coupL/2+dx,newY);%coupler
nn=nn+1;
tl=tl+Lc;%l
if FullHybrid==1
    Hyb{hybm}=shiftXY(makebar(Lc,coupL),Lc/2-coupL/2+dx,newY);%coupler
    KID{nn}=Hyb{hybm};
    nn=nn+1;hybm=hybm+1;
    htl=tl;
end

%some remaining rectangles to close the coupler. They do not add to the KID
%length
temp=makebar(coupG,coupL+2*coupG);%bar for KID end and coupler short
KID{nn}=shiftXY(temp,-coupL/2-coupG/2+dx,newY);
nn=nn+1;
KID{nn}=shiftXY(temp,Lc-coupL/2+coupG/2+dx,newY);
nn=nn+1;
KID{nn}=shiftXY(makebar(coupL,coupG),+dx,newY-coupL/2-coupG/2);

% add antenna
[THyb,TKID] = makeantennas(antenna, tria);
if antenna ~= 0
    for nmn=1: length(TKID)
        KID{nn+nmn} = TKID{nmn};
    end
    Hyb{hybm} = THyb{1};
    hybm=hybm+1;
end
mm=nn+length(TKID)+1;


%%%%%%%%%%% SiN patch, works not for all designs %%%%%%%%%%%%%%
if antenna ~=0
    SiNap=2*max(max(max(KID{tmm})))+SiNpatchaw*2;%antenna height
else
    SiNap=100;
end
PH=ed+2*R;
SiNpatch{2}=shiftXY(makebar(SiNap,PH),0,0);%on the antenna, aleways there

if BigSiN == 1 %rest only if we patch the entire Alu line
    SiNpatch{3}=shiftXY(makebar(KIDdistance/2,PH),-KIDdistance/4,0);%big patch (Nb antenna blodf later so that is why N+1)
    if fracn <1 && fracn >0
        PW=KIDdistance/2-(0.5-fracn)*Larm+tria+SiNpatchaw ;
        PH=ed/2+R+R;%WR*(line+2*gap)+SiNpatchaw*2;
        SiNpatch{4}=shiftXY(makebar(PW,PH),-KIDdistance/2+PW/2,-PH/2-ed/2-R);
    elseif fracn >1
        PH=ed/2+2*fracn*R;%WR*(line+2*gap)+SiNpatchaw*2;
        SiNpatch{4}=shiftXY(makebar(KIDdistance,PH),0,-PH/2-ed/2-R);
    end
    
end
%now Tline


mm=mm+1;
newY=newY-coupG-coupL/2-td-tlgap-tlwidth/2;%Y=0
KID{mm}=shiftXY(makebar(KIDdistance,tlgap),0,newY+tlgap/2+tlwidth/2);
SiNpatch{5}=shiftXY(makebar(KIDdistance,tlwidth+SiNpatchaw),0,newY);
%bottom half added
mm=mm+1;

KID{mm}=shiftXY(makebar(KIDdistance,tlgap),0,newY-tlgap/2-tlwidth/2);
%WORST{mm}=shiftXY(makebar(KIDdistance,tlworstwidth/2),0,newY-tlworstwidth/4);
mm=mm+1;



%Tline bridges: write bridges and ASiO2 layer for the bridges. ONLY FOR onesided KIDs now%
pct=1;
Polyamid{1}=[];TLBRIDGES{1}=[];%otherwise prgram crashes
if TLbridges>0
    Xposleft=-tlbwidth/2-bridgefromcoupler+dx;%gives 2*coupG+coupL + 2tlblength extra leeway
    Xposright=maxLc+tlbwidth/2+bridgefromcoupler+dx;
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
