
import numpy as np
import argparse

from py_research.plotting import *
from py_research.whiskit_import import read_whiskit_data
from py_research.readfiles import *

'''This script is an example of plotting the signal output of the simulations. To run it, first install the dependencies:

- Python 3
- Numpy
- py_research from https://github.com/trashpirate/py-research - follow the instructions of the repo

'''

if __name__ == "__main__":

    directory = '../../output'

    # read command line arguments
    parser = argparse.ArgumentParser(description="Generation of Datasets")
    parser.add_argument("-ip", "--inputpath", default='test', type=str, help="Define simulation directory")

    args = parser.parse_args()
    inputPath = f'{directory}/{args.inputpath}'    

    # save data in mat and npz file for further analysis
    read_whiskit_data(pathin=inputPath, pathout=f'{inputPath}/{inputPath}_signals',t0=5, tf=0.5)

    # load simulated signals
    data = np.load(f'{inputPath}/{inputPath}_signals.npz')

    M = data['M']
    F = data['F']
    C = data['Col']

    X = data['X']
    Y = data['Y']
    Z = data['Z']

    whiskers = list(data['ids'])

    # move axes such that: whiskers x dims x time
    M = np.moveaxis(M, 1, 0) 
    F = np.moveaxis(F, 1, 0)

    # plot maximum moment signals across array
    mxmax = np.nanmax(np.abs(M[:,0,:]), axis=1)
    mymax = np.nanmax(np.abs(M[:,1,:]), axis=1)
    mzmax = np.nanmax(np.abs(M[:,2,:]), axis=1)
    
    fig = plt.figure()
    fig.suptitle('Non-contact Whisking')
    ax = fig.add_subplot(311)
    ax.bar(range(mxmax.size), mxmax)
    ax.xaxis.set_visible(False)
    ax.set_ylabel('Max. Mx ($\mu Nm$)')
    ax.set_yscale('log')
    
    ax = fig.add_subplot(312)
    ax.bar(range(mymax.size),mymax)
    ax.xaxis.set_visible(False)
    ax.set_ylabel('Max. My ($\mu Nm$)')
    ax.set_yscale('log')

    ax = fig.add_subplot(313)
    ax.bar(range(mzmax.size),mzmax)
    ax.set_ylabel('Max. Mz ($\mu Nm$)')
    ax.set_yscale('log')
    ax.set_xticklabels(whiskers)
    
    # plot individual signals for each whisker
    for k, (m, f) in enumerate(zip(M,F)):
        print(m.shape)
        fig = plt.figure(figsize=(doublecol,doublecol/2))
        ax = fig.add_subplot(211)
        ax.plot(m.T)
        ax.set_ylabel('Moments ($\mu Nm$)')
        ax.xaxis.set_visible(False)
        ax.legend(['Mx','My','Mz'])

        ax = fig.add_subplot(212)
        ax.plot(f.T)
        ax.set_ylabel('Forces (mN)')
        ax.set_xlabel('Time (samples)')
        ax.legend(['Fx','Fy','Fz'])

        plt.show()
    