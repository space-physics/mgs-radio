from pathlib import Path
from datetime import datetime,timedelta
from dateutil.parser import parse
import numpy as np
from pandas import read_csv
from xarray import DataArray


def loopmgs(P):
    P = Path(P).expanduser()
    if P.is_dir():
        flist = sorted(P.glob('*.sri'))
    elif P.is_file():
        flist = [P]
    else:
        raise FileNotFoundError(f'{P} not found')

    data = []
    for f in flist:
        data.append(readmgsoccultation(f))

    return data,flist

def readmgsoccultation(imgfn):
    imgfn = Path(imgfn).expanduser()

    lblfn = imgfn.with_suffix('.lbl')
    srtfn = imgfn.with_suffix('.srt')

    P = readmgslbl(lblfn)
    nSamp = int(P.at['LINE_SAMPLES',1])
    nLine = int(P.at['LINES',1])
    scale = float(P.at['SCALING_FACTOR',1])
    offs  = float(P.at['OFFSET',1])

    data = np.fliplr((np.fromfile(str(imgfn),dtype='int16',count=nSamp*nLine).newbyteorder('B')*scale+offs).reshape(nSamp,nLine,order='F'))
#%% freq
    fs = 4.88 #step [Hz], from .lbl description
    f0 = 0 #Hz
    fend = 2500 #Hz
    f = np.arange(f0, fend-fs, fs)
#%% time
    t = getocculttime(srtfn)

    df = DataArray(data=data.T, dims=['time','freq'],coords={'time':t,'freq':f})

    return df

def readmgslbl(fn):
#%% parse the very messy .lbl file to get binary .sri file parameters
    """
    this is extremely messy in Matlab, can crash Matlab, and doesn't work in Octave.
    hence a move to Python. Much faster to write and understand.
    """

    fn = Path(fn).expanduser()
    lbl = read_csv(fn, sep='=', index_col=0, header=None)
    lbl.index = lbl.index.str.strip()
    return lbl

def getocculttime(srtfn):
    srtfn = Path(srtfn).expanduser()
#%% get epoch date
    with srtfn.open('r') as f:
        t0 = parse(f.read().split(',')[0])
    epoch = datetime(t0.year,t0.month,t0.day)
#%% get all times
    texp = np.loadtxt(str(srtfn), skiprows=1, usecols=[0], delimiter=',')

    return epoch + np.array([timedelta(seconds=s) for s in texp])


