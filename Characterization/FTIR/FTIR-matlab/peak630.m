function [parafit630,errorfit630,goodness630,output630,waventofit,intensitiestofit]= peak630(n0,nc,wavenumbers,intensities,filesize,c1start,c2start,nfitbg,dfitbg)

%select region----------------------------------------
[waventofit,intensitiestofit]=selectregions(wavenumbers,intensities,filesize);

%plot selected regions--------------------------------
figure
plot(waventofit,intensitiestofit,'b');
hold on

%delete parts-----------------------------------------
delete=input('Do you want to delete parts? y/n','s');
if delete == 'y'
    newfilesize=size(waventofit);
    [waventofitend,intensitiestofitend]=deleteregions(waventofit,intensitiestofit,newfilesize);
    waventofit=waventofitend;
    intensitiestofit=intensitiestofitend;
end

if delete == 'n'
end

%finding starting parameters-------------------------------
figure
title('peak630')
scatter(waventofit,intensitiestofit)
hold on

%userinput parameters----------------------------
more='y';
round=0;
while more=='y'
         
    %title of cells
    celltitle={'c1','c2','s1','f1','i1'};
    
    %name of the dialog box
    namedlg='Input parameters';
    
    %number of lines visible for your input
    numlines=1;
    
    %the default parameters
    if round==0
        defpara={c1start,c2start,'30','630','20'};
    end
    if round>0
        defpara={para{1},para{2},para{3},para{4},para{5}};
    end
    
    %creates the dialog box. the user input is stored into a cell array
    para=inputdlg(celltitle,namedlg,numlines,defpara);
    
    %read out parameters
    c1_630=str2double(para{1});
    c2_630=str2double(para{2});
    s1_630=str2double(para{3});
    f1_630=str2double(para{4});
    i1_630=str2double(para{5});
    
    intensitiesmanfit=peak630fitfunction(waventofit,n0,nc,nfitbg,dfitbg,c1_630,c2_630,s1_630,f1_630,i1_630);
    colour=['y';'g';'c';'m';'k';'r';'b'];
    colourround=round+1;
    plot(waventofit,intensitiesmanfit,colour(colourround))
    
    more=input('Change parameters? y/n','s');
    
    if round==6
        round=0;
        hold off
        title('peak630')
        scatter(waventofit,intensitiestofit)
        hold on
    end
        
    round=round+1;
end

%fit of 630 peak using initial parameters-----------------------------
%initial parameters 
ini630 = [c1_630 c2_630 s1_630 f1_630 i1_630];

%setting lower and upper limit
lbc1=c1_630-0.1;
lbc2=c2_630-0.3;
lbs1=s1_630-20;
lbf1=f1_630-5;
lbi1=i1_630-20;

ubc1=c1_630+0.1;
ubc2=c2_630+0.3;
ubs1=s1_630+20;
ubf1=f1_630+5;
ubi1=i1_630+20;
%lower limit
lb = [lbc1 lbc2 lbs1 lbf1 lbi1];
%upper bond
ub = [ubc1 ubc2 ubs1 ubf1 ubi1];

[model630,goodness630,output630]=peak630fit(waventofit,intensitiestofit,n0,nc,nfitbg,dfitbg,ini630,lb,ub);

%fitted parameter
parafit630=coeffvalues(model630);
errorfit630=confint(model630);