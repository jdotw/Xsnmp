PREFIX=/Library/Xsnmp/XsnmpAgentExtension.app

CONFIGURE_PATHS="--prefix=$PREFIX --bindir=$PREFIX/Contents/MacOS --sbindir=$PREFIX/Contents/MacOS --libexecdir=$PREFIX/Contents/MacOS --datadir=$PREFIX/Resources --sysconfdir=/Library/Preferences/Xsnmp --sharedstatedir=$PREFIX/Resources --libdir=$PREFIX/Libraries --includedir=$PREFIX/Headers --infodir=$PREFIX/Resources --mandir=$PREFIX/Resources"

CC="/Developer/usr/bin/clang" \
CFLAGS="-O -gdwarf-2 -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch i386 -arch ppc" \
CXXFLAGS="-O -gdwarf-2 -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch i386 -arch ppc" \
LDFLAGS="-Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk" \
./configure $CONFIGURE_PATHS --disable-cpp --localstatedir='/Library/Application\ Support/Xsnmp' --disable-dependency-tracking

make

sudo make install

sudo rm -rf /Library/Xsnmp/XsnmpAgentExtension.app/Resources/man*
sudo rm -rf /Library/Xsnmp/XsnmpAgentExtension.app/share
sudo rm /Library/Xsnmp/XsnmpAgentExtension.app/Contents/MacOS/pcre*
sudo rm -rf /Library/Xsnmp/XsnmpAgentExtension.app/Libraries/pkgconfig

