#!/usr/bin/env bash

# Path to dehydrated script and config (https://github.com/lukas2511/dehydrated)
DEHYDRATED=./dehydrated
DEHYDRATED_CONF=config

# Path to ALPN responder (https://github.com/lukas2511/dehydrated/blob/master/docs/tls-alpn.md)
ALPN_RESP=alpn-responder.py

WEBSERVER_STOP="service nginx stop"
WEBSERVER_START="service nginx start"

# Stop webserver in order to free up port 443 for TLS-ALPN responder
if lsof -Pi :443 -sTCP:LISTEN -t >/dev/null ; then
    echo "* Web server still running on port 443, stopping."
	$WEBSERVER_STOP
	sleep 5
fi

echo "* Starting ALPN responder."
python3 $ALPN_RESP &
# Get PID to kill it later on
ALPN_RESP_PID=$!

sleep 2

if lsof -Pi :443 -sTCP:LISTEN -t >/dev/null ; then
    echo "* ALPN responder seems to be running, performing ACME."
else
	echo "* ALPN responder is not running, check configuration."
	exit 1
fi

# Start ACME client
$DEHYDRATED -c -f $DEHYDRATED_CONF

echo "* Stopping ALPN responder."
kill $ALPN_RESP_PID

sleep 2

echo "* Restarting web server."
$WEBSERVER_START
