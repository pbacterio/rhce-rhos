#!/bin/bash

# Repos
yum install -y centos-release-openstack-newton

# Disable firewalld & NetworkManager
systemctl stop NetworkManager firewalld
systemctl disable NetworkManager firewalld

# Disable selinux
setenforce 0
sed -i 's/SELINUX=enforce/SELINUX=disabled/g' /etc/selinux/config
