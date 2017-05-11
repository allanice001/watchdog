DATE=`date +%Y-%m-%d--%H-%M-%S`
SERVICE_NAME="$1"
SERVICE_RESTARTNAME="$2"
EXTRA_PGREP_PARAMS="-x" #Extra parameters to pgrep, for example -x is good to do exact matching
MAIL_TO="$3" #Email to send restart notifications to
  
#path to pgrep command, for example /usr/bin/pgrep
PGREP="pgrep"
 
#Check if we have have a second param
if [ -z $SERVICE_RESTARTNAME ]
    then
        RESTART="/sbin/service ${SERVICE_NAME} restart" #No second param
    else
        RESTART="/sbin/service ${SERVICE_RESTARTNAME} restart" #Second param
    fi
 
pids=`$PGREP ${EXTRA_PGREP_PARAMS} ${SERVICE_NAME}`
 
#if we get no pids, service is not running
if [ "$pids" == "" ]
then
    $RESTART
    if [ -z $MAIL_TO ]
    then
        echo "$DATE : ${SERVICE_NAME} restarted - no email report configured."
    else
        echo "$DATE : Performing restart of ${SERVICE_NAME}" | mail -s "Service failure: ${SERVICE_NAME}" ${MAIL_TO}
    fi
else
    echo "$DATE : Service ${SERVICE_NAME} is still working!"
fi
