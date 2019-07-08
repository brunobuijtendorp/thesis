
function hturn=barturn180(R,line,mesh)
%Create 1/2 circle curve (right side), R is line Radius. origon is bottom middle of line
for i=0:mesh%create bends. centered around 0 and shifted up and right turn1 is outer polygone
    hturn(1,1,i+1)=(R-line/2)*sin(i*pi/mesh);%x values inner
    hturn(1,1,i+mesh+2)=(R+line/2)*sin(pi-i*pi/mesh);%x values outer
    hturn(1,2,i+1)=(R-line/2)*cos(i*pi/mesh)+R;%yvalues inner
    hturn(1,2,i+mesh+2)=(R+line/2)*cos(pi-i*pi/mesh)+R;%yvalues outer
end
end