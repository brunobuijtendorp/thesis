
function rotated=mirr45(ori)
%mirror to 45 degree line through (0,0), i.e. same as 90 degree rotation
for i=1:size(ori,1)
    rotated(i,1,:)=ori(i,2,:);
    rotated(i,2,:)=ori(i,1,:);
end
end