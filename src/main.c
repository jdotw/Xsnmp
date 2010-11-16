/* generated from net-snmp-config */
#include <net-snmp/net-snmp-config.h>
#ifdef HAVE_SIGNAL
#include <signal.h>
#endif /* HAVE_SIGNAL */
#include <net-snmp/net-snmp-includes.h>
#include <net-snmp/agent/net-snmp-agent-includes.h>
  #include "xsnmpInternal.h"
  #include "fsTable.h"
  #include "xsanVolumeTable.h"
  #include "xsanStripeGroupTable.h"
  #include "xsanNodeTable.h"
  #include "xsanAffinityTable.h"
  #include "ram.h"
const char *app_name = "yeehaw";

extern int netsnmp_running;

#ifdef __GNUC__
#define UNUSED __attribute__((unused))
#else
#define UNUSED
#endif

RETSIGTYPE
stop_server(UNUSED int a) {
    netsnmp_running = 0;
}

static int static_xsan_debug = 0;
int xsan_debug() 
{ return static_xsan_debug; }

static int static_xsan_perflog = 0;
int xsan_perflog() 
{ return static_xsan_perflog; }

static void
usage(const char *prog)
{
    fprintf(stderr,
            "USAGE: %s [OPTIONS]\n"
            "\n"
            "OPTIONS:\n", prog);

    fprintf(stderr,
            "  -d\t\t\tdump all traffic\n"
            "  -D TOKEN[,...]\tturn on debugging output for the specified "
            "TOKENs\n"
            "\t\t\t   (ALL gives extremely verbose debugging output)\n"
            "  -f\t\t\tDo not fork() from the calling shell.\n"
            "  -h\t\t\tdisplay this help message\n"
            "  -H\t\t\tdisplay a list of configuration file directives\n"
            "  -L LOGOPTS\t\tToggle various defaults controlling logging:\n");
    snmp_log_options_usage("\t\t\t  ", stderr);
#ifndef DISABLE_MIB_LOADING
    fprintf(stderr,
            "  -m MIB[:...]\t\tload given list of MIBs (ALL loads "
            "everything)\n"
            "  -M DIR[:...]\t\tlook in given list of directories for MIBs\n");
#endif /* DISABLE_MIB_LOADING */
#ifndef DISABLE_MIB_LOADING
    fprintf(stderr,
            "  -P MIBOPTS\t\tToggle various defaults controlling mib "
            "parsing:\n");
    snmp_mib_toggle_options_usage("\t\t\t  ", stderr);
#endif /* DISABLE_MIB_LOADING */
    fprintf(stderr,
            "  -v\t\t\tdisplay package version number\n"
            "  -x TRANSPORT\tconnect to master agent using TRANSPORT\n"
            "  -p\t\t\tenable Xsnmp performance logging\n");
    exit(1);
}

static void
version(void)
{
    fprintf(stderr, "NET-SNMP version: %s\n", netsnmp_get_version());
    exit(0);
}

int
main (int argc, char **argv)
{
  int arg;
  char* cp = NULL;
  int dont_fork = 0, do_help = 0;

  while ((arg = getopt(argc, argv, "dD:fhHL:Xp"
#ifndef DISABLE_MIB_LOADING
                       "m:M:"
#endif /* DISABLE_MIB_LOADING */
                       "n:"
#ifndef DISABLE_MIB_LOADING
                       "P:"
#endif /* DISABLE_MIB_LOADING */
                       "vx:")) != EOF) {
    switch (arg) {
    case 'd':
      netsnmp_ds_set_boolean(NETSNMP_DS_LIBRARY_ID,
                             NETSNMP_DS_LIB_DUMP_PACKET, 1);
      break;

    case 'D':
      debug_register_tokens(optarg);
      snmp_set_do_debugging(1);
      break;

    case 'f':
      dont_fork = 1;
      break;

    case 'X':
      static_xsan_debug = 1;
      break;

    case 'p':
      static_xsan_perflog = 1;
      break;

    case 'h':
      usage(argv[0]);
      break;

    case 'H':
      do_help = 1;
      break;

    case 'L':
      if (snmp_log_options(optarg, argc, argv) < 0) {
        exit(1);
      }
      break;

#ifndef DISABLE_MIB_LOADING
    case 'm':
      if (optarg != NULL) {
        setenv("MIBS", optarg, 1);
      } else {
        usage(argv[0]);
      }
      break;

    case 'M':
      if (optarg != NULL) {
        setenv("MIBDIRS", optarg, 1);
      } else {
        usage(argv[0]);
      }
      break;
#endif /* DISABLE_MIB_LOADING */

    case 'n':
      if (optarg != NULL) {
        app_name = optarg;
        netsnmp_ds_set_string(NETSNMP_DS_LIBRARY_ID,
                              NETSNMP_DS_LIB_APPTYPE, app_name);
      } else {
        usage(argv[0]);
      }
      break;

#ifndef DISABLE_MIB_LOADING
    case 'P':
      cp = snmp_mib_toggle_options(optarg);
      if (cp != NULL) {
        fprintf(stderr, "Unknown parser option to -P: %c.\n", *cp);
        usage(argv[0]);
      }
      break;
#endif /* DISABLE_MIB_LOADING */

    case 'v':
      version();
      break;

    case 'x':
      if (optarg != NULL) {
        netsnmp_ds_set_string(NETSNMP_DS_APPLICATION_ID,
                              NETSNMP_DS_AGENT_X_SOCKET, optarg);
      } else {
        usage(argv[0]);
      }
      break;

    default:
      fprintf(stderr, "invalid option: -%c\n", arg);
      usage(argv[0]);
      break;
    }
  }

  if (do_help) {
    netsnmp_ds_set_boolean(NETSNMP_DS_APPLICATION_ID,
                           NETSNMP_DS_AGENT_NO_ROOT_ACCESS, 1);
  } else {
    /* we are a subagent */
    netsnmp_ds_set_boolean(NETSNMP_DS_APPLICATION_ID,
                           NETSNMP_DS_AGENT_ROLE, 1);

    if (!dont_fork) {
      if (netsnmp_daemonize(1, snmp_stderrlog_status()) != 0)
        exit(1);
    }

    /* initialize tcpip, if necessary */
    SOCK_STARTUP;
  }

  /* initialize the agent library */
  init_agent(app_name);

  /* initialize your mib code here */
  init_xsnmpInternal();

  /* File Systems (Linux and Mac) */
  init_fsTable();

  /* Xsan (Linux and Mac) */
  init_xsanVolumeTable();
  init_xsanStripeGroupTable();
  init_xsanNodeTable();
  init_xsanAffinityTable();

  /* Ram (Mac Only) */
#ifdef HOST_MACOSX
  init_ram();
#endif

  /* yeehaw will be used to read yeehaw.conf files. */
  init_snmp("yeehaw");

  if (do_help) {
    fprintf(stderr, "Configuration directives understood:\n");
    read_config_print_usage("  ");
    exit(0);
  }

  /* In case we received a request to stop (kill -TERM or kill -INT) */
  netsnmp_running = 1;
#ifdef SIGTERM
  signal(SIGTERM, stop_server);
#endif
#ifdef SIGINT
  signal(SIGINT, stop_server);
#endif

  /* main loop here... */
  while(netsnmp_running) {
    agent_check_and_process(1);
  }

  /* at shutdown time */
  snmp_shutdown(app_name);
  SOCK_CLEANUP;
  exit(0);
}

