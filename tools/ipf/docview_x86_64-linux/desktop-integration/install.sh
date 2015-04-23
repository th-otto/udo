#!/bin/bash

POSTINST=`echo $0 | grep -o postinst`

USER_ID=`id -u`
if [ $USER_ID -ne 0 ]
then
	echo "$0 must be run as a root user."
	exit 1
fi


if [ "$POSTINST" != "postinst" ]
then
	#We are not in a debian package, install executables.
	echo "Installing fpGUI Docview in /usr/local"
	mkdir -p /usr/local/share/docview
	cp docview-inf.* /usr/local/share/docview/
	cp fpgui-docview.* /usr/local/share/docview/
	cp ../docview /usr/local/share/docview/
	cp ../docview.inf /usr/local/share/docview/
	ln -s /usr/local/share/docview/docview /usr/local/bin/docview
fi

#Detect if we have the xdg tools available.
XDG=`which xdg-open 2> /dev/null`
XDG_MIME=`which xdg-mime 2> /dev/null`
XDG_ICON=`which xdg-icon-resource 2> /dev/null`
XDG_DESKTOP=`which xdg-desktop-menu 2> /dev/null`

if [[ "$XDG" == "" || "$XDG_MIME" == "" || "$XDG_ICON" == "" || "$XDG_DESKTOP" == "" ]]
then
	echo "freedesktop.org XdgUtils not available:"
	echo "Not registering MIME-types or desktop shortcut."
	echo "To run fpGUI Docview please execute: docview"
	exit 0
else
	if [ "$POSTINST" != "postinst" ]
	then
		echo "freedesktop.org tools present: Registering MIME-types and desktop shortcut."
	fi
fi

#Register application
APP_DIR="/usr/local/share/docview"
MIME_NAME="application-docview-inf"
ICON_FILE="$APP_DIR/fpgui-docview.png"
INF_ICON_FILE="$APP_DIR/docview-inf.png"
XML_FILE="$APP_DIR/docview-inf.xml"
DESKTOP_FILE="$APP_DIR/fpgui-docview.desktop"


#Register mime type for Docview
xdg-mime install $XML_FILE

#Install icon after mimetype is installed.
xdg-icon-resource install --mode system --size 32 --context mimetypes $INF_ICON_FILE $MIME_NAME
xdg-icon-resource install --mode system --size 48 --context mimetypes $INF_ICON_FILE $MIME_NAME
xdg-icon-resource install --mode system --size 32 $ICON_FILE
xdg-icon-resource install --mode system --size 48 $ICON_FILE
xdg-icon-resource forceupdate


#Install Docview in the desktop menu (mandatory for mime type association)
xdg-desktop-menu install $DESKTOP_FILE
xdg-desktop-menu forceupdate
