
function [IDC] = makeIDC(n_2arms,WIDCtot)
% makes IDSC with a total width (finger edge to finger edge) width WIDCtot 
global widelinewidth widegapwidth

Widc = (WIDCtot - widelinewidth)/2; %length of 1 CPW in the IDC
vertP           = 2*widelinewidth + 2 * widegapwidth;               %periodicity of the IDC in Y
IDC_height      = vertP * n_2arms - widelinewidth;   %total height edge to edge. NB: top = 0
CPWcap = widelinewidth + 2 * widegapwidth;

for n=1:n_2arms-1
    IDC{6*n-5}  = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth) , -(Widc+widelinewidth)/2                          , -(n-1)*vertP-widelinewidth/2 - widegapwidth); %left CPW of left IDC
    IDC{6*n-4}  = shiftXY(makebar(widegapwidth,CPWcap)      , -Widc-widelinewidth/2-widegapwidth/2             , -(n-1)*vertP-widelinewidth/2 - widegapwidth); %left plug of left CPW left IDC
    IDC{6*n-3}  = shiftXY(makebar(widegapwidth,CPWcap)      , -(widelinewidth+widegapwidth)/2                  , -(n-1)*vertP-3*widelinewidth/2 - 2*widegapwidth); %right plug below left CPW left IDC
    IDC{6*n-2}  = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth) , +(Widc+widelinewidth)/2                          , -(n-1)*vertP-widelinewidth/2 - widegapwidth); %right CPW of left IDC
    IDC{6*n-1}  = shiftXY(makebar(widegapwidth,CPWcap)      , +Widc+widelinewidth/2+widegapwidth/2             , -(n-1)*vertP-widelinewidth/2 - widegapwidth); %right plug of right CPW left IDC
    IDC{6*n}    = shiftXY(makebar(widegapwidth,CPWcap)      , (widelinewidth+widegapwidth)/2                   , -(n-1)*vertP-3*widelinewidth/2 - 2*widegapwidth); %right plug below left CPW left IDC

end
n = 6*n+1;
% one arm added, without the bottom stub
IDC{n}      = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth) , -(Widc+widelinewidth)/2                          , -(n_2arms-1)*vertP-widelinewidth/2 - widegapwidth); %left CPW of left IDC
IDC{n+1}    = shiftXY(makebar(widegapwidth,CPWcap)      , -Widc-widelinewidth/2-widegapwidth/2             , -(n_2arms-1)*vertP-widelinewidth/2 - widegapwidth); %left plug of left CPW left IDC
IDC{n+2}    = shiftXY(makeCPW(Widc,widelinewidth,widegapwidth) , +(Widc+widelinewidth)/2                          , -(n_2arms-1)*vertP-widelinewidth/2 - widegapwidth); %right CPW of left IDC
IDC{n+3}    = shiftXY(makebar(widegapwidth,CPWcap)      , +Widc+widelinewidth/2+widegapwidth/2             , -(n_2arms-1)*vertP-widelinewidth/2 - widegapwidth); %left plug of left CPW left IDC

end



