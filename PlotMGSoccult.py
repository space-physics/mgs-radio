#!/usr/bin/env python
from matplotlib.pyplot import show

from mgsutils import loop_mgs
from mgsutils.plots import plot_occultation

#
import seaborn as sns

sns.color_palette(sns.color_palette("cubehelix"))
sns.set(context="notebook", style="whitegrid", rc={"image.cmap": "cubehelix_r"})  # for contour

if __name__ == "__main__":
    from argparse import ArgumentParser

    p = ArgumentParser()
    p.add_argument("path", help="path or filename of .SRI files", nargs="?", default="data")
    p.add_argument("--vlim", help="plotting clim", nargs=2, type=float, default=(-205, None))
    p = p.parse_args()

    data, flist = loop_mgs(p.path)

    for d, f in zip(data, flist):
        plot_occultation(d, f, p.vlim)

    show()
