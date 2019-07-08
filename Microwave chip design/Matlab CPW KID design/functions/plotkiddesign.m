
function plotkiddesign(KID,color)
for i=1:length(KID)
    for j=1:size(KID{i},1)
        plot(reshape(KID{i}(j,1,:),1,[]),reshape(KID{i}(j,2,:),1,[]),color);hold on;
        hold on;
    end
end
end
