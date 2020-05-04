from pathlib import Path

from .read import read_mgs_occultation


def loop_mgs(P: Path) -> tuple:
    P = Path(P).expanduser()
    if P.is_dir():
        flist = sorted(P.glob("*.sri"))
    elif P.is_file():
        flist = [P]
    else:
        raise FileNotFoundError(f"{P} not found")

    data = []
    for f in flist:
        data.append(read_mgs_occultation(f))

    return data, flist
