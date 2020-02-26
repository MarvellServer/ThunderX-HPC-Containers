#!/bin/bash

for fpath in /opt/gcc-9.2.0-glibc-2.30/bin/aarch64-linux-gnu-*
do
        fname=`basename $fpath`
        sname=`echo $fname | cut -d '-' -f 4-`

        case $sname in
                cc)
                ln -vsf $fpath /opt/gcc-9.2.0-glibc-2.30/bin/$sname
				rm -rf /usr/bin/$sname
				ln -sf /opt/gcc-9.2.0-glibc-2.30/bin/$sname /usr/bin$sname
                ;;
                ldd)
                ln -vf $fpath /opt/gcc-9.2.0-glibc-2.30/bin/cross-$sname
				rm -rf /usr/bin/$sname
				ln -sf /opt/gcc-9.2.0-glibc-2.30/bin/$sname /usr/bin$sname
                ;;
                *)
                ln -vf $fpath /opt/gcc-9.2.0-glibc-2.30/bin/$sname
				rm -rf /usr/bin/$sname
				ln -sf /opt/gcc-9.2.0-glibc-2.30/bin/$sname /usr/bin$sname
                ;;
        esac
done
