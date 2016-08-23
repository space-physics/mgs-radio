#!/usr/bin/env python
from mgsutils import Path,loopmgs
from numpy.testing import assert_allclose

path=Path(__file__).parents[1]

data,flist=loopmgs(path/'data')

assert_allclose(data[0][23,38],-209.51)
