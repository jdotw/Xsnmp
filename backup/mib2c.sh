#!/bin/sh

env MIBS="+./XSNMP-MIB.txt" mib2c -i $1
