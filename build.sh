BASEDIR=$PWD

sudo rm -rf /Library/Xsnmp

cd ~/Source/External/pcre-8.02
$BASEDIR/util/pcre_build.sh
cd $BASEDIR

make distclean
./bootstrap.sh && make && sudo make install

sudo cp launchd/com.xsnmp.xsnmp-agentx.plist /Library/Xsnmp/XsnmpAgentExtension.app/Resources
sudo cp packaging/Info.plist /Library/Xsnmp/XsnmpAgentExtension.app/Contents 
