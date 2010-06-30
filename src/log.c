#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <stdarg.h>
#include <time.h>
#include <syslog.h>
#include <dlfcn.h>

#include "log.h"

void x_debug (char *format, ...)
{
#ifdef DEBUG
  va_list ap;
  va_start (ap, format);
  x_vaprintf (0, format, ap);
  va_end (ap);
#endif
}

void x_printf (char *format, ...)
{
  va_list ap;
  va_start (ap, format);
  x_vaprintf (format, ap);
  va_end (ap);
}

void x_perflog (char *format, ...)
{
  // va_list ap;
  // va_start (ap, format);
  // x_vaprintf (format, ap);
  // va_end (ap);
}

void x_vaprintf (char *format, va_list ap)
{
  int pid;
  time_t timet;
  struct tm *tms;
  char *time_str;
  char *ap_str;
  char *print_str;

  pid = getpid ();

  /* Prepare time string */
  timet = time (NULL);
  tms = localtime(&timet);
  asprintf (&time_str, "%.2i:%.2i:%.2i %.2i%.2i%.2i ", tms->tm_hour, tms->tm_min, tms->tm_sec, tms->tm_year-100, tms->tm_mon+1, tms->tm_mday);

  /* Prepare string from variable args */
  vasprintf (&ap_str, format, ap);

  /* Format message string */
  asprintf (&print_str, "%s [%i] - %s", time_str, getpid(), ap_str);
  free (time_str);
  free (ap_str);

  /* Print */
  fprintf (stdout, "%s\n", print_str);

  free (print_str);
}

