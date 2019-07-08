
function shifted=shiftXY(ori,shiftx,shifty)
for i=1:size(ori,1)
    shifted(i,1,:)=ori(i,1,:)+shiftx;
    shifted(i,2,:)=ori(i,2,:)+shifty;
end
end
