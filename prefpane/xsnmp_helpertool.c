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
	
	char *script_args[argc+2];
	script_args[0] = "ruby";
	fprintf(stderr, "Helper script_args[0] = %s\n", script_args[0]);
	script_args[1] = "--";
	fprintf(stderr, "Helper script_args[1] = %s\n", script_args[1]);
	int i;
	for (i=1; i < argc; i++)
	{
		script_args[i+1] = argv[i];
		fprintf(stderr, "Helper script_args[%i] = %s\n", i+1, script_args[i+1]);		
	}
	script_args[argc+1] = NULL;
	fprintf(stderr, "Helper script_args[%i] = NULL\n", argc+1);		
	
	/* Args :
	 *
	 * ruby
	 * --
	 * argv[1], etc
	 */
		
	execvp("ruby", script_args);
	
	return 0;
}

