#!/usr/bin/env python
from pathlib import Path
import pytest
#
from mgsutils import loopmgs
#
path = Path(__file__).parents[1]


def test_mgs():
    data, flist = loopmgs(path/'data')

    assert data[0][23, 38] == pytest.approx(-209.51)


if __name__ == '__main__':
    pytest.main([__file__])
