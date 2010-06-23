#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/wait.h>
#include <string.h>
#include <errno.h>

#include "log.h"
#include "command.h"

char* x_command_run (char *command_str, int flags)
{
  int num;
  int fd1[2], fd2[2];
  pid_t pid;

  num = pipe(fd1);
  if (num == -1) 
  { x_printf ("x_command_run failed to create fd1 pipe"); return NULL; }
  
  num = pipe(fd2);
  if (num == -1) 
  { x_printf ("x_command_run failed to create fd2 pipe"); return NULL; }

  pid = fork ();
  if (pid == -1)
  { x_printf ("x_command_run failed to fork"); return NULL; }

  if (pid > 0)
  {
    /* Parent process, listen for response from fd2[0] */
    close(fd1[0]);
    close(fd2[1]);
    
    size_t recvdata_len = 0;
    char *recvdata = NULL;
    
    int finished = 0;
    while (!finished)
    {
      fd_set read_fds;
      FD_ZERO(&read_fds);
      FD_SET(fd2[0], &read_fds);

      struct timeval timeout = {30, 0};
      num = select(fd2[0]+1, &read_fds, NULL, NULL, &timeout);
      if (num > 0)
      {
        /* Data is to be read */
        char buf[1024];
        size_t nbytes = read (fd2[0], buf, 1023);
        if (nbytes > 0)
        {
          buf[nbytes] = '\0';
          if (recvdata)
          {
            char *tmp = realloc(recvdata, recvdata_len + nbytes);
            if (!tmp)
            { 
              free(recvdata); 
              return NULL;
            }
            recvdata = tmp;
            memcpy(recvdata + recvdata_len, buf, nbytes);
            recvdata_len += nbytes;
          }
          else
          {
            recvdata = (char *) calloc(nbytes, sizeof(u_char));
            memcpy(recvdata, buf, nbytes);
            recvdata_len = nbytes;
          }
        }
        else
        {
          /* Nothing more to be read */
          finished = 1;
        }
      }
      else if (num == 0)
      {
        /* Timeout occurred */
        finished = 1;
      }
      else
      {
        /* Error */
        finished = 1;
      }
    }
    
    /* Null terminate */
    if (recvdata && recvdata_len > 0)
    {
      char *tmp = realloc (recvdata, recvdata_len+1);
      if (!tmp)
      {
        free (recvdata);
        return NULL;
      }
      recvdata = tmp;
      recvdata[recvdata_len] = '\0';
      recvdata_len++;     
    }
    
    /* Finished receive */
    return recvdata;
  }
  else
  {
    /* Child process, execute command */
    close(fd1[1]);
    close(fd2[0]);
    
    if (fd1[0] != STDIN_FILENO)
    {
      if (dup2(fd1[0], STDIN_FILENO) != STDIN_FILENO)
        fprintf (stdout, "dup2 error to stdin");
      close(fd1[0]);
    } 
    if (fd2[1] != STDOUT_FILENO)
    {
      if (dup2(fd2[1], STDOUT_FILENO) != STDOUT_FILENO)
        fprintf (stdout, "dup2 error to stdout");
      close(fd2[1]);
    } 
    
    num = execlp ("sh", "sh", "-c", command_str, NULL);
    if (num == -1)
    {
      fprintf (stdout, "execlp error");
    } 
    
    exit (1);
  }
} 
