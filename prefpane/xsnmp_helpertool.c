/*
 *  xsnmp_helpertool.c
 *  Xsnmp
 *
 *  Created by James Wilson on 5/08/07.
 *  Copyright 2009 LithiumCorp Pty Ltd. All rights reserved.
 *
 */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "xsnmp_helpertool.h"

int main (int argc, char *argv[])
{
	if (argc < 2) return 0;
	
	setuid (0);
	setgid (0);
	
	char *script_args[argc+1];
	int i;
	for (i=1; i < argc; i++)
	{
		script_args[i-1] = argv[i];
	}
	script_args[argc] = NULL;
		
	execlp("ruby", "ruby", script_args[0], NULL);

	return 0;
}

