function [xoutput,youtput]=selectregions(xinput,yinput,xlength)
%input is the whole data range as rowvectors; output is/are the selected region(s) as columnvectors

%plot whole range---------------------------
figure
plot(xinput,yinput,'b')
title('Select the regions to fit')
hold on

%select region------------------------------
more='y';
j=1;
xoutput=[];
youtput=[];
			
pause %stops the m-file and continues after pressing any key
while more == 'y'
    [nx,ny]=ginput(2);%graphical input from cursor;(2)-->2 points
    for i=1:xlength(1)%(1)-->the number of rows
        if (nx(1) <= xinput(i))&(xinput(i)<=nx(2));
            xoutput(j) = xinput(i);
            youtput(j) = yinput(i);
            j=j+1;
        end
    end
    plot(xoutput,youtput,'r');
    hold on
    more = input('Do you want to select more regions? y/n','s');
end