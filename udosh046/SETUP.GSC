<GEMSETUP 0170>

<GLOBAL>
	APP_FILE="udoshell.app"
	APP_NAME="UDO-Shell"
	APP_VERS="0.46"
	APP_TYPE="PE"
	APP_FOLD="UDO-Shell"
	APP_LOCN="$DEST"
	APP_ICRS="USHELICN.RSC"
	APP_ICNR=0

	URL="http://www.norbert-hanz.de/"

	DEF_PATH="german\"

	ROOTPATH=FALSE
	SERIALIZE=FALSE
	CALCSIZE=TRUE
	ARCSSIZE=1724

	TEXT_LIC="licence.txt"

	HYP_FILE="udoshell.hyp"
	HYP_PAGE=""
</GLOBAL>

<LOCAL>
	RSRC="$LOCAL\udoshell.rsc"
	SIZE=30634
</LOCAL>

<ENTRY>
	TYPE=CHECKBOX
	NAME="-"
	TEXT="UDO-Shell installieren"
	BHLP="Hiermit wird die UDO-Shell inkl. Hypertext installiert."
	<FILE>
		TYPE=APPL
		TEXT="Programm zur UDO-Shell"
		<ITEM NAME="udoshell.app" PATH="udoshell.app" FCNT=1 >
		SETS=1
		SIZE=46846
	</FILE>
	<FILE>
		TYPE=APPL
		TEXT="Resource zur UDO-Shell"
		<ITEM NAME="udoshell.rsc" PATH="$LOCAL\udoshell.rsc" FCNT=1 >
		<ITEM NAME="udoshell.bgh" PATH="$LOCAL\udoshell.bgh" FCNT=1 >
		<ITEM NAME="udoshell.err" PATH="$LOCAL\udoshell.err" FCNT=1 >
		SETS=1
		SIZE=46846
	</FILE>
	<FILE>
		TYPE=HYP
		TEXT="Hypertext zur UDO-Shell"
		<ITEM NAME="udoshell.hyp" PATH="udoshell.hyp" FCNT=1 >
		<ITEM NAME="udoshell.ref" PATH="udoshell.ref" FCNT=1 >
		SETS=1
		SIZE=46846
	</FILE>
</ENTRY>
<ENTRY>
	TYPE=CHECKBOX
	NAME="-"
	TEXT="UDO-Shell konfigurieren"
	BHLP="Hiermit wird die Standard FORMAT.INF zur UDO-Shell kopiert und die UDO-Shell fÅr *.U-Dateien angemeldet."
	<FILE>
		TYPE=APPL
		TEXT="FORMAT.INF zur UDO-Shell"
		<ITEM NAME="format.inf" PATH="format.inf" FCNT=1 >
		SETS=1
		SIZE=46846
	</FILE>
	<FILE>
		TYPE=FTYP
		TEXT="Endung *.U anmelden (ab MagiC 6)"
		NAME="UDO-Shell config file"
		PATH="*.U"
		ICNR=1
	</FILE>
</ENTRY>


