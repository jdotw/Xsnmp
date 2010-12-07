#!/bin/bash

PKGDIR="$PWD"
SRCDIR="$PWD/src"
DMGDIR="$PWD/packaging"
BASEDIR=$PWD


#
# Get Build Number
#

PKGSRCDIR="$PWD/prefpane"
cd "$PKGSRCDIR"
BUILDNUM=`agvtool mvers | grep '^Found CFBundleShortVersionString of'  | awk '{ print $4 }' | sed 's/\"//g'`
BUILDNUM_SHORT=`agvtool vers | grep '^ '  | sed 's/^    //g'`
echo "Build number is $BUILDNUM ($BUILDNUM_SHORT)"
cd $BASEDIR

#
# Scp 
#

cd "$DMGDIR"
scp Xsnmp-Installer-$BUILDNUM.pkg www.lithiumcorp.com:/www/xsnmp.com/download/prerelease/Xsnmp-Installer-$BUILDNUM.pkg

#
# Update web page
#

ssh www.lithiumcorp.com sed -i '' -e "s/0\.9\.[0-9]*/$BUILDNUM/g" /www/xsnmp.com/index.html

# 
# Clean up
# 

cd $BASEDIR
