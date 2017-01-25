#!/bin/sh -x

export PYLON_ROOT=/home/root/bcon_adapter/pylon5
export BCON_ADAPTER_LIB=/home/root/bcon_adapter/lib/libMityCAMBconAdapter.so
export BCON_ADAPTER_I2C_DEVICES="/dev/i2c-2:60"
export GENICAM_LOG_CONFIG_V3_0=${PYLON_ROOT}/share/pylon/log/config/DebugLoggingUnix.properties
export BXAPI_TRACE_LEVEL=30
export LD_LIBRARY_PATH=/home/root/bcon_adapter/pylon5/lib

case "$1" in
start)

	if ! pidof demo_app >/dev/null; then
		echo "Launching Demo"
#		cat /home/root/bcon_adapter/withdp.rbf > /dev/fpga0
#		sleep 2
		(nohup /home/root/bcon_adapter/bin/demo_app 2>&1 | logger) &
	else
		echo "Demo already running"
	fi
	;;

stop)
	if pidof demo_app >/dev/null; then
		killall -9 demo_app > /dev/null
	else
		echo "Demo Not Running"
	fi
	;;

restart)
	$0 stop
	sleep 1
	$0 start
	;;

*)
	echo "Usage: {start|stop|restart}"
	exit 1
	;;

esac
