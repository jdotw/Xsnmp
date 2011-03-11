PREFIX=/Library/Xsnmp/XsnmpAgentExtension.app

CONFIGURE_PATHS="--prefix=$PREFIX --bindir=$PREFIX/Contents/MacOS --sbindir=$PREFIX/Contents/MacOS --libexecdir=$PREFIX/Contents/MacOS --datadir=$PREFIX/Resources --sysconfdir=/Library/Preferences/Xsnmp --sharedstatedir=$PREFIX/Resources --libdir=$PREFIX/Libraries --includedir=$PREFIX/Headers --infodir=$PREFIX/Resources --mandir=$PREFIX/Resources --disable-dependency-tracking"

CC="/Xcode3/usr/bin/gcc" \
PATH="/Xcode3/usr/bin:/Xcode3/usr/sbin:$PATH" \
CFLAGS="-O -gdwarf-2 -mmacosx-version-min=10.5 -isysroot /Xcode3/SDKs/MacOSX10.5.sdk -arch i386 -arch ppc" \
CXXFLAGS="-O -gdwarf-2 -mmacosx-version-min=10.5 -isysroot /Xcode3/SDKs/MacOSX10.5.sdk -arch i386 -arch ppc" \
LDFLAGS="-Wl,-syslibroot,/Xcode3/SDKs/MacOSX10.5.sdk" \
./configure $CONFIGURE_PATHS --disable-cpp --localstatedir='/Library/Application\ Support/Xsnmp' --disable-dependency-tracking

PATH="/Xcode3/usr/bin:/Xcode3/usr/sbin:$PATH" \
/Xcode3/usr/bin/make

sudo /Xcode3/usr/bin/make install

sudo rm -rf /Library/Xsnmp/XsnmpAgentExtension.app/Resources/man*
sudo rm -rf /Library/Xsnmp/XsnmpAgentExtension.app/share
sudo rm /Library/Xsnmp/XsnmpAgentExtension.app/Contents/MacOS/pcre*
sudo rm -rf /Library/Xsnmp/XsnmpAgentExtension.app/Libraries/pkgconfig

