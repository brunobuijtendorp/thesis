from scipy import optimize
import numpy as np
import matplotlib.pyplot as plt

def gaussian(x,mu,sigma,a):
    y = a*np.exp(-0.5*((x-mu)/sigma)**2)
    return y

def lorentzian(x,mu,gamma,a):
    y = a*1/((x-mu)**2+(gamma/2)**2)
    return y

def model(x,mu150,sigma150,a150,\
          mu330,sigma330,a330,\
          muLO,sigmaLO,aLO,\
          mu480,sigma480,a480,\
          gamma520,a520,\
          mu660,sigma660,a660):
    y = gaussian(x,mu150,sigma150,a150)  + gaussian(x,mu480,sigma480,a480) + gaussian(x, mu330,sigma330,a330) \
    + gaussian(x, muLO,sigmaLO,aLO) + lorentzian(x,520,gamma520,a520) + gaussian(x,mu660,sigma660,a660)
    return y

def polymodel(x,mu150,sigma150,a150,\
          mu330,sigma330,a330,\
          muLO,sigmaLO,aLO,\
          mu480,sigma480,a480,\
          gamma520,a520,\
          mu660,sigma660,a660,\
          mu500,sigma500,a500):
    y = gaussian(x,mu500,sigma500,a500) + model(x,mu150,sigma150,a150,\
          mu330,sigma330,a330,\
          muLO,sigmaLO,aLO,\
          mu480,sigma480,a480,\
          gamma520,a520,\
          mu660,sigma660,a660)
    return y

def baseline_correction(x,y):
    y = y[x < 100]
    x = x[x < 100]
    def horizontal_line(x,a):
        y = a
        return y
    p0 = [0]
    popt, pcov = optimize.curve_fit(horizontal_line, x, y, p0=p0)
    return popt[0]

def fit(x,y,poly=0):
    y = y[x<700]
    x = x[x<700]
  
    y -= baseline_correction(x,y)

    p0 = [150,50,550,\
          330,50,500,\
          380,50,500,\
          480,40,750,\
          40,750,\
          660,40,400]
              #mu,sigma,a
    bounds = ([100,0,0,\
               250,0,0,\
               350,0,0,\
               400,0,0,\
                 0,0,\
               550,0,0],\
              \
              [200,80,2500,\
               350,80,2500,\
               470,80,2500,\
               500,80,2500,\
                50,2500,\
               700,80,2500])

    if poly:
        p0.extend([500,40,750,])
        bounds[0].extend([490,0,0])
        bounds[1].extend([510,80,2500])
        
        popt, pcov = optimize.curve_fit(polymodel, x, y, p0=p0, bounds=bounds)
        fit = polymodel(x,popt[0],popt[1],popt[2],popt[3],popt[4],popt[5],popt[6],popt[7],popt[8],\
                    popt[9],popt[10],popt[11],popt[12],popt[13],popt[14],popt[15],popt[16],popt[17],popt[18],popt[19])
    
    else:
        popt, pcov = optimize.curve_fit(model, x, y, p0=p0, bounds=bounds)
        fit = model(x,popt[0],popt[1],popt[2],popt[3],popt[4],popt[5],popt[6],popt[7],popt[8],\
                    popt[9],popt[10],popt[11],popt[12],popt[13],popt[14],popt[15],popt[16])
    
    
    fig, ax = plt.subplots(figsize=(16.5,6))
    ax.scatter(x,y, s=1.5)
    ax.plot(x,fit)
    ax.plot(x, gaussian(x,popt[0],popt[1],popt[2]), alpha=0.5, label='TA 150: ' + str(int(popt[0])))
    ax.plot(x, gaussian(x,popt[3],popt[4],popt[5]), alpha=0.5, label='LA 330: ' + str(int(popt[3])))
    ax.plot(x, gaussian(x,popt[6],popt[7],popt[8]), alpha=0.5, label='LO: ' + str(int(popt[6])))
    ax.plot(x, gaussian(x,popt[9],popt[10],popt[11]), alpha=0.5, label='TO 480: ' + str(int(popt[9])))
    if poly:
        ax.plot(x, gaussian(x,popt[17],popt[18],popt[19]), alpha=0.5, label='TO 500: ' + str(int(popt[17])))
    ax.plot(x, lorentzian(x,520,popt[12],popt[13]), alpha=0.4, label='TO 520')
    ax.plot(x, gaussian(x,popt[14],popt[15],popt[16]), alpha=0.5, label='660: ' + str(int(popt[14])))
    
    ax.set_xlabel(r'Wavenumber ($cm^{-1}$)')
    ax.set_ylabel('Intensity (a.u.)')
    ax.legend()

    return popt, ax

def relative_intensity(popt,xmin=0,xmax=700,dx=0.001):
    x = np.arange(0,700,0.001)
    y = np.trapz(gaussian(x,popt[0],popt[1],popt[2])) / np.trapz(gaussian(x,popt[9],popt[10],popt[11]))
    sigma_TO = popt[10]
    FWHM_TO = 2*np.sqrt(2*np.log(2)) * sigma_TO

    dtheta_ratio = (y - 0.0606)/0.0078
    dtheta_FWHM = (FWHM_TO - 18.4) / 6.6
    dtheta_omega = (popt[9] - 505.5)/(-2.5)
    
    return y, dtheta_ratio, dtheta_FWHM, dtheta_omega    