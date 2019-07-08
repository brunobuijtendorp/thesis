
function [temp,tf,Hybtf]=twinslot_AMKIDSi850(tria)
%2016 AMKID design on Si-SiN by Ozan
temp(1,:,:)=[0 0 2.0 2.0 31.235 31.235 25.235 25.235;12.2 3.1 3.1 6.2 6.2 49.412 49.412 12.2];
temp(2,1,:)=-1*temp(1,1,:);temp(2,2,:)=temp(1,2,:);
temp(3,1,:)=-1*temp(1,1,:);temp(3,2,:)=-1*temp(1,2,:);
temp(4,1,:)=temp(1,1,:);temp(4,2,:)=-1*temp(1,2,:);
tf(1,:,:)=[-42 -42 14.65 14.65;-3.1 3.1 3.1 -3.1];%transformer, height 0.1 less than design of 4.2
Hybtf(1,:,:)=[-42 -42 14.65+tria 14.65+tria;-1.15 1.15 1.15 -1.15];
end