#!/usr/bin/env bashio
# shellcheck shell=bash

############
# TIMEZONE #
############

if bashio::config.has_value 'TZ'; then
    TIMEZONE=$(bashio::config 'TZ')
    bashio::log.info "Setting timezone to $TIMEZONE"
    if [ -f /usr/share/zoneinfo/"$TIMEZONE" ]; then
        ln -snf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
        echo "$TIMEZONE" >/etc/timezone
    else
        bashio::log.fatal "$TIMEZONE not found, are you sure it is a valid timezone?"
    fi
fi

###################
# SSL CONFIG v1.0 #
###################

bashio::config.require.ssl
if bashio::config.true 'ssl'; then
    bashio::log.info "ssl enabled. If webui don't work, disable ssl or check your certificate paths"
    #set variables
    CERTFILE="-t /ssl/$(bashio::config 'certfile')"
    KEYFILE="-k /ssl/$(bashio::config 'keyfile')"
else
    CERTFILE=""
    KEYFILE=""
fi

#################
# NGINX SETTING #
#################

#declare port
#declare certfile
declare ingress_interface
declare ingress_port
#declare keyfile

FB_BASEURL=$(bashio::addon.ingress_entry)
export FB_BASEURL

declare ADDON_PROTOCOL=http
# Generate Ingress configuration
if bashio::config.true 'ssl'; then
    ADDON_PROTOCOL=https
fi

#port=$(bashio::addon.port 80)
ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
echo ${ingress_port}
echo ${ingress_interface}

sed -i "s|%%protocol%%|${ADDON_PROTOCOL}|g" /etc/nginx/servers/ingress.conf
sed -i "s|%%port%%|${ingress_port}|g" /etc/nginx/servers/ingress.conf
sed -i "s|%%interface%%|${ingress_interface}|g" /etc/nginx/servers/ingress.conf
sed -i "s|%%subpath%%|${FB_BASEURL}/|g" /etc/nginx/servers/ingress.conf
sed -i "s|%%subpath%%|${FB_BASEURL}/|g" /usr/src/app/public/index.html
mkdir -p /var/log/nginx && touch /var/log/nginx/error.log

#bashio::log.info "Started !"
#exec nginx
