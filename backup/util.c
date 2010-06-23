#include <string.h>
#include <unistd.h>
#include <pcre.h>
#include <sys/types.h>
#include <stdint.h>

uint32_t extract_uint_in_range (char *start, size_t len)
{
  char *val_str;
  asprintf (&val_str, "%.*s", len, start);
  return (uint32_t) strtoul(val_str, NULL, 10);
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
