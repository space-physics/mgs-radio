#!/usr/bin/env python
req = ['nose','python-dateutil','numpy','pandas', 'xarray']

# %%
from setuptools import setup, find_packages

setup(name='MGSutils',
      packages=find_packages(),
      author='Michael Hirsch, Ph.D',
      description='Mars Global Surveyor radio occultation experiment read and plot.',
      long_description=open('README.rst').read(),
      version='1.0.2',
      url = 'https://github.com/scivision/mgs-utils',
      classifiers=[
      'Intended Audience :: Science/Research',
      'Development Status :: 4 - Beta',
      'License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)',
      'Topic :: Scientific/Engineering :: Atmospheric Science',
      'Programming Language :: Python :: 3',
      ],
      install_requires=req,
      python_requires='>=3.6',
      extras_require={'plot':['matplotlib','seaborn',],},
	  )
