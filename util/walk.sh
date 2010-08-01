#!/bin/sh

snmpwalk -v 2c -m "+../mib/XSNMP-MIB.txt" -c public123 127.0.0.1 enterprises.20038
