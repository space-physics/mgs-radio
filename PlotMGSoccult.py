#!/usr/bin/env python3
from matplotlib.pyplot import show
from mgsutils.readmgs import loopmgs
from mgsutils.plots import plotoccultation


if __name__ == '__main__':
    from argparse import ArgumentParser
    p = ArgumentParser()
    p.add_argument('path',help='path or filename of .SRI files',nargs='?',default='data')
    p.add_argument('--vlim',help='plotting clim',nargs=2,type=float,default=(-205,None))
    p = p.parse_args()

    data,flist=loopmgs(p.path)

    for d,f in zip(data,flist):
        plotoccultation(d,f,p.vlim)

    show()
