
function mirrorred=mirrorvert(ori)%mirrors around vertical axis
for i=1:size(ori,1)
    mirrorred(i,1,:)=-ori(i,1,:);
    mirrorred(i,2,:)=ori(i,2,:);
end
end