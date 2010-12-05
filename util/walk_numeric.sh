#!/bin/sh

snmpwalk -On -v 2c -m "+../mib/XSNMP-MIB.txt" -c public123 127.0.0.1 $1
