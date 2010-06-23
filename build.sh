#!/bin/sh

net-snmp-config --compile-subagent --norm yeehaw xsnmpInternal.c fsTable.c xsanVolumeTable.c xsanStripeGroupTable.c xsanNodeTable.c xsanAffinityTable.c ram.c log.c command.c util.c -lpcre
