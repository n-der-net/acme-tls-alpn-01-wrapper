# acme-tls-alpn-01-wrapper
A wrapper for performing the ACME protocol with tls-alpn-01 .

This simple bash script uses the ACME client Dehydrated and a suitable ALPN responder (see https://github.com/lukas2511/dehydrated, kudos to lukas2511).

The script requires the paths to Dehydrated executable ($DEHYDRATED) and config ($DEHYDRATED_CONF) to be set properly, as well as the ALPN responder script ($ALPN_RESP).

Set variables $WEBSERVER_STOP/$WEBSERVER_START according to your server setup.

This script can be added to crontab for running it on a regular basis, e. g. once a month at midnight:

```0 0 1 * * /path/to/acme-alpn-wrap.sh"```
