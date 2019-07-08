
function turn=CPWturn90(R,line,gap,mesh)
%Create 1/4 circle curve, R is central line Radius. origon is bottom middle of central line, 1 is outer, 2 is inner
%The curce contacts to a horizontal line at its origin and then makes 90
%degree left turn upwards like this:
%     x
%   x
%x
mesh=mesh/2;%to make same exactly as 1/2 turn
for i=0:mesh%create bends. centered around 0 and shifted up and right turn1 is outer polygone
    turn(1,1,i+1)=(R+line/2)*sin(pi/2+i*pi/mesh/2);%x values inner
    turn(1,1,i+mesh+2)=(R+line/2+gap)*sin(pi-i*pi/mesh/2);%x values outer
    turn(1,2,i+1)=(R+line/2)*cos(pi/2+i*pi/mesh/2)+R;%yvalues inner
    turn(1,2,i+mesh+2)=(R+line/2+gap)*cos(pi-i*pi/mesh/2)+R;%yvalues outer
    
    turn(2,1,i+1)=(R-line/2)*sin(pi/2+i*pi/mesh/2);%x values inner
    turn(2,1,i+mesh+2)=(R-line/2-gap)*sin(pi-i*pi/mesh/2);%x values outer
    turn(2,2,i+1)=(R-line/2)*cos(pi/2+i*pi/mesh/2)+R;%yvalues)
    turn(2,2,i+mesh+2)=(R-line/2-gap)*cos(pi-i*pi/mesh/2)+R;%yvalues)
end
end