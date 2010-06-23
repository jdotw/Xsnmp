#!/bin/sh

net-snmp-config --compile-subagent yeehaw osxVolumeTable.c xsanVolumeTable.c log.c command.c util.c -lpcre
