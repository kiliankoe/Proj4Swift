'''Script for generating .modulemap file, since modulemap is very static
file type, and somehow we cannot use reactive path. So that we write this
script for generating it before build.
'''
import os
import sys

srcroot = os.environ['SRCROOT']

template = '''// generated by %(script_name)s, do not modify
module Proj4Lib [extern_c] {
    header "%(srcroot)s/lib/proj4/src/proj_api.h"
    export *
}
'''

with open(os.path.join(srcroot, 'Proj4Lib', 'module.modulemap'), 'wt') as fo:
    fo.write(template % dict(srcroot=srcroot, script_name=sys.argv[0]))