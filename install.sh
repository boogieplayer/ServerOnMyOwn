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
PASSWORD_SQL = $(dd bs=30 count=1 if=/dev/urandom 2>/dev/null | base64 | tr +/ 0A)

