#!/usr/bin/env python

from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

d = generate_distutils_setup(
    packages=['rosowl'],
    package_dir={'': 'src'},
    scripts=[],
    requires=['genowl', 'roslib', 'rospkg']
)

setup(**d)