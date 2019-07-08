
function shiftedKID=shiftKID(KID,shiftx,shifty)
if ~isempty(KID)
    for j=1:length(KID)
        for i=1:size(KID{j},1)
            shiftedKID{j}(i,1,:)=KID{j}(i,1,:)+shiftx;
            shiftedKID{j}(i,2,:)=KID{j}(i,2,:)+shifty;
        end
    end
else
    shiftedKID=[];
end
end