#!/tmp/busybox sh
#
# CyanogenMod Filesystem Converter for Samsung Infuse4G
#

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

test_mount()
{
	if ! /tmp/busybox mount -t ext4 /dev/block/$2 /$1; then
             umount_format $1 $2
	else 
           echo "Partition $1 is already EXT4."
           umount /$1
    fi
}

umount_format()
{
        echo "Unmounting $1 on $2"
        /tmp/busybox umount /$1
        if [ $(/tmp/busybox mount | grep "/dev/block/$2 on /$1 type" | wc -l) -eq "0" ]; then
                echo "Formatting $1 on $2 to EXT4"
                /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /$1 /dev/block/$2
                echo "Successfully converted $1 on $2"
        else
                echo "Cannot unmount $1 on $2"
                exit $?
        fi
}


# check each partition
test_mount system stl9
test_mount dbdata stl10
test_mount data mmcblk0p2
test_mount cache stl11 
/tmp/busybox mount -t ext4 /dev/block/stl11 /cache
exit 0
