
function turn=barturn90(R,line,mesh)
%Create 1/4 circle curve, R is  line Radius. origon is bottom middle of
%central line,
%The curce contacts to a horizontal line at its origin and then makes 90 degree left turn upwards %
mesh=mesh/2;%to make same exactly as 1/2 turn
for i=0:mesh%create bends. centered around 0 and shifted up and right turn1 is outer polygone
    turn(1,1,i+1)=(R-line/2)*sin(pi/2+i*pi/mesh/2);%x values inner
    turn(1,1,i+mesh+2)=(R+line/2)*sin(pi-i*pi/mesh/2);%x values outer
    turn(1,2,i+1)=(R-line/2)*cos(pi/2+i*pi/mesh/2)+R;%yvalues inner
    turn(1,2,i+mesh+2)=(R+line/2)*cos(pi-i*pi/mesh/2)+R;%yvalues outer
    
end
end