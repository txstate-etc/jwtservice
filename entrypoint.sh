#!/bin/bash
DIR=/etc/apache2/sites-available
ORIGINAL=000-default.conf

export JWT_LDAP_PASSWORD="$(sed 's/[\\\\]/\\\\/g;s/["]/\\\"/g' <<< $JWT_LDAP_PASSWORD)"
export JWT_LDAP_DN="$(sed 's/[\\\\]/\\\\/g;s/["]/\\\"/g' <<< $JWT_LDAP_DN)"
export JWT_LDAP_URL="$(sed 's/[\\\\]/\\\\/g;s/["]/\\\"/g' <<< $JWT_LDAP_URL)"

perl -i -pe 's/\Q{{ldap_password}}\E/$ENV{JWT_LDAP_PASSWORD}/' $DIR/$ORIGINAL
perl -i -pe 's/\Q{{ldap_dn}}\E/$ENV{JWT_LDAP_DN}/' $DIR/$ORIGINAL
perl -i -pe 's/\Q{{ldap_url}}\E/$ENV{JWT_LDAP_URL}/' $DIR/$ORIGINAL

# unset LDAP_PASSWORD LDAP_DN LDAP_URL

exec "$@"
