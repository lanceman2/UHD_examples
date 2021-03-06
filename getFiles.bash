#!/bin/bash

################### CONFIGURE ###############################
UHD_TAG=v3.14.0.0

# if not set it will not use the sha512 sum and tell you it
SHA512SUM=

SHA512SUM=05918bad6345ba4c0f\
39a9b81d2a6d2a11634a586df71e\
74c0be5ee03928e84ee0e96c71eb\
13c078c63032ea33c7604e3d1bc4\
e315508d2b72b7f990040dac09
############################################################


set -ex
set -o pipefail


# This gets a tarball from github.

#Usage: GetSrcFromGithub user package tag tarname [sha512]

function GetSrcFromGithub()
{
    [ -n "$4" ] || exit 1

    local path="$1/$2"
    local tag="$3"
    local tarfile=$4.tar.gz

    if [ -e "$tarfile" ] && [ -n "$5" ] ; then
        if ! echo "$5  $tarfile" | sha512sum -c ; then
            set +x
            echo "You have \"$tarfile\" with a bad sha512 sum"
            exit 1
        else
            # success
            set +x
            echo "We have the tar file \"$tarfile\" already"
            exit 0
        fi
    fi

    # This gets a tarball file from github for the package
    wget -O $tarfile https://github.com/$path/tarball/$tag

    if [ -n "$5" ] ; then
        set +e
        # Check that the file has a good SHA512 sum
        if ! echo "$5  $tarfile" | sha512sum -c ; then
            echo "You have $tarfile with a bad sha512 sum"
            exit 1 # FAIL
        fi
    else
        # Just report the SHA512 sum
        sha512sum $tarfile
    fi
    # Success
}


GetSrcFromGithub EttusResearch uhd $UHD_TAG uhd $SHA512SUM

tar -xvf uhd.tar.gz\
 --wildcards --no-anchored\
 'host/examples/*.cpp'\
 'host/examples/*.hpp'\
 'host/examples/*.c'\
 --strip-components=3

