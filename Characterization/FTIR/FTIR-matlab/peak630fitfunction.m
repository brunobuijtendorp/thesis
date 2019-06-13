function y = peak630fitfunction(x,n0,nc,n,d,c1,c2,s1,f1,i1)


k=(i1/((sqrt(2*pi))*s1))*exp(-0.5*((x-f1)./s1).^2);
c=c1+c2*x.*1e-04;
tca2=4*nc^2./((n+nc)^2+k.^2);
ta02=4*(n^2+k.^2)./((n+n0)^2+k.^2);
tc02=4*nc^2/((nc+n0)^2);
rac2=((nc-n)^2+k.^2)./((nc+n)^2+k.^2);
ra02=((n0-n)^2+k.^2)./((n0+n)^2+k.^2);
reac=(nc^2-n^2-k.^2)./((nc+n)^2+k.^2);
rea0=(n0^2-n^2-k.^2)./((n0+n)^2+k.^2);
imac=2*nc*k./((nc+n)^2+k.^2);
ima0=2*n0*k./((n0+n)^2+k.^2);
imf=-2*pi*k.*d*1e-07;
rf=2*pi*n*d*1e-07;

y = 0.5*(1+c.^2).*(ta02.*tca2./tc02)./(exp(-2*imf.*x)+(c.^2).*ra02.*rac2.*exp(2*imf.*x)-2*c.*(rea0.*reac-ima0.*imac).*cos(2*rf*x)-2*c.*(rea0.*imac+reac.*ima0).*sin(2*rf*x));
