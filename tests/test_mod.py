#!/usr/bin/env python
from pathlib import Path
import pytest

import mgsradio

#
path = Path(__file__).parents[1]


def test_mgs():
    data, flist = mgsradio.loop_mgs(path / "data")

    assert data[0][23, 38] == pytest.approx(-209.51)


if __name__ == "__main__":
    pytest.main([__file__])
