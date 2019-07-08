
function hturn=CPWturn180(R,line,gap,mesh)
%Create 1/2 circle curve (right side), R is central line Radius. origon is bottom middle of central line, 1 is outer, 2 is inner
for i=0:mesh%create bends. centered around 0 and shifted up and right turn1 is outer polygone
    hturn(1,1,i+1)=(R+line/2)*sin(i*pi/mesh);%x values inner
    hturn(1,1,i+mesh+2)=(R+line/2+gap)*sin(pi-i*pi/mesh);%x values outer
    hturn(1,2,i+1)=(R+line/2)*cos(i*pi/mesh)+R;%yvalues inner
    hturn(1,2,i+mesh+2)=(R+line/2+gap)*cos(pi-i*pi/mesh)+R;%yvalues outer
    
    hturn(2,1,i+1)=(R-line/2)*sin(i*pi/mesh);%x values inner
    hturn(2,1,i+mesh+2)=(R-line/2-gap)*sin(pi-i*pi/mesh);%x values outer
    hturn(2,2,i+1)=(R-line/2)*cos(i*pi/mesh)+R;%yvalues)
    hturn(2,2,i+mesh+2)=(R-line/2-gap)*cos(pi-i*pi/mesh)+R;%yvalues)
end
end
