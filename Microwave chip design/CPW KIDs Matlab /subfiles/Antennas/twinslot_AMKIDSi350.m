
function [temp,tf,Hybtf]=twinslot_AMKIDSi350(tria)
%twin slot at (0,0) for A-MKID Lband and narrow CPW. 
temp(1,:,:)=[0 0 2.9 2.9 74.571 74.571 62.571 62.571;24.5 3.1 3.1 12.5 12.5 120 120 24.5];
temp(2,1,:)=-1*temp(1,1,:);temp(2,2,:)=temp(1,2,:);
temp(3,1,:)=-1*temp(1,1,:);temp(3,2,:)=-1*temp(1,2,:);
temp(4,1,:)=temp(1,1,:);temp(4,2,:)=-1*temp(1,2,:);
tf(1,:,:)=[-37 -37 28.75 28.75;-3.1 3.1 3.1 -3.1];%transformer, height 0.1 less than design of 4.2
Hybtf(1,:,:)=[-37 -37 28.75+tria 28.75+tria;-1.15 1.15 1.15 -1.15];

end