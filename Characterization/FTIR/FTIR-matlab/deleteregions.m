function [xoutput,youtput]=deleteregions(xinput,yinput,xlength)
%input is the whole data range as columnvectors;output are the not deleted parts as columnvectors

%plot whole range---------------------------
figure
plot(xinput,yinput,'b')
title('Select the regions to delete')
hold on

%delete region------------------------------
more='y';
j=1;
indextodelete=[];
logicaltodelete=ones(1,xlength(2));%creates vector of size of 'xinput'; all elements = '0'

while more == 'y'
    [nx,ny]=ginput(2);
    for i=1:xlength(2)
        if (nx(1)<=xinput(i))&(xinput(i)<=nx(2))
            indextodelete(j)=i;%fills vector with indices of 'xinput' that are to be deleted
            j=j+1;
        end
    end
        
    indexsize=size(indextodelete);
    for k=1:indexsize(2)
        for i=1:xlength(2)
            if indextodelete(k)==i
                logicaltodelete(i)=0;
            end
        end
    end
                
    xoutput=xinput(logical(logicaltodelete));
    youtput=yinput(logical(logicaltodelete));
    plot(xinput,yinput,'b');
    hold on
    plot(xoutput,youtput,'r');
    hold on
    more = input('Do you want to delete more regions? y/n','s');
end