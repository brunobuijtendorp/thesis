
function shifted=shiftSymbolXY(Symbol,shiftx,shifty)
for mm=1:length(Symbol)
    for n=1:size(Symbol{mm},1)
        shifted{mm}(n,1)=Symbol{mm}(n,1)+shiftx;
        shifted{mm}(n,2)=Symbol{mm}(n,2)+shifty;
    end
end
end