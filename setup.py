#!/usr/bin/env python
req = ['nose','python-dateutil','pytz','numpy','pandas', 'matplotlib','seaborn','xarray']

# %%
from setuptools import setup  # enables develop

setup(name='mgsutils',
      packages=['mgsutils'],
      author='Michael Hirsch, Ph.D',
      description='Model of Earth atmosphere absorption and transmission vs. wavelength and location on Earth.',
      version='1.0.1',
      url = 'https://github.com/scivision/mgs-utils',
      classifiers=[
      'Intended Audience :: Science/Research',
      'Development Status :: 4 - Beta',
      'License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)',
      'Topic :: Scientific/Engineering :: Atmospheric Science',
      'Programming Language :: Python :: 3',
      'Programming Language :: Python',
      ],
      install_requires=req,
      python_requires='>=3.6',
	  )
