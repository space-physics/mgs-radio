#!/usr/bin/env python
from setuptools import setup
import subprocess

try:
    subprocess.run(['conda','install','--file','requirements.txt'])
except Exception as e:
    pass

setup(name='mgsutils',
	  description='Radio Occultation with Mars Global Surveyor',
	  author='Michael Hirsch',
      install_requires=['pathlib2'],
	  url='https://github.com/scienceopen/mgsutils',
        packages=['mgsutils']
	  )
