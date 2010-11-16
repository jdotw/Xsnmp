libtoolize --force
aclocal
autoconf
automake -a

PREFIX=/usr/local

CONFIGURE_PATHS="--prefix=$PREFIX"

CFLAGS="`net-snmp-config --cflags` `pcre-config --cflags` -DHOST_LINUX" \
LDFLAGS="`net-snmp-config --libs` `pcre-config --libs`" \
./configure $CONFIGURE_PATHS 

