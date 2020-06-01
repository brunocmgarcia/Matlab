# -*- coding: utf-8 -*-
"""
Created on Fri May 29 10:43:52 2020

@author: bruno
"""

"""
This is the script to perform the FOOOF based on the power obtained using pwelch in the matlab script
s190122_quickanddirtybetapower.m. The file from matlab must contain only one channel from one date (for
example: ch30 from TP00, OR ch30 from TP21). welch_freq is the frequency values from the pwelch function,
and the psd result from pwelch is the one below (tp21_m1 for example). 

MANUALLY CHANGE: name of file to load in the first step and name of mat file to be saved in the last step

"""
%matplotlib inline

import numpy as np
from scipy.io import loadmat, savemat

from fooof import FOOOF

# Load the mat file (file format: 'ruhe_' + 'TP00_' OR 'TP21_' + 'M1' or 'STR' or 'SNR')
data = loadmat('ruhe_TP21_M1.mat')

# Unpack data from dictioanry, and squeeze numpy arrays
freqs = np.squeeze(data['welch_freq'])
psd = np.squeeze(data['tp21_m1']) # here it can be tp00 or tp21 followed by m1, str or snr

# Initialize FOOOF object
fm = FOOOF(max_n_peaks=2)

# Fit the FOOOF model, and report
fm.report(freqs, psd, [1, 100])

# Extract FOOOF results from object
fooof_results = fm.get_results()

#print results
print('Aperiodic parameters: \n', fm.aperiodic_params_, '\n')
    
# Peak parameters (CF: center frequency of the extracted peak, PW: power of
# the peak, over and above the aperiodic component, BW: bandwidth of the extracted peak)
print('Peak parameters: \n', fm.peak_params_, '\n')
    
# Goodness of fit measures
print('Goodness of fit:')
print(' Error - ', fm.error_)
print(' R^2   - ', fm.r_squared_, '\n')
    
# Check how many peaks were fit
print('Number of fit peaks: \n', fm.n_peaks_)


# Convert FOOOF results to a dictionary
#  This is useful for saving out as a mat file
fooof_results_dict = fooof_results._asdict()

# Save FOOOF results out to a mat file
savemat('fooofed_tp21_m1.mat', fooof_results_dict)



