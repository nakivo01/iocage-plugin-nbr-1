#!/bin/sh

PRODUCT='NAKIVO Backup & Replication'
URL="http://10.10.18.187:8080/NBR/linux/10.9.0/10.9.0.71865.sh"
SHA256="d05667f661ad6dbcb8a38b8974fcb9ba0fa2b5fe3bd86e4d98b831c145fe03cd"

#URL="http://10.10.18.187:8080/NBR/linux/10.9.0/10.9.0.71941.sh"
#SHA256="2dfa670a9ba5def152172887ec514c5cf0e5e01b1a10afd22ecfed42c2d3cf3a"
#URL="http://10.10.18.187:8080/NBR/linux/10.8.0/10.8.0.67309.sh"
#SHA256="1f40ef6f37163a1e53ddd631194086c9c39d39425e09e540a053f1ab27eadf91"

PRODUCT_ROOT="/usr/local/nakivo"
INSTALL="inst.sh"

curl --fail --tlsv1.2 -o $INSTALL $URL
if [ $? -ne 0 -o ! -e $INSTALL ]; then
    echo "ERROR: Failed to get $PRODUCT installer"
    rm $INSTALL >/dev/null 2>&1
    exit 1
fi

CHECKSUM=`sha256 -q $INSTALL`
if [ "$SHA256" != "$CHECKSUM" ]; then
    echo "ERROR: Incorrect $PRODUCT installer checksum"
    rm $INSTALL >/dev/null 2>&1
    exit 2
fi

sh ./$INSTALL -f -y -i "$PRODUCT_ROOT" --eula-accept --extract 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: $PRODUCT install failed"
    rm $INSTALL >/dev/null 2>&1
    exit 3
fi
rm $INSTALL >/dev/null 2>&1

#disable default HTTP ports redirect
SVC_PATH="$PRODUCT_ROOT/director"
awk 'BEGIN{A=0} /port="80/{A=1} {if (A==0) print $0} />/{A=0}' $SVC_PATH/tomcat/conf/server-linux.xml >$SVC_PATH/tomcat/conf/server-linux.xml_ 2>/dev/null
mv $SVC_PATH/tomcat/conf/server-linux.xml_ $SVC_PATH/tomcat/conf/server-linux.xml >/dev/null 2>&1

#enforce EULA
PROFILE=`ls "$SVC_PATH/userdata/"*.profile 2>/dev/null | head -1`
if [ "x$PROFILE" != "x" ]; then
    sed -e 's@"system.licensing.eula.must.agree": false@"system.licensing.eula.must.agree": true@' "$PROFILE" >"${PROFILE}_" 2>/dev/null
    mv "${PROFILE}_" "$PROFILE" >/dev/null 2>&1
fi

service nkv_dirsvc start >/dev/null 2>&1
