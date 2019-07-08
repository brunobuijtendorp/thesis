
function bar=makeCPW(L,line,gap)
%create cpw; origin (0,0) is middle and center of the KID, bar 1 is bottom one%
bar(1,:,:)=[-L/2 L/2 L/2 -L/2; -line/2-gap -line/2-gap -line/2 -line/2];
bar(2,:,:)=shiftXY(bar,0,line+gap);
end