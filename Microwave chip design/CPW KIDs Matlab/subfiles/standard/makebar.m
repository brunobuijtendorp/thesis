
function bar=makebar(L,H)
%create horizontal bar; origin (0,0) is middle and center of the line, L length, H is height%
bar(1,:,:)=[-L/2 L/2 L/2 -L/2; -H/2 -H/2 H/2 H/2];
end
