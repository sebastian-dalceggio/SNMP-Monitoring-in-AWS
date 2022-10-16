#!/bin/sh -f

# Source: https://github.com/ahmednawazkhan/guides/blob/master/snmp/creating-custom-mib.md

PLACE=".1.3.6.1.4.1.12148.10"
REQ="$2"    # Requested OID
#
#  GET requests - check for valid instance
#
case "$REQ" in
    $PLACE.10.5.5.0|         \
    $PLACE.10.9.2.5.0|     \
    $PLACE.10.10.11.5.0|     \
    $PLACE.10.7.5.0)     RET=$REQ ;;
    *)              exit 0 ;;
esac

#
#  "Process" GET* requests - return hard-coded value
#

echo "$RET"
case "$REQ" in
  $PLACE.10.5.5.0)      echo "integer"; echo "48";             exit 0 ;;
  $PLACE.10.9.2.5.0)    echo "integer"; echo "60";             exit 0 ;;
  $PLACE.10.10.11.5.0)  echo "integer"; echo "600";            exit 0 ;;
  $PLACE.10.7.5.0)      echo "integer"; echo "25";         exit 0 ;;
  *)                    echo "string";  echo "ack... $REQ $REQ";  exit 0 ;;  # Should not happen
esac