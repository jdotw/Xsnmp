glibtoolize --force
aclocal
autoconf
automake -a

PREFIX=/Library/Xsnmp/XsnmpAgentExtension.app

CONFIGURE_PATHS="--prefix=$PREFIX --bindir=$PREFIX/Contents/MacOS --sbindir=$PREFIX/Contents/MacOS --libexecdir=$PREFIX/Contents/MacOS --datadir=$PREFIX/Resources --sysconfdir=/Library/Preferences/Xsnmp --sharedstatedir=$PREFIX/Resources --libdir=$PREFIX/Libraries --includedir=$PREFIX/Headers --infodir=$PREFIX/Resources --mandir=$PREFIX/Resources"

CC="/Developer/usr/bin/clang" \
./configure $CONFIGURE_PATHS --localstatedir='/Library/Application\ Support/Xsnmp'

