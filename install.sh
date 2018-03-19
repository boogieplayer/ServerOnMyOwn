#!/bin/bash
##

# L.A.M.P Serveur installation
# DEBIAN 9
# SSH acces with ROOT account

clear

## CONSTANTES ##
# COLORS
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
END='\033[0m'

# GENERATE PASSWORD
PASSWORD_SQL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# SERVER NAME COMPLATE FQN
HOSTNAMEFQN=$(hostname -f)

# MISCANDELOUS
AUTEUR='boogieplayer'
VERSION='1.0'

# PLEASE MY EGO
echo -e """${CYAN}
 ____   ___   ___   ____ ___ _____ ____  _        _ __   _______ ____
| __ ) / _ \ / _ \ / ___|_ _| ____|  _ \| |      / \\ \ / / ____|  _ \
|  _ \| | | | | | | |  _ | ||  _| | |_) | |     / _ \\ V /|  _| | |_) |
| |_) | |_| | |_| | |_| || || |___|  __/| |___ / ___ \| | | |___|  _ <
|____/ \___/ \___/ \____|___|_____|_|   |_____/_/   \_\_| |_____|_| \_\


   ${YELLOW}Server On My Own - DEBIAN${END}
   ${GREEN}POWERED BY $AUTEUR${END}
   ${GREEN}Version : $VERSION${END}
   ${GREEN}Enjoy !${END}
"""

## PREPARATION
# ONLY ROOT
if [[ $EUID -ne 0 ]]; then
	echo -e "${RED}This script must be run as root${END}"
	exit 1
fi

# ONLY DEBIAN

# Debian Detection (Issue File)
if grep -iq "debian" /etc/issue; then
	# Set Distribution To Debian
	DISTRIBUTION='debian'
fi

# Debian Detection (LSB Release)
if command -v lsb_release &> /dev/null; then
	if lsb_release -a 2> /dev/null | grep -iq "debian"; then
		# Set Distribution To Debian
		DISTRIBUTION='debian'
	fi
fi

if [ $DISTRIBUTION != "debian" ]; then
	# Error Message
	echo -e "${RED}Your distribution is not a DEBIAN o.O${END}"
	# Exit If Not Supported
	exit 1
fi

# Check the sources list, and update it if wished
echo -e "${CYAN}this is your sources list${END}"
cat /etc/apt/sources.list

echo -e "${CYAN}DO want to update it?"
read -p "Yes or No [y/N]: " -e -i N option
echo -e "${END}"

if [ $option = "y" ] || [ $option = "Y" ]; then
	echo -e "${GREEN}Let's update sources list${END}"
	cp /etc/apt/sources.list /etc/apt/sources.list.old

	cat >/etc/apt/sources.list <<EOF
	deb http://ftp.us.debian.org/debian/ stretch main contrib non-free
	deb-src http://ftp.us.debian.org/debian/ stretch main contrib non-free

	deb http://security.debian.org/debian-security stretch/updates main contrib non-free
	deb-src http://security.debian.org/debian-security stretch/updates main contrib non-free
	EOF

else
	echo -e "${PURPLE}Update sources list is skipped${END}"

fi

# Update and Upgrade ?
echo -e "${CYAN}UPDATE and UPGRADE?"
read -p "Yes or No [Y/n]: " -e -i Y option
echo -e "${END}"

if [ $option = "y" ] || [ $option = "Y" ]; then
	echo -e "${GREEN}Let's update and upgrade${END}"

	apt update && apt upgrade -y
	apt-get autoremove

else
	echo -e "${PURPLE}UPDATE and UPGRADE is skipped${END}"

fi

## HERE WE GO
# Install the SSH server
echo -e "${CYAN}Install the SSH server?"
read -p "Yes or No [Y/n]: " -e -i Y option
echo -e "${END}"

if [ $option = "y" ] || [ $option = "Y" ]; then
	echo -e "${GREEN}Let's install the SSH serveur${END}"

	apt-get install -y ssh openssh-server

else
	echo -e "${PURPLE}Install SSH server is skipped${END}"

fi

# Install a shell text editor
# No war here, vim & nano are installed
# Peace
echo -e "${CYAN}Install text editor?"
read -p "Yes or No [Y/n]: " -e -i Y option
echo -e "${END}"

if [ $option = "y" ] || [ $option = "Y" ]; then
	echo -e "${GREEN}Let's install vim and nano${END}"

	apt-get install -y nano vim-nox

else
	echo -e "${PURPLE}Install text editor is skipped${END}"

fi

# Change the default Shell
echo -e "${CYAN}Change the default Shell?"
read -p "Yes or No [Y/n]: " -e -i Y option
echo -e "${END}"

if [ $option = "y" ] || [ $option = "Y" ]; then
	echo -e "${GREEN}Let's Change the default Shell"
	echo -e "${YELLOW}Use dash as the default system shell (/bin/sh)? -> ${GREEN}no${END}"

	dpkg-reconfigure dash

else
	echo -e "${PURPLE}Change the default Shell is skipped${END}"

fi

# Synchronize the System Clock
echo -e "${CYAN}Synchronize the System Clock and configure it?"
read -p "Yes or No [Y/n]: " -e -i Y option
echo -e "${END}"

if [ $option = "y" ] || [ $option = "Y" ]; then
	echo -e "${GREEN}Let's Synchronize the System Clock${END}"

	apt-get install -y ntp
	# reconfigure /etc/ntp.conf with french ntp server you can remove the two lines below
	cp /etc/ntp.conf /etc/ntp.conf.old
	sed -i 's|#server ntp.your-provider.example|#server ntp.your-provider.example\nserver 0.fr.pool.ntp.org prefer\nserver 1.fr.pool.ntp.org\nserver 2.fr.pool.ntp.org\nserver 3.fr.pool.ntp.org|g' /etc/ntp.conf
	#

else
	echo -e "${PURPLE}Synchronize the System Clock is skipped${END}"

fi

# Install Postfix, Dovecot, MySQL, rkhunter, and Binutils
echo -e "${CYAN}Install Postfix, Dovecot, MySQL, rkhunter, and Binutils?"
read -p "Yes or No [Y/n]: " -e -i Y option
echo -e "${END}"

if [ $option = "y" ] || [ $option = "Y" ]; then
	echo -e "${GREEN}Let's Install Postfix, Dovecot, MySQL, rkhunter, and Binutils"
	echo -e "${YELLOW}General type of mail configuration: -> ${GREEN}Internet Site${END}"
	echo -e "${YELLOW}System mail name: -> ${GREEN}$HOSTNAMEFQN${END}"

	apt-get install -y postfix postfix-mysql postfix-doc mariadb-client mariadb-server openssl getmail4 rkhunter binutils dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-sieve dovecot-lmtpd sudo

else
	echo -e "${PURPLE}Install Postfix, Dovecot, MySQL, rkhunter, and Binutils is skipped${END}"

fi

# Secure MariaDB
echo -e "${CYAN}Secure MariaDB?"
read -p "Yes or No [Y/n]: " -e -i Y option
echo -e "${END}"

if [ $option = "y" ] || [ $option = "Y" ]; then
	echo -e "${GREEN}Let's Secure MariaDB"
	echo -e "${YELLOW}Change the root password? [Y/n] -> ${GREEN}Y${END}"
	echo -e "${YELLOW}New password: -> ${GREEN}$PASSWORD_SQL${END}"
	echo -e "${YELLOW}Re-enter new password: -> ${GREEN}$PASSWORD_SQL${END}"
	echo -e "${YELLOW}Remove anonymous users? [Y/n] -> ${GREEN}Y${END}"
	echo -e "${YELLOW}Disallow root login remotely? [Y/n] -> ${GREEN}Y${END}"
	echo -e "${YELLOW}Remove test database and access to it? [Y/n] -> ${GREEN}Y${END}"
	echo -e "${YELLOW}Reload privilege tables now? [Y/n] -> ${GREEN}Y${END}"

	mysql_secure_installation

else
	echo -e "${PURPLE}Secure MariaDB is skipped${END}"

fi

# Reconfigure POSTFIX
echo -e "${CYAN}Reconfigure POSTFIX?"
read -p "Yes or No [Y/n]: " -e -i Y option
echo -e "${END}"

if [ $option = "y" ] || [ $option = "Y" ]; then
	echo -e "${GREEN}Let's Reconfigure POSTFIX${END}"

	cp /etc/postfix/master.cf /etc/postfix/master.cf.old
	sed -i 's|#submission inet n       -       -       -       -       smtpd|submission inet n       -       -       -       -       smtpd|' /etc/postfix/master.cf
	sed -i 's|#  -o syslog_name=postfix/submission|  -o syslog_name=postfix/submission|' /etc/postfix/master.cf
	sed -i 's|#  -o smtpd_tls_security_level=encrypt|  -o smtpd_tls_security_level=encrypt|' /etc/postfix/master.cf
	sed -i 's|#  -o smtpd_sasl_auth_enable=yes|  -o smtpd_sasl_auth_enable=yes|' /etc/postfix/master.cf
	sed -i 's|#  -o smtpd_client_restrictions=permit_sasl_authenticated,reject|  -o smtpd_client_restrictions=permit_sasl_authenticated,reject|' /etc/postfix/master.cf
	sed -i 's|#  -o smtpd_sasl_auth_enable=yes|  -o smtpd_sasl_auth_enable=yes|' /etc/postfix/master.cf
	sed -i 's|#  -o smtpd_sasl_auth_enable=yes|  -o smtpd_sasl_auth_enable=yes|' /etc/postfix/master.cf
	sed -i 's|#  -o smtpd_sasl_auth_enable=yes|  -o smtpd_sasl_auth_enable=yes|' /etc/postfix/master.cf
	sed -i 's|#smtps     inet  n       -       -       -       -       smtpd|smtps     inet  n       -       -       -       -       smtpd|' /etc/postfix/master.cf
	sed -i 's|#  -o syslog_name=postfix/smtps|  -o syslog_name=postfix/smtps|' /etc/postfix/master.cf
	sed -i 's|#  -o smtpd_tls_wrappermode=yes|  -o smtpd_tls_wrappermode=yes|' /etc/postfix/master.cf

	service postfix restart

else
	echo -e "${PURPLE}Reconfigure POSTFIX is skipped${END}"

fi

# Reconfigure MARIADB
echo -e "${CYAN}Reconfigure MariaDB?"
read -p "Yes or No [Y/n]: " -e -i Y option
echo -e "${END}"

if [ $option = "y" ] || [ $option = "Y" ]; then
	echo -e "${GREEN}Let's Reconfigure MariaDB${END}"

	cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.old
	sed -i 's|#bind-address           = 127.0.0.1|#bind-address           = 127.0.0.1\nsql-mode="NO_ENGINE_SUBSTITUTION"|g' /etc/postfix/master.cf
	# this allow to connect phpmyadmin as root
	echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root
	#
	cp /etc/mysql/debian.cnf /etc/mysql/debian.cnf.old
cat >/etc/mysql/debian.cnf <<EOF
# Automatically generated for Debian scripts. DO NOT TOUCH!
[client]
host = localhost
user = root
password = $PASSWORD_SQL
socket = /var/run/mysqld/mysqld.sock
[mysql_upgrade]
host = localhost
user = root
password = $PASSWORD_SQL
socket = /var/run/mysqld/mysqld.sock
basedir = /usr
EOF

	if grep -Fxq "mysql soft nofile 65535" /etc/security/limits.conf
		then
		echo
		else
		cp /etc/security/limits.conf /etc/security/limits.conf.old
cat >>/etc/security/limits.conf <<EOF
mysql soft nofile 65535
mysql hard nofile 65535
EOF
	fi

else
echo -e "${PURPLE}Reconfigure MariaDB is skipped${END}"

fi

## SCREEN UTILS VARIABLES

echo -e "SQL PASSWORD : $PASSWORD_SQL"
