#!/bin/bash

PRERM=`echo $0 | grep -o prerm`

USER_ID=`id -u`
if [ $USER_ID -ne 0 ]
then
	echo "$0 must be run as a root user."
	exit 1
fi

APP_DIR="/usr/local/share/docview"
MIME_NAME="application-docview-inf"
ICON_NAME="fpgui-docview"
ICON_FILE="$APP_DIR/fpgui-docview.png"
INF_ICON_NAME="docview-inf"
INF_ICON_FILE="$APP_DIR/docview-inf.png"
XML_FILE="$APP_DIR/docview-inf.xml"
DESKTOP_FILE="$APP_DIR/fpgui-docview.desktop"


echo "Removing application associations."

xdg-desktop-menu uninstall $DESKTOP_FILE

xdg-icon-resource uninstall --mode system --size 32 $ICON_NAME
xdg-icon-resource uninstall --mode system --size 48 $ICON_NAME
xdg-icon-resource uninstall --context mimetypes --mode system --size 32 $MIME_NAME
xdg-icon-resource uninstall --context mimetypes --mode system --size 48 $MIME_NAME


xdg-mime uninstall $XML_FILE

if [ "$PRERM" != "prerm" ]
then
	echo "Removing Docview files."
	#We are not in a debian package, remove files.
	rm -f /usr/local/bin/docview
	rm -Rf /usr/local/share/docview
fi
