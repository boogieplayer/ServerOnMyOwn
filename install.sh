#!/bin/bash
##

## CONSTANTES ##
# COLORS

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
END='\033[0m'

# GENERATE PASSWORD
PASSWORD_SQL=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

