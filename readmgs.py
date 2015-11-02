#!/usr/bin/env python3
from os.path import expanduser,splitext,isdir,isfile
from glob import glob
from datetime import datetime,timedelta
from dateutil.parser import parse
from pandas import read_csv,DataFrame
from numpy import fromfile,int16,fliplr,loadtxt,array,arange
from matplotlib.pyplot import figure
import seaborn as sns
sns.color_palette(sns.color_palette("cubehelix"))
sns.set(context='notebook', style='whitegrid',
        rc={'image.cmap': 'cubehelix_r'}) #for contour
#

def loopmgs(path,vlim):
    if isdir(path):
        flist = glob(path+'/*.sri')
    elif isfile(path):
        flist = [path]
    else:
        raise IOError(path + ' not found')

    for f in flist:
        data = readmgsoccultation(f)
        plotoccultation(data,f,vlim)

def readmgsoccultation(imgfn):
    imgfn = expanduser(imgfn)
    stem = splitext(imgfn)[0]
    lblfn = stem +'.lbl'
    srtfn = stem +'.srt'

    P = readmgslbl(lblfn)
    nSamp = int(P.at['LINE_SAMPLES',1])
    nLine = int(P.at['LINES',1])
    scale = float(P.at['SCALING_FACTOR',1])
    offs  = float(P.at['OFFSET',1])

    data = fliplr((fromfile(imgfn,dtype=int16,count=nSamp*nLine).newbyteorder('B')*scale+offs).reshape(nSamp,nLine,order='F'))
#%% freq
    fs = 4.88 #step [Hz], from .lbl description
    f0 = 0 #Hz
    fend = 2500 #Hz
    f = arange(f0,fend-fs,fs)
#%% time
    t = getocculttime(srtfn)

    df = DataFrame(index=t,columns=f,
                   data=data.T)

    return df

def readmgslbl(fn):
    fn = expanduser(fn)
    lbl = read_csv(fn,sep='=',index_col=0,header=None)
    lbl.index = lbl.index.str.strip()
    return lbl

def getocculttime(srtfn):
    srtfn = expanduser(srtfn)
#%% get epoch date
    with open(srtfn,'r') as f:
        t0 = parse(f.read().split(',')[0])
    epoch = datetime(t0.year,t0.month,t0.day)
#%% get all times
    texp = loadtxt(srtfn,skiprows=1,usecols=[0],delimiter=',')

    return epoch + array([timedelta(seconds=s) for s in texp])

def plotoccultation(data,fn,vlim):
    assert isinstance(data,DataFrame)

    fg = figure()
    ax = fg.gca()
    h=ax.pcolormesh(data.index.values, data.columns.values,data.values.T,
                    vmin=vlim[0],vmax=vlim[1])
    c=fg.colorbar(h,ax=ax)
    c.set_label('RX Power [dBW]')
    ax.set_ylabel('Baseband frequency [Hz]')
    ax.set_xlabel('time')
    ax.set_title(fn)


if __name__ == '__main__':
    vlim=(-205,None)
    path = 'data'
    loopmgs(path,vlim)
