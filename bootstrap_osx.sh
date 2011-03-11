glibtoolize --force
aclocal
autoconf
automake -a

PREFIX=/Library/Xsnmp/XsnmpAgentExtension.app

CONFIGURE_PATHS="--prefix=$PREFIX --bindir=$PREFIX/Contents/MacOS --sbindir=$PREFIX/Contents/MacOS --libexecdir=$PREFIX/Contents/MacOS --datadir=$PREFIX/Resources --sysconfdir=/Library/Preferences/Xsnmp --sharedstatedir=$PREFIX/Resources --libdir=$PREFIX/Libraries --includedir=$PREFIX/Headers --infodir=$PREFIX/Resources --mandir=$PREFIX/Resources --disable-dependency-tracking"

PATH="/Xcode3/usr/bin:/Xcode3/usr/sbin:$PATH" \
CC="/Xcode3/usr/bin/gcc" \
CFLAGS="-O -gdwarf-2 -I/Library/Xsnmp/XsnmpAgentExtension.app/Headers -DHOST_MACOSX -W -Wall -Wno-unused-parameter -Werror -mmacosx-version-min=10.5 -isysroot /Xcode3/SDKs/MacOSX10.5.sdk -arch i386 -arch ppc" \
LDFLAGS="-Wl,-syslibroot,/Xcode3/SDKs/MacOSX10.5.sdk -L/Library/Xsnmp/XsnmpAgentExtension.app/Libraries" \
./configure $CONFIGURE_PATHS --localstatedir='/Library/Application\ Support/Xsnmp'

