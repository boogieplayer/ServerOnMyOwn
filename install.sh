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
CYAN='\033[0;36m'
END='\033[0m'

# GENERATE PASSWORD
PASSWORD_SQL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# MISCANDELOUS
AUTEUR='boogieplayer'
VERSION='1.0'

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

## HERE WE GO


