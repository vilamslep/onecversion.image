#!/bin/bash

API_ENV="api/env"
EP_ENV="raw/env"
PROC_ENV="process/env"

pghost=pgsql
pgport=5432
pguser=onecversion
pgpassword=onecversion
pgdatabase=onecversion

kafkahost=kafka
kafkaport=9092
kafkatopic=raw
kafkagroup=process

#API
echo "'api' service's env initialization"
echo "Enter 'api' host: "
read apihost
echo "Enter 'api' port: "
read apiport
#ENTRYPOINT
echo "'entrypoint' service env initizalization"
echo "Enter 'entrypoint' port: "
read epport
echo "Enter 'entrypoint' main method: "
read epmethod

#PROCESS
echo "Enter 'process' host: "
read gvhost
echo "Enter 'process' port: "
read gvport
echo "Enter 'process' URL: "
read gvurl
echo "Enter 'process' user: "
read gvuser
echo "Enter 'process' password: "
read gvpassword

touch $API_ENV
echo "APIHOST="$apihost > $API_ENV
echo "APIPORT="$apiport >> $API_ENV
echo "PGHOST="$pghost >> $API_ENV
echo "PGPORT="$pgport >> $API_ENV
echo "PGUSER="$pguser >> $API_ENV
echo "PGPASSWORD="$pgpassword >> $API_ENV
echo "PGDBNAME="$pgdatabase >> $API_ENV


touch $PROC_ENV
echo "PGHOST="$pghost > $PROC_ENV
echo "PGPORT="$pgport >> $PROC_ENV
echo "PGUSER="$pguser >> $PROC_ENV
echo "PGPASSWORD="$pgpassword >> $PROC_ENV
echo "PGDBNAME="$pgdatabase >> $PROC_ENV

echo "KAFKAHOST="$kafkahost >> $PROC_ENV
echo "KAFKAPORT="$kafkaport >> $PROC_ENV
echo "KAFKATOPIC="$kafkatopic >> $PROC_ENV
echo "KAFKAGROUP="$kafkagroup >> $PROC_ENV

echo "PROCHOST="$gvhost >> $PROC_ENV
echo "PROCPORT="$gvport >> $PROC_ENV
echo "PROCURL="$gvurl >> $PROC_ENV
echo "PROCUSER="$gvuser >> $PROC_ENV
echo "PROCPASSWORD="$gvpassword >> $PROC_ENV

touch $EP_ENV
echo "KAFKAHOST="$kafkahost > $EP_ENV
echo "KAFKAPORT="$kafkaport >> $EP_ENV
echo "KAFKATOPIC="$kafkatopic >> $EP_ENV
echo "RAWPORT="$epport >> $EP_ENV 
echo "RAWRESOURSE="$epmethod >> $EP_ENV 
