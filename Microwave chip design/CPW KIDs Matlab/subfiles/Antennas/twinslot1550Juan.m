
function [temp]=twinslot1550Juan(AluconW,NbTiNph,Lalu,tria)

temp(1,:,:)=...
 [	1   Lalu/2-tria/4   Lalu/2-tria/4   Lalu/2+tria     Lalu/2+tria     0           0       11.105  11.105  14.215  14.215  1 ;...
    1.4 1.4             AluconW         AluconW         NbTiNph/2       NbTiNph/2   6.52    6.52    27.175  27.175  3.41    3.41];
% 1.4 value has 0.1 um too small to allow overetch
temp(2,1,:)=-1*temp(1,1,:);temp(2,2,:)=temp(1,2,:);
temp(3,1,:)=-1*temp(1,1,:);temp(3,2,:)=-1*temp(1,2,:);
temp(4,1,:)=temp(1,1,:);temp(4,2,:)=-1*temp(1,2,:);

temp=shiftXY(temp,0,0);
end