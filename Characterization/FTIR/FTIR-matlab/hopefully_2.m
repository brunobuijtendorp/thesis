fclose('all');clear('all');close('all')


global dirtosave

n0=1;
nc=3.42;

%browse data files
% index=0;
% while index~=4
%     [substratefilename,substratepath,index1]=uigetfile('*.csv','Select substrate file');
%     [sourcerefsubfilename,sourcerefsubpath,index2]=uigetfile('*.csv','Select source reference for substrate',substratepath);
%     [samplefilename,samplepath,index3]=uigetfile('*.csv','Select sample file',substratepath);
%     [sourcerefsamplefilename,sourcerefsamplepath,index4]=uigetfile('*.csv','Select source reference for sample',substratepath);
%     index=index1+index2+index3+index4;
% end

%choose directory to save all fits
dirtosave=uigetdir('','Select a directory to save, e.g. c1800');

%file locations
% substrateloc=strcat(substratepath,substratefilename);
% sourcerefsubloc=strcat(sourcerefsubpath,sourcerefsubfilename);
% sampleloc=strcat(samplepath,samplefilename);
% sourcerefsampleloc=strcat(sourcerefsamplepath,sourcerefsamplefilename);

%import files
% substrate=csvread(substrateloc);
% sourcerefsub=csvread(sourcerefsubloc);
sample=dlmread('20190702P_1.CSV',';');
subs = dlmread('20190702P_substrate.CSV',';');
% sourcerefsample=csvread(sourcerefsampleloc);

%check if data range is matching by only comparing first x-values and
%number of data points
% if substrate(1,1)==sourcerefsub(1,1) & sourcerefsub(1,1)==sample(1,1) & sample(1,1)==sourcerefsample(1,1) & size(substrate)==size(sourcerefsub) & size(sourcerefsub)==size(sample) & size(sample)==size(sourcerefsample)
%     
% else
%     error(':( Data range is not matching. Please make sure that the files contain the same x-values :(')
% end

%calculate characteristic of sample
wavenumbers=sample(:,1);
intensities=sample(:,2) / subs(:,2);

%info filesize
filesize=size(wavenumbers);

%plot sample characteristics
plot(wavenumbers,intensities,'b')
title('sample characteristic')
ylabel('intensity')
xlabel('wavenumber [cm^{-1}]')
%print('-dpng', [dirtosave '\samplewholerange.png'])
hold on

%begin of program structure------------------------------------------------
endprogram='n';
while endprogram=='n'
    %menu
    pgmstructure=menu('FTIR analysis','Fit background','Fit 630 peak','Fit LSM & HSM','End fitting, save and display results','Quit');
    
    switch pgmstructure

%---background--------------------------------------------------

    case(1)
        
        [parafitbg,errorfitbg,goodnessbg,outputbg,waventofit,intensitiestofit]=background(n0,nc,wavenumbers,intensities,filesize);
        
        %fitted parameters-------------------------------
        nfitbg=parafitbg(1,1);
        dfitbg=parafitbg(1,2);
        c1fitbg=parafitbg(1,3);
        c2fitbg=parafitbg(1,4);
        c1start=num2str(c1fitbg);%transform to a string for later peak fitting
        c2start=num2str(c2fitbg);%transform to a string for later peak fitting
          
	%calculation of their errormargins--------------------------
	J=outputbg.Jacobian;
	S=inv(J'*J);
	redchisquarebg=goodnessbg.sse/goodnessbg.dfe;
	nerrorfitbg=sqrt(S(1,1)*redchisquarebg);
	derrorfitbg=sqrt(S(2,2)*redchisquarebg);
	c1errorfitbg=sqrt(S(3,3)*redchisquarebg);
	c2errorfitbg=sqrt(S(4,4)*redchisquarebg);
	       
        %goodness of fit statistics----------------------
	%reduced chi^2
	redchisquarebg=goodnessbg.sse/goodnessbg.dfe;
	%deg of freedom adjusted coefficient of determination
	adjrsquarebg=goodnessbg.adjrsquare;

	%save fitted data--------------------------------
	waventofitbg=waventofit;
	intensitiestofitbg=intensitiestofit;
	fittedintensitiesbg=backgroundfitfunction(waventofitbg,nfitbg,dfitbg,c1fitbg,c2fitbg,n0,nc);
	filebgfit=[waventofitbg.',intensitiestofitbg.',fittedintensitiesbg.'];
	csvwrite([dirtosave '\bgfit.dat'],filebgfit);
        

%---630peak-----------------------------------------------------

    case(2)

	[parafit630,errorfit630,goodness630,output630,waventofit,intensitiestofit]=peak630(n0,nc,wavenumbers,intensities,filesize,c1start,c2start,nfitbg,dfitbg);

	%fitted parameters-------------------------------
	c1fit630=parafit630(1,1);
	c2fit630=parafit630(1,2);
	s1fit630=parafit630(1,3);
	f1fit630=parafit630(1,4);
	i1fit630=parafit630(1,5);

	%calculation of their errormargins--------------------------
	J=output630.Jacobian;
	S=inv(J'*J);
	redchisquare630=goodness630.sse/goodness630.dfe;
	c1errorfit630=sqrt(S(1,1)*redchisquare630);
	c2errorfit630=sqrt(S(2,2)*redchisquare630);
	s1errorfit630=sqrt(S(3,3)*redchisquare630);
	f1errorfit630=sqrt(S(4,4)*redchisquare630);
	i1errorfit630=sqrt(S(5,5)*redchisquare630);
	       
        %goodness of fit statistics----------------------
	%reduced chi^2
	redchisquare630=goodness630.sse/goodness630.dfe;
	%deg of freedom adjusted coefficient of determination
	adjrsquare630=goodness630.adjrsquare;

	%save fitted data----------------------------------
	waventofit630=waventofit;
	intensitiestofit630=intensitiestofit;
	fittedintensities630=peak630fitfunction(waventofit630,n0,nc,nfitbg,dfitbg,c1fit630,c2fit630,s1fit630,f1fit630,i1fit630);
	file630fit=[waventofit630.',intensitiestofit630.',fittedintensities630.'];
	csvwrite([dirtosave '\630fit.dat'],file630fit);


%---fit LSM & HSM-----------------------------------------------

    case(3)

	[parafitLSMHSM,errorfitLSMHSM,goodnessLSMHSM,outputLSMHSM,waventofit,intensitiestofit]= LSMHSM(n0,nc,wavenumbers,intensities,filesize,c1start,c2start,nfitbg,dfitbg);

	%fitted parameters---------------------------------
	c1fitLSMHSM=parafitLSMHSM(1,1);
	c2fitLSMHSM=parafitLSMHSM(1,2);
	s1fitLSMHSM=parafitLSMHSM(1,3);
	f1fitLSMHSM=parafitLSMHSM(1,4);
	i1fitLSMHSM=parafitLSMHSM(1,5);
	s2fitLSMHSM=parafitLSMHSM(1,6);
	f2fitLSMHSM=parafitLSMHSM(1,7);
	i2fitLSMHSM=parafitLSMHSM(1,8);

	%calculation of their errormargins--------------------------
	J=outputLSMHSM.Jacobian;
	S=inv(J'*J);
	redchisquareLSMHSM=goodnessLSMHSM.sse/goodnessLSMHSM.dfe;
	c1errorfitLSMHSM=sqrt(S(1,1)*redchisquareLSMHSM);
	c2errorfitLSMHSM=sqrt(S(2,2)*redchisquareLSMHSM);
	s1errorfitLSMHSM=sqrt(S(3,3)*redchisquareLSMHSM);
	f1errorfitLSMHSM=sqrt(S(4,4)*redchisquareLSMHSM);
	i1errorfitLSMHSM=sqrt(S(5,5)*redchisquareLSMHSM);
	s2errorfitLSMHSM=sqrt(S(6,6)*redchisquareLSMHSM);
	f2errorfitLSMHSM=sqrt(S(7,7)*redchisquareLSMHSM);
	i2errorfitLSMHSM=sqrt(S(8,8)*redchisquareLSMHSM);
	       
        %goodness of fit statistics----------------------
	%reduced chi^2
	redchisquareLSMHSM=goodnessLSMHSM.sse/goodnessLSMHSM.dfe;
	%deg of freedom adjusted coefficient of determination
	adjrsquareLSMHSM=goodnessLSMHSM.adjrsquare;

	%save fitted data----------------------------------
	waventofitLSMHSM=waventofit;
	intensitiestofitLSMHSM=intensitiestofit;
	fittedintensitiesLSMHSM=LSMHSMfitfunction(waventofitLSMHSM,n0,nc,nfitbg,dfitbg,c1fitLSMHSM,c2fitLSMHSM,s1fitLSMHSM,...
        f1fitLSMHSM,i1fitLSMHSM,s2fitLSMHSM,f2fitLSMHSM,i2fitLSMHSM);
	fileLSMHSMfit=[waventofitLSMHSM.',intensitiestofitLSMHSM.',fittedintensitiesLSMHSM.'];
	csvwrite([dirtosave '\LSMHSMfit.dat'],fileLSMHSMfit);

%---end fitting,saving-------------------------------------------------

    case(4)
        
%---saving all fitted parameters---------------------------

    fileparafit={'red chi^2 bg','adj R^2 bg','n','error','d','error','c1 bg','error','c2 bg','error','n0','nc','-','-','-','-','-','-';...
        redchisquarebg,adjrsquarebg,nfitbg,nerrorfitbg,dfitbg,derrorfitbg,c1fitbg,c1errorfitbg,c2fitbg,c2errorfitbg,...
        n0,nc,'-','-','-','-','-','-';'red chi^2 630','adj R^2 630','c1630','error','c2630','error','s1630','error','f1630','error',...
        'i1630','error','-','-','-','-','-','-';redchisquare630,adjrsquare630,c1fit630,c1errorfit630,c2fit630,...
        c2errorfit630,s1fit630,s1errorfit630,f1fit630,f1errorfit630,i1fit630,i1errorfit630,'-','-','-','-','-','-';...
        'red chi^2 LSMHSM','adj R^2 LSMHSM','c1LSMHSM','error','c2LSMHSM','error','sLSM','error','sHSM','error','fLSM','error',...
        'fHSM','error','iLSM','error','iHSM','error';redchisquareLSMHSM,adjrsquareLSMHSM,c1fitLSMHSM,c1errorfitLSMHSM,c2fitLSMHSM,c2errorfitLSMHSM,s1fitLSMHSM,...
        s1errorfitLSMHSM,s2fitLSMHSM,s2errorfitLSMHSM,f1fitLSMHSM,f1errorfitLSMHSM,f2fitLSMHSM,f2errorfitLSMHSM,i1fitLSMHSM,...
        i1errorfitLSMHSM,i2fitLSMHSM,i2errorfitLSMHSM};
%     xlswrite([dirtosave '\allpara.xls'],fileparafit);

%---calculating H content and saving for excel--------------
    hcontent630=4*pi*i1fit630*1.6e19/5.3e22*100;
    hcontentLSM=4*pi*i1fitLSMHSM*9.1e19/5.3e22*100;
    hcontentHSM=4*pi*i2fitLSMHSM*9.1e19/5.3e22*100;
    errorhcontent630=4*pi*i1errorfit630*1.6e19/5.3e22*100;
    errorhcontentLSM=4*pi*i1errorfitLSMHSM*9.1e19/5.3e22*100;
    errorhcontentHSM=4*pi*i2errorfitLSMHSM*9.1e19/5.3e22*100;
    rstar=i2fitLSMHSM/(i1fitLSMHSM+i2fitLSMHSM);
    errorrstar=(i2fitLSMHSM/(i1fitLSMHSM+i2fitLSMHSM)^2)*i1errorfitLSMHSM+(((i1fitLSMHSM+i2fitLSMHSM)-i2fitLSMHSM)/(i1fitLSMHSM+i2fitLSMHSM)^2)*i2errorfitLSMHSM;

    fileresname=fopen([dirtosave '\results.txt'],'wt');
    fprintf(fileresname,'hcontent630\t errorhcontent630\t hcontentLSM\t errorhcontentLSM\t hcontentHSM\t errorhcontentHSM\t rstar\t errorrstar\r');
    fileres=[hcontent630, errorhcontent630, hcontentLSM, errorhcontentLSM, hcontentHSM, errorhcontentHSM, rstar, errorrstar];
    fprintf(fileresname,'%e\t %e\t %e\t %e\t %e\t %e\t %e\t %e\r',fileres);
    fclose(fileresname);
    %dlmwrite([dirtosave '\results.txt'],fileres,'\t');
    
%---quit program-----------------------------------------------

        case(5)
            
            endprogram='y';

    end%of switch pgmstructure

end%of program loop