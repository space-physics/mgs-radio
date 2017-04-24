#!/usr/bin/env python
from mgsutils import Path,loopmgs
from numpy.testing import assert_allclose,run_module_suite

path=Path(__file__).parents[1]

def test_mgs():
    data,flist=loopmgs(path/'data')

    assert_allclose(data[0][23,38],-209.51)

if __name__ == '__main__':
    run_module_suite()
