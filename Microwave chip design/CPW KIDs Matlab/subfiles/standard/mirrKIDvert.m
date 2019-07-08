
function mKID=mirrKIDvert(KID)
for j=1:length(KID)
    for i=1:size(KID{j},1)
        mKID{j}(i,1,:)=-KID{j}(i,1,:);
        mKID{j}(i,2,:)=KID{j}(i,2,:);
    end
end
end