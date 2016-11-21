""" Usage: package.py <out.zip> <elsevier/arxiv>
packages all files needed to build the paper by hand into a zip file
"""

import sys
import os
import shutil
import tempfile
import glob
import zipfile

CUR_DIR = os.path.dirname(os.path.abspath(__file__))
TOP_DIR = "warmup"


def copy_file(zip, fn, d='', name=None):
    if name is None:
        name = fn
    name = os.path.join(TOP_DIR, name)
    fullname = os.path.join(CUR_DIR, fn)
    zip.write(fullname, name)


def copy_dir(zip, d, gl):
    for fn in glob.glob(os.path.join(d, gl)):
        if os.path.isfile(fn):
            copy_file(zip, fn, d)
        elif os.path.isdir(fn):
            copy_dir(zip, fn, gl)
        else:
            assert False


def main(zipname):
    with zipfile.ZipFile(zipname, 'w') as zip:
        for fn in ["warmup.tex", "bib.bib", "softdev.sty", "sigplanconf.cls",
                   "summary_macros.tex", "outlier_summaries.tex",
                   "vm_versions.tex", "warmup.bbl"]:
            copy_file(zip, fn)

        for fn in glob.glob("*.table"):
            copy_file(zip, fn)

        copy_dir(zip, "img", "**.pdf")
        copy_dir(zip, "examples", "**.pdf")
        copy_dir(zip, "category_examples", "*")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("usage: package.py file.zip")
        sys.exit(1)
    main(sys.argv[1])
