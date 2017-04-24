.. image:: https://zenodo.org/badge/24042691.svg
   :target: https://zenodo.org/badge/latestdoi/24042691
.. image:: https://travis-ci.org/scivision/mgs-utils.svg?branch=master
    :target: https://travis-ci.org/scivision/mgs-utils
.. image:: https://coveralls.io/repos/github/scivision/mgs-utils/badge.svg?branch=master 
    :target: https://coveralls.io/github/scivision/mgs-utils?branch=master

=========
mgs-utils
=========

Mars Global Surveyor utilities(for radio occultation) 

 .. image:: tests/normal.png
    :alt: MGS occultation bifurcation

This example is simply of reading MGS ``.sri`` high-level occultation data and plotting.
The ``.sri`` data is big-endian int16, Fortran order.

Install
=======
::

    python setup.py develop

Example
=======
::

    python PlotMGSoccult.py

makes the plots for all the .sri, .lbl pairs in the current directory


Finding Data Files:
===================

`database <http://pds-geosciences.wustl.edu/missions/mgs/rsdata.html>`_

`Cumulative file index <http://pds-geosciences.wustl.edu/mgs/mgs-m-rss-5-sdp-v1/mors_1038/index/cumindex.tab>`_

`Example data used here <http://pds-geosciences.wustl.edu/mgs/mgs-m-rss-5-sdp-v1/mors_1014/>`_
