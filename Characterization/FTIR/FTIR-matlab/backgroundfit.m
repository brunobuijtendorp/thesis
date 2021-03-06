function [cf_,gof,output] = backgroundfit(waventofit,intensitiestofit,n0,nc,ini,ll,ul)
%BACKGROUNDFIT    Create plot of datasets and fits
%   BACKGROUNDFIT(WAVENTOFIT,INTENSITIESTOFIT)
%   Creates a plot, similar to the plot in the main curve fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with cftool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  1


global dirtosave



% Data from dataset "intensitiestofit vs. waventofit":
%    X = waventofit:
%    Y = intensitiestofit:
%    Unweighted
%
% This function was automatically generated on 30-Jun-2009 11:42:40

% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[440.667 131 680 484]);
legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');
axes(ax_); hold on;

 
% --- Plot data originally in dataset "intensitiestofit vs. waventofit"
waventofit = waventofit(:);
intensitiestofit = intensitiestofit(:);
h_ = line(waventofit,intensitiestofit,'Parent',ax_,'Color',[0.333333 0 0.666667],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',6);
xlim_(1) = min(xlim_(1),min(waventofit));
xlim_(2) = max(xlim_(2),max(waventofit));
legh_(end+1) = h_;
legt_{end+1} = 'intensitiestofit vs. waventofit';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
   xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
   set(ax_,'XLim',xlim_)
else
    set(ax_, 'XLim',[2263.0141400000002, 4926.4238599999999]);
end


% --- Create fit "fit 1"
%uservariation upper lower bounds
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',ll,'Upper',ul,'Startpoint',ini);
ok_ = isfinite(waventofit) & isfinite(intensitiestofit);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
%st_ = [1 0 1000 3.5 ];%user variation
%set(fo_,'Startpoint',st_);
%ft_ = fittype('0.5*(1+(c1+c2*x*1e-04)^2)*((4*(n^2+(1e-03)^2)/((n+1)^2+(1e-03)^2))*(4*3.42^2/((n+3.42)^2+(1e-03)^2))/(4*3.42^2/((3.42+1)^2)))/(exp(-2*(-2*pi*(1e-03)*d*1e-07)*x)+(c1+c2*x*1e-04)^2*(((1-n)^2+(1e-03)^2)/((1+n)^2+(1e-03)^2))*(((3.42-n)^2+(1e-03)^2)/((3.42+n)^2+(1e-03)^2))*exp(2*(-2*pi*(1e-03)*d*1e-07)*x)-2*(c1+c2*x*1e-04)*(((1^2-n^2-(1e-03)^2)/((1+n)^2+(1e-03)^2))*((3.42^2-n^2-(1e-03)^2)/((3.42+n)^2+(1e-03)^2))-(2*1*(1e-03)/((1+n)^2+(1e-03)^2))*(2*3.42*(1e-03)/((3.42+n)^2+(1e-03)^2)))*cos(2*(2*pi*n*d*1e-07)*x)-2*(c1+c2*x*1e-04)*(((1^2-n^2-(1e-03)^2)/((1+n)^2+(1e-03)^2))*(2*3.42*(1e-03)/((3.42+n)^2+(1e-03)^2))+((3.42^2-n^2-(1e-03)^2)/((3.42+n)^2+(1e-03)^2))*(2*1*(1e-03)/((1+n)^2+(1e-03)^2)))*sin(2*(2*pi*n*d*1e-07)*x))',...
%     'dependent',{'y'},'independent',{'x'},...
%     'coefficients',{'c1', 'c2', 'd', 'n'});

%fitmodel--------------------------------------

ft_=fittype('0.5*(1+(c1+c2*x*1e-04)^2)*((4*(n^2+(1e-03)^2)/((n+n0)^2+(1e-03)^2))*(4*nc^2/((n+nc)^2+(1e-03)^2))/(4*nc^2/((nc+n0)^2)))/(exp(-2*(-2*pi*(1e-03)*d*1e-07)*x)+(c1+c2*x*1e-04)^2*(((n0-n)^2+(1e-03)^2)/((n0+n)^2+(1e-03)^2))*(((nc-n)^2+(1e-03)^2)/((nc+n)^2+(1e-03)^2))*exp(2*(-2*pi*(1e-03)*d*1e-07)*x)-2*(c1+c2*x*1e-04)*(((n0^2-n^2-(1e-03)^2)/((n0+n)^2+(1e-03)^2))*((nc^2-n^2-(1e-03)^2)/((nc+n)^2+(1e-03)^2))-(2*n0*(1e-03)/((n0+n)^2+(1e-03)^2))*(2*nc*(1e-03)/((nc+n)^2+(1e-03)^2)))*cos(2*(2*pi*n*d*1e-07)*x)-2*(c1+c2*x*1e-04)*(((n0^2-n^2-(1e-03)^2)/((n0+n)^2+(1e-03)^2))*(2*nc*(1e-03)/((nc+n)^2+(1e-03)^2))+((nc^2-n^2-(1e-03)^2)/((nc+n)^2+(1e-03)^2))*(2*n0*(1e-03)/((n0+n)^2+(1e-03)^2)))*sin(2*(2*pi*n*d*1e-07)*x))',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'n','d','c1','c2'},'problem',{'n0','nc'});


% Fit this model using new data
[cf_,gof,output] = fit(waventofit(ok_),intensitiestofit(ok_),ft_,fo_,'problem',{n0,nc});

%goodness of fit statistics------------------------
%Sum of squares due to error
sse=gof.sse;
%degrees of freedom
dfe=gof.dfe;
%reduced chi^2
redchisquare=sse/dfe;
%deg of freedom adjusted coefficient of determination
adjrsquare=gof.adjrsquare;


% Plot this fit and save as .png
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'fit 1';
title('backgroundfit')
ylabel('intensity')
xlabel('wavenumber [cm^{-1}]')
text(waventofit(20),intensitiestofit(20)+0.01,{['red \chi^2=',num2str(redchisquare)];['adj R^2=',num2str(adjrsquare)]})
print('-dpng', [dirtosave '\bgfit.png'])

% Done plotting data and fits.  Now finish up loose ends.
%hold off;
%leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'}; 
%h_ = legend(ax_,legh_,legt_,leginfo_{:});  % create legend
%set(h_,'Interpreter','none');
%xlabel(ax_,'');               % remove x label
%ylabel(ax_,'');               % remove y label
