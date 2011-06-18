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
# Amazon AWS
#

cd "$DMGDIR"
mkdir -p "AWS/release"
cp Xsnmp-Installer-$BUILDNUM.pkg "AWS/release/Xsnmp-Installer-$BUILDNUM.$BUILDNUM_SHORT.pkg"
s3put -d 2 -c 100 -b xsnmp -g public-read -p "$PWD/AWS/" "$PWD/AWS/release"
rm -rf "AWS"

echo "Uploaded to http://s3.amazonaws.com/xsnmp/release/Xsnmp-Installer-$BUILDNUM.$BUILDNUM_SHORT.pkg"

# 
# Clean up
# 

cd $BASEDIR
