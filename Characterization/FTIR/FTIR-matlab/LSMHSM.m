function [parafitLSMHSM,errorfitLSMHSM,goodnessLSMHSM,outputLSMHSM,waventofit,intensitiestofit]= LSMHSM(n0,nc,wavenumbers,intensities,filesize,c1start,c2start,nfitbg,dfitbg)

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
title('LSM & HSM')
scatter(waventofit,intensitiestofit)
hold on

%userinput parameters----------------------------
more='y';
round=0;
while more=='y'
         
    %title of cells
    celltitle={'c1','c2','s1','f1','i1','s2','f2','i2'};
    
    %name of the dialog box
    namedlg='Input parameters';
    
    %number of lines visible for your input
    numlines=1;
    
    %the default parameters
    if round==0
        defpara={c1start,c2start,'30','1995','2.5','30','2085','1'};
    end
    if round>0
        defpara={para{1},para{2},para{3},para{4},para{5},para{6},para{7},para{8}};
    end
    
    %creates the dialog box. the user input is stored into a cell array
    para=inputdlg(celltitle,namedlg,numlines,defpara);
    
    %read out parameters
    c1_LSMHSM=str2double(para{1});
    c2_LSMHSM=str2double(para{2});
    s1_LSMHSM=str2double(para{3});
    f1_LSMHSM=str2double(para{4});
    i1_LSMHSM=str2double(para{5});
    s2_LSMHSM=str2double(para{6});
    f2_LSMHSM=str2double(para{7});
    i2_LSMHSM=str2double(para{8});
    
    intensitiesmanfit=LSMHSMfitfunction(waventofit,n0,nc,nfitbg,dfitbg,c1_LSMHSM,c2_LSMHSM,s1_LSMHSM,f1_LSMHSM,i1_LSMHSM,s2_LSMHSM,f2_LSMHSM,i2_LSMHSM);
    colour=['y';'g';'c';'m';'k';'r';'b'];
    colourround=round+1;
    plot(waventofit,intensitiesmanfit,colour(colourround))
    
    more=input('Do you want to change parameters? y/n','s');
    
    if round==6
        round=0;
        hold off
        title('LSM & HSM')
        scatter(waventofit,intensitiestofit)
        hold on
    end
        
    round=round+1;
end

%fit of LSM & HSM peak using initial parameters-----------------------------
%initial parameters 
iniLSMHSM = [c1_LSMHSM c2_LSMHSM s1_LSMHSM f1_LSMHSM i1_LSMHSM s2_LSMHSM f2_LSMHSM i2_LSMHSM];

%setting lower and upper limit
lbc1=c1_LSMHSM-0.1;
lbc2=c2_LSMHSM-0.3;
lbs1=s1_LSMHSM-20;
lbf1=f1_LSMHSM-5;
lbi1=i1_LSMHSM-20;
lbs2=s2_LSMHSM-20;
lbf2=f2_LSMHSM-5;
lbi2=i2_LSMHSM-20;

ubc1=c1_LSMHSM+0.1;
ubc2=c2_LSMHSM+0.3;
ubs1=s1_LSMHSM+20;
ubf1=f1_LSMHSM+5;
ubi1=i1_LSMHSM+20;
ubs2=s2_LSMHSM+20;
ubf2=f2_LSMHSM+5;
ubi2=i2_LSMHSM+20;
%lower limit
lbLSMHSM = [lbc1 lbc2 lbs1 lbf1 lbi1 lbs2 lbf2 lbi2];
%upper bond
ubLSMHSM = [ubc1 ubc2 ubs1 ubf1 ubi1 ubs2 ubf2 ubi2];


[modelLSMHSM,goodnessLSMHSM,outputLSMHSM]=LSMHSMfit(waventofit,intensitiestofit,n0,nc,nfitbg,dfitbg,iniLSMHSM,lbLSMHSM,ubLSMHSM);

%fitted parameters
parafitLSMHSM=coeffvalues(modelLSMHSM);
errorfitLSMHSM=confint(modelLSMHSM);