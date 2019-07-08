function [KID,Worst] = bondpad(tlineww,lw,gw,dx,dy,rightside)
%makesw bondpad @ chip left side, length = 750 um, origin at dx,dy
% for rightside set 'rightside'=1
global SiNpatchaw
temp(1,:,:)=[   0       0       -200    -380    -750    -750    -710    -710    -380    -200 ;...
                lw/2    lw/2+gw 210     420     420     0       0       200     200     100];
if rightside == 1
    temp(1,1,:)=-temp(1,1,:);
elseif rightside ~=0
    error('bondpad wrong');
end
temp(2,1,:)=temp(1,1,:);temp(2,2,:)=-1*temp(1,2,:);    
KID = shiftXY(temp,dx,dy);
% 
ew = 2*SiNpatchaw;

wtemp(1,:,:)=[   0       0          -200    -380    -750    -750     ;...
                0    	tlineww/2   100+ew   200+ew  200+ew   0       ];
if rightside == 1
    wtemp(1,1,:)=-wtemp(1,1,:);
end
wtemp(2,1,:)=wtemp(1,1,:);wtemp(2,2,:)=-1*wtemp(1,2,:);  
Worst = shiftXY(wtemp,dx,dy);
end