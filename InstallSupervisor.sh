# !/usr/bin
# 
# This script install supervisor
#
# must run as sudo or root
#
# author: Niko Zhang <zhangweijie@wtsd.cn>
#
# date: 2019/02/22
#

SV_PATH=/usr/bin/supervisord

if [ -f ${SV_PATH} ];then
	echo "supervisor already install."
	exit 1;
fi

echo "yum install nss and curl first."
yum update -y nss curl

cd ~
echo "Starting download&install setuptools"
wget --no-check-certificate https://bootstrap.pypa.io/ez_setup.py -O - | sudo python
easy_install supervisor

if [ ! -f ${SV_PATH} ];then
	echo "supervisor install failed."
	exit 1;
fi

SV_DIR=/etc/supervisor/config.d

mkdir -p ${SV_DIR}

if [ ! -d ${SV_DIR} ];then
	echo "${SV_DIR} not found"
	exit 1;
fi

CONF_PATH=/etc/supervisor/supervisord.conf

if [ ! -f /tmp/supervisord.conf ];then
	echo_supervisord_conf > /tmp/supervisord.conf
fi

cp /tmp/supervisord.conf ${CONF_PATH}


if [ -f ${CONF_PATH} ];then
	echo "${CONF_PATH} genrate success."
else
	echo "please genrate config file manual."
	exit 1;
fi

cd /tmp/

if [ ! -f supervisor ];then
	wget https://github.com/nikozhangwj/install-supervisor-script/releases/download/1.0/supervisor
fi

mkdir /tmp/log
chown -R admin:admin /tmp/log
	
cp ./supervisor /etc/rc.d/init.d/supervisor
chmod 755 /etc/rc.d/init.d/supervisor
chkconfig supervisor on
/etc/init.d/supervisor start
# service supervisor status
rm -f /tmp/supervisor
rm -f /tmp/supervisord.conf
echo "Install finished, please use 'service supervisor start' check it out ."

