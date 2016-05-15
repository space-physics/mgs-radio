=========
mgs-utils
=========

Mars Global Surveyor utilities(for radio occultation) 

 .. image:: normal.png
    :alt: MGS occultation bifurcation

This example is simply of reading MGS .sri high-level occultation data and plotting.

The Matlab code is deprecated and doesn't work with Octave. A good example of why NOT to use Matlab for messy data files.

The .SRI data is big-endian int16, Fortran order.

Install
=======
::

    python setup.py develop

Example
=======
::

    python readmgs.py 

makes the plots for all the .sri, .lbl pairs in the current directory


Finding Data Files:
===================

`database <http://pds-geosciences.wustl.edu/missions/mgs/rsdata.html>`_

`Cumulative file index <http://pds-geosciences.wustl.edu/mgs/mgs-m-rss-5-sdp-v1/mors_1038/index/cumindex.tab>`_

`Example data used here <http://pds-geosciences.wustl.edu/mgs/mgs-m-rss-5-sdp-v1/mors_1014/>`_



