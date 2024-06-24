#!/bin/sh

PRODUCT='NAKIVO Backup & Replication'


#URL="http://10.10.16.8/v11.0.0.84054.sh"
#SHA256="b2dd1a62a1415e1b699147b72b92c3a23972b84567fda6043aa4369ed29e2f83"

#URL="http://10.10.16.37:208/10.11.1.82517.sh"
#SHA256="bc9c91c2482322fff0bec1001630a39eec1982bbcf565cdebdb65a2e34092e9e"

URL="https://s3-teamcity.s3.us-west-1.amazonaws.com/NinjaCore/11.0.0-release%28trunktransporter%29/11.0.0.84355/build-artifacts/NAKIVO_Backup_Replication_v11.0.0.84355_Installer-TRIAL.sh?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEPL%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLXNvdXRoZWFzdC0yIkYwRAIgeNwcR6KwvlB0jXPlGMA%2FPhSU696uQsM1Gz%2BxzHjlX0ECIDbn6l1q2%2FEz4k7zr7hqaTHBpbhJrrRUr42rFtFUdMJKKo4DCJv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQBRoMMzIxMjk3MTg3NDA0IgxtBtaYdI99dWWorDIq4gK7%2FyV4gmJ68ZEud1PphwFwJmJo0cE3CjqwZk%2BdY%2Bau2FKrt54mEiD6T6eDgMggeaVIYeFvt1kudAm%2BmkbU6BKCrHGNzGHWlZuqyJTZkW2tuAWvTNPH3OtTjgsKzSVGn686UEbNoKF9i6GKFTR7xg4Npgb%2BNW%2FhsIoMItbgmsKmN%2FDxTANYrQWnUY1MFM6fKKnOALAx5%2B7j5lRmV43mMFhSejtxH%2FmgnBVz24Ugw9sq%2FBf2VkEBMnYbdCqR7wKkQ%2BRDpQLUguZibbhL1NUsfAazJz30Xvi1GYP5vt78T2vHcP2KLmoRwlGUV7axUbHRiYZcazO2a%2F8K95xMCYb8rmvfgIUEEAYvpIX%2FsZ0yLcBrg6f2MaPta4ss8IeQ0oJqCHgFDicXqUBKgZnDGO3QiFXvdAI%2B03g01dEFwT34ZMx6bUHMcJQqGeev6DyydUNvZmmz02wQRvZjS0JDlrws5vRdsGMwn6TjswY6tAI2V7ijPsiv%2Fv4VD2lYlYpufbaIxGwN0JaWn%2B%2BP7DO45tI4%2FERqoQGj%2FdGYlWL%2BeF4a9aEakxk9wiLo%2FckbTCu5aWssf%2BijF8GKFCcpUXu9E4Iw2m7CyPGR%2Fkqeb7QiXzyCWl7LCcQJ5OpB6cexF76%2BIyV1Ta%2B%2BJxKFO3BfvtW5345L8Mw7Fwn82KwME9aEOdZC9dHGV6tjOE4gLmrz%2Fixk91%2BzsCGFFpgEDNoQQEMNx2EkM84Wj8jdHHUuSL%2Fh6zV8KghZEDbG0mfH8EJkkly2yIV%2Bdp1oiIv%2BtOtZd5Wh9Fmyl8uhg9cf2h69au4W6inyJLcBcXhaaoFwb3SYbzsrYESHut1jnWbe7yXIrjT9EqJ53%2FEZBHpRBO2YA4G7JbmRxokBsmQKPKe9RXVQsz44%2BlsfeA%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240624T053548Z&X-Amz-SignedHeaders=host&X-Amz-Expires=7200&X-Amz-Credential=ASIAUVTWOAJGLEJAEGH2%2F20240624%2Fus-west-1%2Fs3%2Faws4_request&X-Amz-Signature=729971e22e69f5aa2191adbe0a384049e74eb1fd7c6964b6b106be57d74ed0fa"
SHA256="7b1b26acd20c5733697aee6f154d1ac2db8224fda40609af4e8a78d943afa776"

# URL="http://10.10.18.187:8080/NBR/linux/10.11/10.11.0.76317.sh"
# SHA256="91641349c343aca4c44015ace63af00209ddf51021d46dd18ecf91a2b008318d"

# URL="http://10.10.18.187:8080/NBR/linux/10.11/10.11.0.76141.sh"
# SHA256="db9b6fcd92fc3e1c24a185935047dccf4cc1994825d471ca92799fd1c7b8c65f"

#URL="http://10.10.18.187:8080/NBR/linux/10.9.0/10.9.0.75563.sh"
#SHA256="91528d51f0899ed53e3c7e6a38f37762d49fe8db54ed907f9ac00bdf31e01d00"

#URL="http://10.10.18.187:8080/NBR/linux/10.8.0/10.8.0.73174_GA.sh"
#SHA256="f4b3cc2466e44d4832b8df84dbc2b6da4f9de58abc229e8830d3d82d41ad3aba"

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
