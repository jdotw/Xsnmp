#!/bin/sh

sed 's/\(XSNMP-MIB::.*\) = \(.*\)$/<tr><td>\1<\/td><td>\2<\/td><td>\&nbsp;<\/td><\/tr>/g'
