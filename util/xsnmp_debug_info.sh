echo "----[ df -m ]----------------------------------------"
df -m

echo "----[ raidutil list driveinfo ]----------------------"
raidutil list driveinfo

echo "----[ raidutil list status ]-------------------------"
raidutil list status

echo "----[ raidutil list raidsetinfo ]--------------------"
raidutil list raidsetinfo

echo "----[ raidutil list volumeinfo ]---------------------"
raidutil list volumeinfo

echo "----[ top -l 1 -n 0 ]--------------------------------"
top -l 1 -n 0

echo "----[ cvlabel -a -g -l -v ]--------------------------"
cvlabel -a -g -l -v

echo "----[ cvlabel -a -g -L -v ]--------------------------"
cvlabel -a -g -L -v

echo "----[ cvadmin -e 'fsmlist' ]-------------------------"
cvadmin -e 'fsmlist'

echo "----[ echo q | cvadmin ]-----------------------------"
echo "q" | cvadmin


