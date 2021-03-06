#!/bin/bash
# call "postfix stop" when exiting
trap "{ echo Stopping postfix; /usr/sbin/postfix stop; exit 0; }" EXIT

# start postfix
service postfix start
# avoid exiting
sleep infinity
