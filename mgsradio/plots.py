import typing as T
from pathlib import Path
from xarray import DataArray

from matplotlib.pyplot import figure
import matplotlib.dates as mdates


def plot_occultation(data: DataArray, fn: Path, vlim: T.Sequence):

    fg = figure()
    ax = fg.gca()

    h = ax.pcolormesh(data.time, data.freq, data.values.T, vmin=vlim[0], vmax=vlim[1])

    c = fg.colorbar(h, ax=ax)
    c.set_label("RX Power [dBW]")
    ax.set_ylabel("Baseband frequency [Hz]")
    ax.set_xlabel("time")
    ax.set_title(str(fn))

    ax.xaxis.set_major_formatter(mdates.DateFormatter("%H:%M:%S"))
    # fg.autofmt_xdate()
