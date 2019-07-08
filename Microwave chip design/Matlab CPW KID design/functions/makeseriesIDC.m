
function [IDC] = makeseriesIDC(n_2arms, Widc)
global widelinewidth widegapwidth IDC_height IDC_centralbar
%makes 2 series IDC, with the left centered around X = 0;
vertP           = 2*widelinewidth + 2 * widegapwidth;               %periodicity of the IDC in Y
IDC_height      = vertP * (n_2arms + 0.5)+ widegapwidth;   %total height edge to edge. NB: top = 0
X0_rightarm     = 2* Widc + 2 * widelinewidth + 2 * widegapwidth;       %center of the right arm,
IDC_rightedge   = X0_rightarm + Widc + widegapwidth + widelinewidth/2;   %right edge of the IDC
IDC_centralbar  =  Widc + widelinewidth + widegapwidth;             %cenetr position of central bar, width = widelinewidth + 2 * widegapwidth, wrt to X0
%IDC itslef: # of arms == 2* n2_arms
for n=1:n_2arms
    IDC{12*n-11} = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth) , -(Widc+widelinewidth)/2                          , -(n-1)*vertP-widelinewidth/2 - widegapwidth); %left CPW of left IDC
    IDC{12*n-10} = shiftXY(makebar(widegapwidth,widelinewidth)      , -Widc-widelinewidth/2+widegapwidth/2             , -(n-1)*vertP-widelinewidth/2 - widegapwidth); %left plug of left CPW left IDC
    IDC{12*n-9}  = shiftXY(makebar(widegapwidth,widelinewidth)      , -(widelinewidth+widegapwidth)/2                  , -(n-1)*vertP-3*widelinewidth/2 - 2*widegapwidth); %right plug below left CPW left IDC
    IDC{12*n-8}  = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth) , +(Widc+widelinewidth)/2                          , -(n-1)*vertP-widelinewidth/2 - widegapwidth); %right CPW of left IDC
    IDC{12*n-7}  = shiftXY(makebar(widegapwidth,widelinewidth)      , +Widc+widelinewidth/2-widegapwidth/2             , -(n-1)*vertP-widelinewidth/2 - widegapwidth); %right plug of right CPW left IDC
    IDC{12*n-6}  = shiftXY(makebar(widegapwidth,widelinewidth)      , (widelinewidth+widegapwidth)/2                   , -(n-1)*vertP-3*widelinewidth/2 - 2*widegapwidth); %right plug below left CPW left IDC
    
    % left IDC
    IDC{12*n-5} = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth)  , X0_rightarm-(Widc+widelinewidth)/2               , -(n-1)*vertP-widelinewidth/2 - widegapwidth);
    IDC{12*n-4} = shiftXY(makebar(widegapwidth,widelinewidth)       , X0_rightarm-Widc-widelinewidth/2+widegapwidth/2  , -(n-1)*vertP-widelinewidth/2 - widegapwidth);
    IDC{12*n-3}  = shiftXY(makebar(widegapwidth,widelinewidth)      , X0_rightarm-(widelinewidth+widegapwidth)/2       , -(n-1)*vertP-3*widelinewidth/2 - 2*widegapwidth);
    IDC{12*n-2}  = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth) , X0_rightarm+(Widc+widelinewidth)/2               , -(n-1)*vertP-widelinewidth/2 - widegapwidth);
    IDC{12*n-1}  = shiftXY(makebar(widegapwidth,widelinewidth)      , X0_rightarm+Widc+widelinewidth/2-widegapwidth/2  , -(n-1)*vertP-widelinewidth/2 - widegapwidth);
    IDC{12*n-0}  = shiftXY(makebar(widegapwidth,widelinewidth)      , X0_rightarm+(widelinewidth+widegapwidth)/2       , -(n-1)*vertP-3*widelinewidth/2 - 2*widegapwidth);
end
n = 12*n+1;
% one arm added
IDC{n} = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth) , -(Widc+widelinewidth)/2                          , -(n_2arms)*vertP-widelinewidth/2 - widegapwidth); %left CPW of left IDC
IDC{n+1} = shiftXY(makebar(widegapwidth,widelinewidth)      , -Widc-widelinewidth/2+widegapwidth/2             , -(n_2arms)*vertP-widelinewidth/2 - widegapwidth); %left plug of left CPW left IDC
IDC{n+2}  = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth) , +(Widc+widelinewidth)/2                          , -(n_2arms)*vertP-widelinewidth/2 - widegapwidth); %right CPW of left IDC

IDC{n+3} = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth)  , X0_rightarm-(Widc+widelinewidth)/2               , -(n_2arms)*vertP-widelinewidth/2 - widegapwidth); %left CPW of left IDC
IDC{n+4} = shiftXY(makebar(widegapwidth,widelinewidth)       , X0_rightarm+Widc+widelinewidth/2-widegapwidth/2  , -(n_2arms)*vertP-widelinewidth/2 - widegapwidth); %left plug of left CPW left IDC
IDC{n+5}  = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth) , X0_rightarm+(Widc+widelinewidth)/2               , -(n_2arms)*vertP-widelinewidth/2 - widegapwidth);

% vertical bar in the middle bottom, top of CPW
IDC{n+6} = shiftXY(makebar(widelinewidth + 2 * widegapwidth, widegapwidth), IDC_centralbar, -IDC_height+widelinewidth + 3* widegapwidth/2);
%2 horizontal bars @ bottom
IDC{n+7} = shiftXY(makebar(2*Widc + widelinewidth, widegapwidth),0 ,           -IDC_height+widegapwidth/2);
IDC{n+8} = shiftXY(makebar(2*Widc + widelinewidth, widegapwidth),X0_rightarm , -IDC_height+widegapwidth/2);
% small square closing of the hiole in the top left arm
IDC{n+9} = shiftXY(makebar(widelinewidth, widegapwidth),X0_rightarm , -widegapwidth/2);
end