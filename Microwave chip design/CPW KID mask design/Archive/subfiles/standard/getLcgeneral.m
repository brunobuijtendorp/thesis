
function Lc=getLcgeneral(Freq,Q,Qdesign,plotje)
% take Q parameterizatiohn to get the parameter for a given desired Q and F

%data from simulations; Lc foupler length, F is resonance Freq in GHz logQ is matrix with log10(Q) %
Lc=Qdesign(1,2:end);
F=Qdesign(2:end,1);
LogQ=Qdesign(2:end,2:end);

if plotje
    figure(4)
    surf(Lc,F,LogQ);xlabel('Coupler length');ylabel('Fres');zlabel('logQ')
end

if log10(Q)>max(interp2(Lc,F,LogQ,Lc,Freq,'spline'))
    error('Q demanded too high');
    
elseif log10(Q)<min(interp2(Lc,F,LogQ,Lc,Freq,'spline'))
    error('Q demanded too low (or Fout of range)');
    
else
    Lc=spline(interp2(Lc,F,LogQ,Lc,Freq,'spline'),Lc,log10(Q));%interp gets Q(@FReq), spline gives Lc for desired Q
end

end
