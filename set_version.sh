sed -i '' -e "s/^VERSION=.*$/VERSION=$1/g" configure.in

cd prefpane

agvtool bump -all
agvtool new-marketing-version "$1"

