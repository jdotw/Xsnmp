#!/bin/sh

env MIBS="+../mib/XSNMP-MIB.txt" mib2c -i $1
