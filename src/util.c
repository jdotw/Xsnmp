#include <string.h>
#include <unistd.h>
#include <pcre.h>
#include <sys/types.h>
#include <stdint.h>
#include <net-snmp/net-snmp-config.h>
#include <net-snmp/net-snmp-includes.h>
#include <net-snmp/agent/net-snmp-agent-includes.h>
#include "log.h"
#include "util.h"

#define OVECCOUNT 90

uint32_t extract_uint_in_range (char *start, size_t len)
{
  char *val_str;
  asprintf (&val_str, "%.*s", (int) len, start);
  uint32_t val = strtoul(val_str, NULL, 10);
  free (val_str);
  return val;
}

uint32_t extract_uint_from_regex (char *data, size_t data_len, char *expression)
{
  char *val_str = NULL;
  size_t val_len = 0;
  
  if (extract_string_from_regex(data, data_len, expression, &val_str, &val_len))
  {
      uint32_t val = (uint32_t) strtoul(val_str, NULL, 10); 
      free (val_str);
      return val;
  } 
  else
  { return 0; }
}

void extract_U64_from_regex (char *data, size_t data_len, char *expression, U64 *val)
{
  char *val_str = NULL;
  size_t val_len = 0;
  
  if (extract_string_from_regex(data, data_len, expression, &val_str, &val_len))
  { 
    unsigned long long ullval = strtoull(val_str, NULL, 10);
    val->low  = ullval & 0x00000000ffffffffLL;
    val->high = (unsigned long long) (ullval & 0xffffffff00000000LL) >> 32;
    free (val_str);
  } 
  else
  { return; }
}

void extract_U64_in_range (char *start, size_t len, U64 *val)
{
  char *val_str = NULL;
  size_t val_len = 0;
  
  if (extract_string_in_range(start, len, &val_str, &val_len))
  { 
    unsigned long long ullval = strtoull(val_str, NULL, 10);
    val->low  = ullval & 0x00000000ffffffffLL;
    val->high = (unsigned long long) (ullval & 0xffffffff00000000LL) >> 32;
    free (val_str);
  } 
  else
  { return; }  
}

char* extract_string_in_range (char *start, size_t len, char **dest, size_t *dest_len)
{
  if (*dest) free (*dest);
  *dest = NULL;
  *dest_len = 0;
  asprintf (&*dest, "%.*s", (int) len, start);
  trim_end(*dest);
  *dest_len = strlen (*dest);
  return *dest;
}

char* extract_string_from_regex (char *data, size_t data_len, char *expression, char **dest, size_t *dest_len)
{
  if (*dest) free (*dest);
  *dest = NULL;
  *dest_len = 0;
  
  const char *error;
  int erroffset;
  int ovector[OVECCOUNT];
  
  pcre *re = pcre_compile(expression, PCRE_MULTILINE, &error, &erroffset, NULL);
  if (re == NULL) { x_printf ("ERROR: extract_string_from_regex failed to compile regex '%s'", expression); return NULL; }
  
  int rc = pcre_exec(re, NULL, data, data_len, 0, 0, ovector, OVECCOUNT);
  if (rc >= 2)  
  {
    asprintf (dest, "%.*s", ovector[3] - ovector[2], data + ovector[2]);
    *dest_len = strlen (*dest);
    trim_end(*dest);
  }
  
  pcre_free(re);    /* Release memory used for the compiled pattern */
  
  return *dest;
}

int extract_boolean_from_regex (char *data, size_t data_len, char *expression)
{
  char *str = NULL;
  size_t str_len = 0;
  int val = -1;
  if (extract_string_from_regex(data, data_len, expression, &str, &str_len))
  {
    if (strstr(str, "Yes"))
    {
      val = 1;
    }
    else if (strstr(str, "No"))
    {
      val = 0;
    }
  }
  if (str) free (str);
  return val;
}

uint32_t scale_U64_to_K (U64 *val)
{
  unsigned long long raw = (((unsigned long long) val->high) << 32) + val->low;
  return (uint32_t) (raw / 1000ULL);
}

void trim_end (char *str)
{
  int i;
  for (i=strlen(str)-1; i >= 0; i--)
  {
    if (str[i] == ' ') str[i] = '\0';
    else break;
  }  
}

U64 sum_U64 (U64 x, U64 y)
{
    unsigned long long xull = x.low + ((unsigned long long) x.high << 32);
    unsigned long long yull = y.low + (((unsigned long long) y.high) << 32);   
    U64 result;
    result.low  =  (xull + yull) & 0x00000000ffffffffLL;
    result.high = ((xull + yull) & 0xffffffff00000000LL) >> 32;
    return result;
}
