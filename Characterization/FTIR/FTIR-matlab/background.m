function [parafitbg,errorfitbg,goodnessbg,outputbg,waventofit,intensitiestofit]= background(n0,nc,wavenumbers,intensities,filesize)


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

%two ways of fitting-----------------------------------
bgstructure=menu('Choose your case','If you know approx the thickness','Unknown thickness or unsatisfied with the first fit');

switch bgstructure

%---thickness known------------------------------------

    case(1)
        
        %title of cell
        celltitle={'thickness (nm)'};
    
    	%name of the dialog box
    	namedlg='Input thickness';
    
    	%number of lines visible for your input
    	numlines=1;
    
        
    	%creates the dialog box. the user input is stored into a cell array
    	para=inputdlg(celltitle,namedlg,numlines);
    
    	%read out parameters
    	d_bg=str2double(para{1});
        
       
    	%fit of 630 peak using standard initial parameters--------------------
    	n_bg=3.5;
    	c1_bg=1;
    	c2_bg=0;
    
        %initial parameters 
        inibg = [n_bg d_bg c1_bg c2_bg];

        %setting lower and upper limit
        lbn=n_bg-1;
        lbd=d_bg-100;
        lbc1=c1_bg-0.1;
        lbc2=c2_bg-0.3;

        ubn=n_bg+1;
        ubd=d_bg+100;
        ubc1=c1_bg+0.1;
        ubc2=c2_bg+0.3;

        %lower limit
        lb = [lbn lbd lbc1 lbc2];
        %upper bond
        ub = [ubn ubd ubc1 ubc2];

        [modelbg,goodnessbg,outputbg]=backgroundfit(waventofit,intensitiestofit,n0,nc,inibg,lb,ub);

%---finding start parameters-------------------------------        
        
    case(2)

        figure
        title('background')
        scatter(waventofit,intensitiestofit)
        hold on

        %userinput parameters----------------------------
        more='y';
        round=0;
        while more=='y'
         
        %title of cells
	    celltitle={'n','d','c1','c2'};
    
    	%name of the dialog box
    	namedlg='Input parameters';
    
    	%number of lines visible for your input
    	numlines=1;
    
        %the default parameters
    	if round==0
            defpara={'3.5','1000','1','0'};
    	end
    	if round>0
    	    defpara={para{1},para{2},para{3},para{4}};
    	end
    
    	%creates the dialog box. the user input is stored into a cell array
    	para=inputdlg(celltitle,namedlg,numlines,defpara);
    
    	%read out parameters
    	n_bg=str2double(para{1});
    	d_bg=str2double(para{2});
    	c1_bg=str2double(para{3});
    	c2_bg=str2double(para{4});
        intensitiesmanfit=backgroundfitfunction(waventofit,n_bg,d_bg,c1_bg,c2_bg,n0,nc);
    	colour=['y';'g';'m';'k';'r';'b'];
    	colourround=round+1;
    	plot(waventofit,intensitiesmanfit,colour(colourround))
    
   	    more=input('Change parameters? y/n','s');
    
    	if round==5
    	    round=0;
    	    hold off
    	    title('background')
    	    scatter(waventofit,intensitiestofit)
       	    hold on
        end
        round=round+1;
	end

	%fit of background using initial parameters-----------------------------
	%initial parameters 
	inibg = [n_bg d_bg c1_bg c2_bg];

	%setting lower and upper limit
	lbn=n_bg-1;
	lbd=d_bg-100;
	lbc1=c1_bg-0.1;
	lbc2=c2_bg-0.1;

	ubn=n_bg+1;
	ubd=d_bg+100;
	ubc1=c1_bg+0.1;
	ubc2=c2_bg+0.1;

	%lower limit
	lb = [lbn lbd lbc1 lbc2];
	%upper bond
	ub = [ubn ubd ubc1 ubc2];

	[modelbg,goodnessbg,outputbg]=backgroundfit(waventofit,intensitiestofit,n0,nc,inibg,lb,ub);
    end%of bgstructure

%fitted parameter
parafitbg=coeffvalues(modelbg);
errorfitbg=confint(modelbg);