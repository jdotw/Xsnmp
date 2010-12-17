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
scp Xsnmp-Installer-$BUILDNUM.pkg www.lithiumcorp.com:/www/download.lithiumcorp.com/xsnmp/Xsnmp-Installer-$BUILDNUM.pkg

#
# Update web page
#

ssh www.lithiumcorp.com ln -sf /www/download.lithiumcorp.com/xsnmp/Xsnmp-Installer-$BUILDNUM.pkg /www/download.lithiumcorp.com/xsnmp/Xsnmp-Installer-CURRENT.pkg

# 
# Clean up
# 

cd $BASEDIR
