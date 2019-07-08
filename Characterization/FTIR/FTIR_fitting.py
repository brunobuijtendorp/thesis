import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import splrep
from scipy.optimize import curve_fit
from scipy.integrate import trapz
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)

def fit_FTIR(data, thickness, show_windows=False):
    thickness *= 1e-7 # convert from nm to cm
    x = data[:,0]
    absorbance = np.log10(1/data[:,1])
    absorption_coeff = 2.303*absorbance/thickness 
    y = absorption_coeff
    
    # Coarse window selection
    peak1_window = [400,800]
    peak1_x = x[np.logical_and(x>peak1_window[0], x<peak1_window[1])]
    peak1_y = y[np.logical_and(x>peak1_window[0], x<peak1_window[1])]

    peak2_window = [1800,2300]
    peak2_x = x[np.logical_and(x>peak2_window[0], x<peak2_window[1])]
    peak2_y = y[np.logical_and(x>peak2_window[0], x<peak2_window[1])]

    # Baseline correction
    peak1_fine_window = [535,760]
    not_peak1 = np.logical_not(np.logical_and(peak1_x>peak1_fine_window[0], peak1_x<peak1_fine_window[1]))
    x1 = peak1_x[not_peak1]
    y1= peak1_y[not_peak1]

    xe = np.amin(peak1_x)
    xb = np.amax(peak1_x)
    y_spline1 = splrep(x1,y1,xe=xe, xb=xb, k=1)
    c_peak1_y = peak1_y - y_spline1

    if show_windows == True:
        fig,ax = plt.subplots(figsize=(16.5,6))
        ax.plot(peak1_x,peak1_y)
        ax.plot(peak1_x,y_spline1)
        ax.scatter(x1,y1,s=10,color='g')

    peak2_fine_window = [1880,2180]
    not_peak2 = np.logical_not(np.logical_and(peak2_x>peak2_fine_window[0], peak2_x<peak2_fine_window[1]))
    x1 = peak2_x[not_peak2]
    y1= peak2_y[not_peak2]

    y_spline2 = spline(x1,y1,peak2_x, order=1)
    c_peak2_y = peak2_y - y_spline2

    if show_windows == True:
        fig,ax = plt.subplots(figsize=(16.5,6))
        ax.plot(peak2_x,peak2_y)
        ax.plot(peak2_x,y_spline2)
        ax.scatter(x1,y1,s=10,color='g')
    
    # Fitting LSM-HSM
    def gaussian(x,mu,sigma,a):
        y = a*np.exp(-0.5*((x-mu)/sigma)**2)
        return y

    def model(x, mu2000, sigma2000, a2000, mu2080, sigma2080, a2080):
        y = gaussian(x,mu2000,sigma2000,a2000)  + gaussian(x,mu2080,sigma2080,a2080)
        return y

    p0 = [2000,30,1e3, 2080,30,1e3]
    #bounds = ([1950,0,0, 2050,0,0],[2005,np.inf,np.inf, 2150, np.inf, np.inf])
    popt2, pcov2 = curve_fit(model, peak2_x, c_peak2_y, p0=p0)

    fig, ax = plt.subplots(figsize=(16.5,6))
    ax.scatter(peak2_x,c_peak2_y,s=2)
    ax.plot(peak2_x, model(peak2_x,*popt2))
    ax.plot(peak2_x, gaussian(peak2_x,popt2[0],popt2[1],popt2[2]), alpha=0.5)
    ax.plot(peak2_x, gaussian(peak2_x,popt2[3],popt2[4],popt2[5]), alpha=0.5)
    
    # Fitting content peak
    p0 = [640,50,1e-3]
    #bounds = ([1950,0,0, 2050,0,0],[2005,np.inf,np.inf, 2150, np.inf, np.inf])
    popt1, pcov1 = curve_fit(gaussian, peak1_x, c_peak1_y, p0=p0)

    fig, ax = plt.subplots(figsize=(16.5,6))
    ax.scatter(peak1_x,c_peak1_y,s=2)
    ax.plot(peak1_x, gaussian(peak1_x,*popt1))
    
    # Calculate microstructure parameter R
    xpoints = np.linspace(peak2_window[0],peak2_window[1], num=1000)
    dx = xpoints[1] - xpoints[0]
    I_2000 = trapz(gaussian(xpoints,popt2[0],popt2[1],popt2[2])/xpoints, xpoints, dx=dx)
    I_2080 = trapz(gaussian(xpoints,popt2[3],popt2[4],popt2[5])/xpoints, xpoints, dx=dx)
    R = I_2080/(I_2080 + I_2000)
    print('R: ' + str(R))
    
    # Calculate hydrogen content
    xpoints = np.linspace(peak1_window[0],peak1_window[1], num=1000)
    dx = xpoints[1] - xpoints[0]
    A = 1.6*10**19
    N = 5*10**22
    C = A/N * trapz(gaussian(xpoints,*popt1)/xpoints, xpoints, dx=dx)
    print('C: ' + str(C))
    