function [Hyb,KID] = makeantennas(antenna, tria, AluconW, NbTiNph,L_aluline)
%antenna and so on
% antenna are case indes of the antenna as defined in the main script
% 
% Hyb, KID are thge usual struct arrays (can have more than 1 cell)
% for the 'normal' antenna's 2 nargin is ok;
global SuperKIDok


switch antenna
    case 1%1.5 THz Juan 2018; deposits also the Alu ground plane
        Hyb = twinslot1550Juan(AluconW,NbTiNph+2*tria,L_aluline,tria);
        KID=[];
        if SuperKIDok ~= 1
            error('wrong antenna for superkid');
        end
        
    case 2 %350 AMKID A Si_SiN 2016
        [KID{1},KID{2},Hyb]=twinslot_AMKIDSi350(tria);KID{mm}=(KID{mm});KID{mm+1}=(KID{mm+1});
        if SuperKIDok ~= 0
            error('wrong antenna for normal kid');
        end
        
    case 3 %850 AMKID Hband Si_SiN 2016
        [KID{1},KID{2},Hyb]=twinslot_AMKIDSi850(tria);KID{mm}=(KID{mm});KID{mm+1}=(KID{mm+1});
        if SuperKIDok ~= 0
            error('wrong antenna for normal kid');
        end
        
    case 0
        KID=[];
        Hyb=[];
end