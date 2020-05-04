# mgs-radio

[![image](https://zenodo.org/badge/24042691.svg)](https://zenodo.org/badge/latestdoi/24042691)
![Actions Status](https://github.com/space-physics/mgs-radio/workflows/ci/badge.svg)

Mars Global Surveyor utilities(for radio occultation)

![MGS occultation bifurcation](tests/normal.png)

This example is simply of reading MGS `.sri` high-level occultation data
and plotting. The `.sri` data is big-endian int16, Fortran order.

## Install

```sh
pip install -e .
```

## Example

```sh
python PlotMGSoccult.py
```

makes the plots for all the `.sri`, `.lbl` pairs in the current
directory

### Finding Data Files

[database](http://pds-geosciences.wustl.edu/missions/mgs/rsdata.html)

[Cumulative file index](http://pds-geosciences.wustl.edu/mgs/mgs-m-rss-5-sdp-v1/mors_1038/index/cumindex.tab)

[Example data used here](http://pds-geosciences.wustl.edu/mgs/mgs-m-rss-5-sdp-v1/mors_1014/)
