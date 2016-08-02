#!/usr/bin/env python
from mgsutils import Path
from numpy.testing import assert_allclose
from mgsutils.readmgs import loopmgs

path=Path(__file__).parents[1]

data,flist=loopmgs(path/'data')

assert_allclose(data[0][23,38],-209.51)
