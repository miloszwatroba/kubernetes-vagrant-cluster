#!/bin/bash -e

export NODENAME=`hostname -s`
export IPADDR=`ifconfig eth1 | grep -i Mask | awk '{print $2}'| cut -f2 -d:`
