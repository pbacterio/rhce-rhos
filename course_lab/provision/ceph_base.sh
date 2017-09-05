#!/bin/bash

systemctl enable firewalld
systemctl start firewalld

firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=2003/tcp --permanent
firewall-cmd --zone=public --add-port=4505-4506/tcp --permanent
firewall-cmd --zone=public --add-port=6789/tcp --permanent
firewall-cmd --zone=public --add-port=6800-7300/tcp --permanent
firewall-cmd --reload

yum -y install ntp
systemctl enable ntpd
systemctl start ntpd

# Disable selinux
setenforce 0
sed -i 's/SELINUX=enforce/SELINUX=disabled/g' /etc/selinux/config


# Hostnames resolution
cat >> /etc/hosts << EOF
192.168.33.21 ceph1
192.168.33.21 ceph2
192.168.33.21 ceph2
EOF

# Ceph user
useradd ceph

cat << EOF > /etc/sudoers.d/ceph
ceph ALL = (root) NOPASSWD:ALL
EOF

mkdir /home/ceph/.ssh

cat << EOF > /home/ceph/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuu/Zi+8k484THtwilXdu+79ycPs8MX5k98Ko2H7PhAeuUmUWhVo7weastvx99Ucni9rvUXiSMFUdX6orAD+h+ErrLHrrVB5ZHfJXpyM3NDPpCxyVnZnf0r2oGueWCp3Qw3wqjuiUHTe60fVKuKcDnnntWVtIIaddsrN5Fd+0dthte0ccAkTaArpc5pH867ZTL5PFjmFSoefPgp/cDMUNf3SuqPZBayWrjmqVm4MzSfZDh+bWa5JiumST91xTCuX30Nl5HQDgUs1c3p0jmcRbIP2kVpaqg5dOwi3cDuwJLEBagk5BZ69/D4l3FNWZF0VMuR8fz+jF/Bo9OQVkkCJRj ceph@localhost.localdomain
EOF

cp /home/ceph/.ssh/id_rsa.pub /home/ceph/.ssh/authorized_keys

cat << EOF > /home/ceph/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEoAIBAAKCAQEArrv2YvvJOPOEx7cIpV3bvu/cnD7PDF+ZPfCqNh+z4QHrlJlF
oVaO8HmrLb8ffVHJ4va71F4kjBVHV+qKwA/ofhK6yx661QeWR3yV6cjNzQz6Qscl
Z2Z39K9qBrnlgqd0MN8Ko7olB03utH1SrinA5557VlbSCGnXbKzeRXftHbYbXtHH
AJE2gK6XOaR/Ou2Uy+TxY5hUqHnz4Kf3AzFDX90rqj2QWslq45qlZuDM0n2Q4fm1
muSYrpkk/dcUwrl99DZeR0A4FLNXN6dI5nEWyD9pFaWqoOXTsIt3A7sCSxAWoJOQ
Wevfw+JdxTVmRdFTLkfH8/oxfwaPTkFZJAiUYwIDAQABAoIBAFl6NzmI5gob6aq7
t9m2roigG8CHCU+0xKxLSV5d7acTbKeztUxhHuFV7KqIbH+oGlH3N0gQzXZOjzIe
EN85Rj0JKk5JdjMQp4wD6GDHS1vtgVog0K6acmMCULEREM5PIdjE3pXpBH0xE0Op
yWUWTIpPRal43CUizgYAn/HC79F+TrOmkpl2MGcHiZ7if3onYc++zz+gt4DvHdZr
B7clUJfIjmF0TQoHeo+RKMmEghpwHpbzx3WXYHSMi22W4Pxmho+P1IAaOC8uyQgW
fC1dNPg58/vsH4FHqzCDdCwUf/MY/xANNkWQ3HJTXdcoSPxPzpbJNJSlyyjok2Fk
+XlAo0ECgYEA3l5pv9xVF4xf4f2NtbC8WzzrNsDfeaFLYBXGO4BbpPiwScRFuo3D
7grsh56L6Bd17hQCcitV5uEiGbTscSmYKive2mlYd2K2mT/+Vq9L08Vn//rfpr1Z
dxGuaLB0PJYIg5cJpXFIfp71f/7X6e/KUqX0V6VAWK6WZ+DtdFs9RPcCgYEAySlA
vbppU4Sh0a82OkdRSzOOJkuzXrUdIi7F61aNjNmWpx2p205Mi/zmj9FiSpbi1Hxr
Gd4FhnHjqzcUZBtsHxJRA/V4gHx55xtc/5yPABYSkp4o2X8L3rl7EzX6tFFt9Tfy
OOCmiZRbv116OjX7sLj25inJp2TSjf6/Zd2mDPUCgYAu4oU1eMVQM767rXRFjMAK
FKwbXUtBH+r+lVi4jvXDsNOqmgGBtgZLmG4KojkpdFjfG8TwQYbZKTrBZM49heGZ
cqqILpICigOqCD4eFNPOEN8+r6ycQWwtmMLHO/0mERQ2epAEHACHAgkNNbRclLx5
9JeyKxuIFzeLK3elgt9GPQJ/I1wdBTy/Ru8JgtJJtfTTVWS6mAC2hu9PL7MJF1Uf
jKKy2K1eLi6VRgYugRlNLc9YEAHO0b01O2zJmE8WRoKLfuq5UvjTNcKrqvQkZMog
WOOIYD1s8M5kR8JS4A2dBBVMPs6WxWi33Xc2qWzFD3Ztx6K7w7mUuNgAKvWcr0tG
5QKBgDWli/Tg75GgoyoFcKKbopMtlqJU+Okz8Uw8LwLZ0NP3QgFJR/SXsP+j9ZZt
COgcVk3pxWO1T+4gh7XYU8jBX67XEyqQUgYVkT00ctAR+JfQAIUfZYHjdlpUbW3G
95DEbAe4upMY6EWX32JcYQCBzD97Y4xpM733EpzsiqdNkGCz
-----END RSA PRIVATE KEY-----
EOF

cat << EOF > /home/ceph/.ssh/config
UserKnownHostsFile /dev/null
StrictHostKeyChecking no
EOF

chmod 400 /home/ceph/.ssh/id_rsa /home/ceph/.ssh/config
chown -R ceph: /home/ceph/.ssh

su - ceph
mkdir ceph-config
