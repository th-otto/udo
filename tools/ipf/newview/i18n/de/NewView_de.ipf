:userdoc.
:docprof toc=123456.
:title.NewView-Hilfe
.* ************************************************************
.* Subject: Help for NewView
.* Version:
.* Copyright: Copyright 2004 Aaron Lawrence
.* Copyright: Copyright 2006-2007 Ronald Brill
.* Author: Aaron Lawrence
.* Translator: Christian Hennecke
.* Translator: Ronald Brill
.* ************************************************************
.*
.*
.* ************************************************************
.* Introduction
.* ************************************************************
:h1 res=30000 id='Introduction'.Einf&ue.hrung
:i1 id=30001.Support
:p.
:artwork runin name='..\images\NewView.bmp'.
 :hp2.Willkommen bei NewView!:ehp2.
:p.
:p.NewView ist ein Programm zum Lesen von OS&slash.2- &lpar.oder eComStation-&rpar.
Hilfedateien&per.
:p.:link reftype=hd refid='Support'.Support und Lizenzbedingungen:elink.
:p.:link reftype=hd refid='Using'.NewView verwenden:elink.
:p.:hp1.Soll diese Datei nicht mehr angezeigt werden&comma. wenn NewView ohne Angabe
einer Hilfedatei ge&oe.ffnet wird&comma. rufen Sie die Indexzunge Werkzeuge &endash.
Optionen &endash. Allgemeines auf&per.:ehp1.
:p.:hp2.Geschichte:ehp2.
:p.NewView ersetzt das originale, mit OS&slash.2 ausgelieferte Programm von IBM&per.
:p.Es bietet Verbesserungen vieler Aspekte von View&comma. besitzt eine moderne&comma. einfach
zu bedienende Oberfl&ae.che&comma. mehr Optionen und neue Funktionen&comma. die View ganz
einfach nicht besessen hat&per.
:p.
.* ************************************************************
.* Support and Licensing
.* ************************************************************
:h2 res=1 id='Support'.Support und Lizenzbedingungen
:i1 id=30002.Lizenz
:i2 refid=30001.Support und Lizenzbedingungen
:i2 refid=30002.EinfÅhrung
:i1 id=30003.Fehler
:i1 id=30004.Quellcode
:p.:hp2.Support und Lizenzbedingungen:ehp2.
:p.
:p.NewView ist Copyright 1999-2006 Aaron Lawrence&per. Desweiteren unterliegt NewView
der GNU Public License, d&per.h&per. Sie haben das Recht, sich den Quellcode
zu besorgen&per.
:p.Seit 2006 pflegt Ronald Brill dieses Produkt&per.
.br
NewView ist eine Netlabs Projekts&per.
:p.Technische Details entnehmen Sie bitte der Datei Readme&per.txt&per.
:p.In der Datei Changes&per.txt finden Sie die Entwicklungsgeschichte von NewView aufgezeichnet&per.
:p.Wenn Sie NewView n&ue.tzlich finden, senden Sie mir eine E-Mail und&slash.oder spenden Sie,
um die weitere Entwicklung zu unterst&ue.tzen&per. Es w&ae.re sch&oe.n, von Ihnen zu h&oe.ren&xclm.
:ul.
:li.Vorschl&ae.ge, Komplimente oder Fehlerberichte senden Sie bitte an http&colon.&slash.&slash.svn&per.netlabs&per.org&slash.newview
:li.öbersetzen Sie NewView in Ihre Sprache&per.
:li.Eine Spende f&ue.r Netlabs http&colon.&slash.&slash.www&per.mensys&per.nl
:eul.
:p.:hp2.Melden von Fehlern:ehp2.
:p.Wenn Sie einen Absturz oder ein anderes Problem melden wollen, geben Sie bitte
m&oe.glichst genau an, welche Dateien verwendet wurden, was Sie getan haben
usw&per. Falls vorhanden, legen Sie BITTE die Datei newview&per.log bei&per. Die
Protokolldatei befindet sich ENTWEDER
.br
 &endash. im selben Verzeichnis wie NewView selbst oder
.br
 &endash. im Ordner, der durch die Umgebungsvariable LOGFILES bestimmt wird
&lpar.typischerweise bei eCS 1&per.1+&rpar.
.br
Taucht das Problem im Zusammenhang mit einer bestimmten Hilfedatei auf, dann
schicken Sie sie mir bitte zu, es sei denn, Sie w&ae.re sehr gro&Beta.
&lpar.gr&oe.&Beta.er als 1MB&rpar.&per.
:p.Aus der Datei newview&per.log kann ich die meisten folgenden Informationen entnehmen,
aber es w&ae.re von Vorteil, wenn Sie sie zur öberpr&ue.fung dennoch
ang&ae.ben&colon.
:ul.
:li.NewView-Version &lpar.Hilfe - Produktinformation&rpar.
:li.Die Dateinamen der Hilfedateien&per.
:eul.
:p.Ein Bildschirmphoto kann n&ue.tzlich sein, wenn es sich bei dem Problem um eine
falsche oder verzerrte Anzeige handelt&per.
:p.:hp2.Warum funktioniert meine Hilfedatei nicht richtig?:ehp2.
:p.
Einige der seltener verwendeten Funktionen Views wurden noch nicht implementiert&per.
Der Grund daf&ue.r ist entweder, da&Beta. ich noch nicht dazu gekommen bin, oder
da&Beta. sie den Aufwand einfach nicht wert sind&per. Dazu geh&oe.ren beispielsweise
Metadateien, Registersynonyme, der gesamte Anwendungskontroll-API usw&per.
:p.
Leider scheint mindestens ein Entwickler jede dieser Funktionen benutzt zu haben;
Sie werden also wahrscheinlich gelegentlich &ue.ber eine Datei stolpern, die
nicht geladen wird oder nicht ordnungsgem&ae.&Beta. funktioniert&per.
.*
.*
.* ************************************************************
.* Using NewView
.* ************************************************************
:h1 res=2 id='Using'.NewView verwenden
:p.:hp2.NewView verwenden:ehp2.
:p.Nach dem :link reftype=hd refid='OpeningFiles'.&Oe.ffnen einer Datei:elink.
gibt es mehrere M&oe.glichkeiten, diese durchzulesen&per.
:p.Man kann das :link reftype=hd refid='contents'.Inhaltsverzeichnis:elink.
lesen, das :link reftype=hd refid='index'.alphabetisch sortierte Register:elink.
oder die :link reftype=hd refid='search'.Suche:elink. verwenden&per.
:p.Um die Hilfedatei wie ein normales Buch zu lesen, verwendet man die
Druckkn&oe.pfe &odq.R&ue.ckw&ae.rts&cdq.
:artwork runin name='..\images\previous.bmp'.
und &odq.Vorw&ae.rts&cdq.
:artwork runin name='..\images\next.bmp'.
zum Bl&ae.ttern durch die Themen&per.
:p.Die Hilfedatei kann auch wie Internetseiten gelesen werden, indem man die
Druckkn&oe.pfe &odq.Zur&ue.ck&cdq.
:artwork runin name='..\images\back.bmp'.
und &odq.Weiter&cdq.
:artwork runin name='..\images\forward.bmp'.
verwendet, um zu einem bereits besuchten Punkt zur&ue.ckzukehren oder den Weg
noch einmal zu verfolgen&per.
:p.Farben und einige von NewViews Verhaltensweisen lassen sich &ue.ber das Men&ue.
&odq.Werkzeuge&cdq. &endash. &odq.Optionen&cdq. anpassen&per.
:p.Themen k&oe.nnen zudem mit :link reftype=hd refid='notes'.Anmerkungen:elink. oder
:link reftype=hd refid='bookmarks'.Lesezeichen:elink. versehen werden&per.
.*
.*
.* ************************************************************
.* Opening Help File
.* ************************************************************
:h1 res=3 id='OpeningFiles'.ôffnen von Dateien
:i1 id=30005.&oe.ffnen
:p.:hp2.ôffnen von Hilfedateien:ehp2.
:p.
:p.Zum ôffnen einer Hilfedatei k&oe.nnen Sie&colon.
:ul.
:li.auf ein bereits vorhandenes Hilfesymbol doppelklicken,
:li.an einer Befehlszeile &odq.NewView:hp1. dateiname:ehp1.&cdq. eingeben oder
:li.innerhalb NewViews auf den Druckknopf &odq.&Oe.ffnen&cdq.
:artwork runin name='..\images\open.bmp'.
klicken oder
:li.eine k&ue.rzlich betrachtete Datei aus dem NewView-Men&ue. &odq.Datei&cdq. wieder laden&per.
:li.eine Hilfedatei von der Arbeitsoberfl&ae.che Ziehen und &Ue.bergeben&per.
:eul.
:p.Sobald die Datei geladen wurde, sollten das :link reftype=hd refid='contents'.Inhaltverzeichnis:elink.
und das erste Thema angezeigt werden&per.
:p.:hp2.Mehrere Dateien auf einmal laden:ehp2.
:p.Wie View kann auch NewView mehrere Dateien auf einmal laden, sie dabei so darstellen,
als ob es sich um ein Buch handelte und Umgebungsvariablen f&ue.r Dateinamen lesen&per.
:p.Im Zusammenhang mit der Dokumentation des OS&slash.2 Developers Toolkit l&ae.dt z&per.B&per.
.br
NewView cpref
.br
die &odq.Control Program Guide and Reference&cdq.&per. CPREF ist eine Umgebungsvariable&comma.
die in der Datei CONFIG&per.SYS gesetzt ist und &odq.CP1+CP2+CP3&cdq. enth&ae.lt&comma. wodurch NewView
&lpar.oder View&rpar. angewiesen wird, die Hilfedateien CP1, CP2 und CP3 zu laden&per. Nach den Dateien
wird in den Pfaden gesucht, die &ue.ber zwei
:link reftype=hd refid='L_EnvironmentVariables'.Umgebungsvariablen:elink. angegeben werden&per.&asterisk.
:p.Die Dateien werden dann alle geladen und jeweils der vorangegangenen angef&ue.gt&per.
:p.Mehrere Dateien auf einmal laden zu k&oe.nnen&comma. kann aus verschiedenen
Gr&ue.nden n&ue.tzlich sein&per. Beispielsweise nutzt 4OS&slash.2 &lpar.ein Ersatz f&ue.r
CMD&per.EXE&rpar. diese F&ae.higkeit, um der originalen CMD-Hilfe seine eigene
voranzustellen&per. Sie k&oe.nnen dies auch selbst mit allen beliebigen Dateien
tun, etwa wenn Sie beide immer zusammen verwenden&per.
:p.Man kann auch &ue.ber die grafische Oberfl&ae.che mehrere Dateien auf einmal
laden, indem man Strg und die Umschalttaste verwendet, um mehrere Dateien auszuw&ae.hlen&per.
:p.W&ae.hlt man einen Verweis auf eine andere Hilfedatei&comma. so l&ae.dt NewView die andere
Datei&comma. ohne die derzeitigen zu schlie&Beta.en&per.
:p.Man kann jederzeit &ue.ber das Men&ue. Datei &endash. Information herausfinden&comma. welche
Dateien gerade ge&oe.ffnet sind&per.
:p.:hp2.Weitere Dateien laden:ehp2.
:p.Wird im Dialog &odq.Datei &oe.ffnen&cdq. das Markierungsfeld &odq.Aktuelle Dateien ge&oe.ffnet lassen&cdq.
ausgew&ae.hlt, so l&ae.dt NewView die ausgew&ae.hlten Dateien, ohne die derzeit ge&oe.ffneten
vorher zu schlie&Beta.en&per.
:p.:hp2.Ziehen und &Ue.bergeben:ehp2.
:p.&per.INF&endash. und &per.HLP&endash.Dateien lassen sich durch Ziehen und
&Ue.bergeben an NewView &oe.ffnen&per. Wird dabei die Umschalttaste gedr&ue.ckt
gehalten, werden sie ge&oe.ffnet&comma. ohne die aktuellen Dateien vorher zu
schlie&Beta.en.
:p.Dateien k&oe.nnen an jeden der Hauptinhaltsbereiche &ue.bergeben werden,
wie etwa die Fenster des Inhaltverzeichnisses oder des Registers oder ein vorhandenes
Themenfenster&per.
:note text='Hinweis:'.Einige Links, die &ue.ber Dateien hinweg verweisen, funktionieren nur, wenn
der richtige Satz von Dateien geladen wurde&per.
.* ************************************************************
.* Help Icons
.* ************************************************************
:h2 res=17 id='HelpIcons'.Hilfeobjekte
:p.:hp2.Hilfeobjekte:ehp2.
:p.Hilfeobjekte auf der Arbeitsoberfl&ae.che sind gew&oe.hnlich &odq.Programmobjekte&cdq.,
bei denen der Programmname auf &odq.view&per.exe&cdq. verweist und deren Parameterfeld den
Namen der Hilfedatei enth&ae.lt.
:p.Manche Anwendungen erzeugen diese Objekte automatisch bei der Installation&per.
:p.Diese Objekte k&oe.nnen Sie mit Hilfe der Programm-Schablone selbst anlegen.
Weitere Informationen siehe die Hilfe der Arbeitsoberfl&ae.che.
:p.Wenn man Objekte durch Ziehen der Hilfedateien auf die Arbeitsoberfl&ae.che anlegt,
ist es nicht m&oe.glich, diesen sinnvolle Namen zu geben&comma. weil dadurch die
Dateinamen ge&ae.ndert w&ue.rden, was wiederum dazu f&ue.hren k&oe.nnte&comma. da&Beta.
Anwendungen ihre Hilfedateien nicht mehr finden k&oe.nnen&per. Aus diesem Grund sind
derzeit Programmobjekte die bevorzugte Methode zum Anlegen von Hilfeobjekten&per.
.*
.*
.* ************************************************************
.* Navigation Panel Tabs
.* ************************************************************
:h1 res=200 id='NavigationPanel'.Indexzungen des Navigationsfensters
:p.:hp2.Indexzungen des Navigationsfensters:ehp2.
:p.Der linke Fensterbereich enth&ae.lt mehrere Indexzungen&comma. mit deren Hilfe man
sich auf verschiedene Art und Weise durch die derzeit ge&oe.ffnete Hilfedatei bewegen kann&per.
:p.:link reftype=hd refid='contents'.Inhaltverzeichnis:elink.
:p.:link reftype=hd refid='Index'.Register:elink.
:p.:link reftype=hd refid='search'.Suche:elink.
:p.:link reftype=hd refid='notes'.Anmerkungen:elink.
:p.Durch Dr&ue.cken des Knopfes :artwork runin name='..\images\navigator.bmp'. oder durch Auswahl
von &odq.Ansicht&odq. &endash. &odq.Linkes Fenster anzeigen&cdq.
aus der Men&ue.leiste oder durch
Dr&ue.cken von Alt&plus.P&per. l&ae.&Beta.t sich dieser Bereich abschalten und so mehr Platz
f&ue.r die Anzeige erhalten. Mit demselben Vorgang kann er auch wieder angeschaltet werden.
:p.Die Anzeige des Navigationsfensters beim &Oe.ffnen einer Datei l&ae.&Beta.t sich durch
eine entsprechende Option unter &odq.Werkzeuge&cdq. &endash. &odq.Optionen&cdq. &endash. &odq.Allgemein&cdq. unterbinden.
:note text='Hinweis:'.Viele Anwendungen lassen beim &Oe.ffnen ihrer Hilfedateien das
Inhaltsverzeichnis anzeigen. In solchen F&ae.llen werden Ihre Einstellungen &ue.bersteuert
und das Navigationsfenster wird automatisch angezeigt.
.* ************************************************************
.* Contents View
.* ************************************************************
:h2 res=4 id='contents'.Inhaltansicht
:i1 id=30006.Inhaltsverzeichnis
:p.:hp2.Inhaltsverzeichnis:ehp2.
:p.
:p.Die meisten Hilfedateien besitzen ein Inhaltsverzeichnis, welches die in
der Datei vorhandenen Themen in einer Hierarchie oder einem &odq.Baum&cdq. anzeigt&per.
Gew&oe.hnlich wird diese Ansicht nach dem ôffnen einer Datei zuerst angezeigt&per.
:p.Die Zweige des Baums k&oe.nnen durch Klicken auf die Druckkn&oe.pfe &plus. oder &endash.
oder Bet&ae.tigen der Leertaste aus- und eingeklappt werden&per.
:p.Ein Thema aus dem Inhalt kann durch einfaches Klicken darauf aufgerufen werden&per. Mit Hilfe der
Pfeiltasten kann man sich durch den Inhalt bewegen&per.
:p.Um sich der Reihe nach durch :hp2.alle:ehp2. Themen des Inhaltsbaumes zu bewegen, verwendet
man die Tasten Strg &plus. Pfeil&endash.hoch und Strg &plus. Pfeil&endash.ab oder die Druckkn&oe.pfe
&odq.R&ue.ckw&ae.rts&cdq.
:artwork runin name='..\images\previous.bmp'.
und &odq.Vorw&ae.rts&cdq.
:artwork runin name='..\images\next.bmp'.&per.
Auf diese Weise kann die Datei wie ein normales Buch behandelt werden; man lie&Beta.t
jede Seite&per.
:p.Desweiteren l&ae.&Beta.t sich das gesamte Inhaltsverzeichnis anzeigen, indem &odq.Alle erweitern&cdq.
aus dem Men&ue. &odq.Ansicht&cdq. ausgew&ae.hlt wird&per. Dadurch werden alle Zweige des Inhaltsverzeichnisses
ausgeklappt, so da&Beta. man schnell eine öbersicht erh&ae.lt&per.
Normalerweise ist es allerdings einfacher, f&ue.r diesen Zweck die
:link reftype=hd refid='search'.Suche:elink. oder das :link reftype=hd refid='Index'.Register:elink. zu verwenden&per.
.* ************************************************************
.* Index
.* ************************************************************
:h2 res=5 id='Index'.Register
:p.:hp2.öber das Register:ehp2.
:p.
:p.Unter der Indexzunge &odq.Register&cdq. befindet sich eine alphabetisch geordnete
Aufstellung aller Themen und Schl&ue.sselw&oe.rter der Hilfedatei&per.
Sie l&ae.&Beta.t sich einfach durchsuchen, indem man die ersten Zeichen
des Wortes eingibt, nach dem man sucht&per. NewView springt dann automatisch
zum ersten Treffer im Register&per. Das hervorgehobene Thema l&ae.&Beta.t
sich durch Dr&ue.cken der Eingabetaste anzeigen&per.
:p.:hp5.Hinweise:ehp5.
:p.Hilfedateien k&oe.nnen ein &odq.offizielles&cdq. Register enthalten oder auch nicht&per.
Das Register wird vom Autor von Hand erstellt, seine N&ue.tzlichkeit &lpar.f&ue.r View&rpar.
h&ae.ngt also allein davon ab, wieviel Arbeit der Autor darin investiert hat&per.
Es kann auch vorkommen, da&Beta. keines vorhanden ist&per.
:p.Ein n&ue.tzliches Register kann jedoch schon durch einfaches, alphabetisches Auflisten
s&ae.mtlicher Themen bereitgestellt werden, und dies ist, was NewView macht&per.
Dann verschmilzt es das originale Register &lpar.falls vorhanden&rpar. mit der Liste der
Titel der Themen&per.
:p.Wem dies aus irgendeinem Grund nicht genehm ist, kann die Funktion &ue.ber die Indexzunge
&odq.Werkzeuge&cdq. &endash. &odq.Optionen&cdq. &endash. &odq.Allgemeines&cdq. abschalten&per.
.* ************************************************************
.* Search
.* ************************************************************
:h2 res=6 id='search'.Suche
:p.:hp2.Suchen:ehp2.
:p.
:p.Das Suchen stellt eine M&oe.glichkeit dar, schnell Informationen zu finden,
wenn man nicht wei&Beta., wo man anfangen soll&per. Rufen Sie einfach die Indexzunge
Suchen auf, geben Sie ein paar Worte mit Bezug zum Thema ein und klicken Sie auf den
Druckknopf Suchen&per. Sie erhalten eine Aufstellung aller Themen, die das
Wort oder die W&oe.rter enthalten, bei der die besten Treffer zuoberst angezeigt
werden&per.
:p.Mit dem Suchbegriff &ue.bereinstimmende W&oe.rter werden im Thema hervorgehoben&per.
:p.:hp2.Globale Suche:ehp2.
:p.&Ue.ber &odq.Werkzeuge&cdq. &endash. &odq.In allen Hilfedateien suchen&cdq. k&oe.nnen auch alle
Hilfedateien des Systems &ue.ber die :link reftype=hd refid='GlobalSearch'.Globale
Suche:elink. durchsucht werden&per.
:p.:hp2.Ausdruckssuche:ehp2.
:p.Wenn man nach einen aus mehr als einem Wort bestehenden Ausdruck suchen m&oe.chte&comma.
mu&Beta. dieser in Anf&ue.hrungszeichen eingeschlossen werden, wie etwa bei &odq.os&slash.2 warp&cdq.&per.
:p.:hp2.Vergleichsfunktionen:ehp2.
:p.NewView erlaubt bei der Suche eine feinere Kontrolle&per.
:p.&plus. zeigt ein Wort an, welches enthalten sein :hp2.mu&Beta.:ehp2..
:p.&endash. zeigt ein Wort an, welches :hp2.nicht:ehp2. enthalten sein darf.
:p.NewView f&ue.hrt immer Teilvergleiche durch&per. Das hei&Beta.t, wenn nach
&odq.win&cdq. gesucht w&ue.rde, f&ae.nde NewView auch &odq.window&cdq. und &odq.showing&cdq.&per.
Es gilt jedoch, da&Beta. das Resultat umso h&oe.her eingeordnet wird, je
besser der Vergleich zutrifft&per.
:p.:hp2.Wie NewView Ergebnisse ordnet:ehp2.
:p.NewView ordnet zutreffende Vergleiche nach mehreren Kriterien an&colon.
:ul.
:li.Treffer, die n&ae.her an einem ganzen Wort liegen
:li.der Anzahl der zutreffenden Worte in einem Thema
:li.Treffer innerhalb des Titels
:li.Treffer innerhalb eines Registereintrags
:eul.
.* ************************************************************
.* Notes
.* ************************************************************
:h2 res=7 id='notes'.Anmerkungen
:p.:hp2.Anmerkungen hinzuf&ue.gen und benutzen:ehp2.
:p.
:p.NewView erlaubt es, den Hilfedateien Anmerkungen hinzuzuf&ue.gen&per.
:p.Um eine Anmerkung hinzuzuf&ue.gen, klickt man einfach dorthin, wo die Anmerkung
eingef&ue.gt werden soll, dann auf den Druckknopf &odq.Anmerkung&cdq.
:artwork runin name='..\images\note.bmp'.&comma. gibt dann den Text ein und
dr&ue.ckt die Eingabetaste&per. Der Text wird dem Hilfethema mit einer anderen
Farbe hinzugef&ue.gt. &lpar.Gr&ue.n ist voreingestellt; dies kann jedoch unter
&odq.Werkzeuge&cdq. &endash. &odq.Optionen&cdq. &endash. &odq.Farben&cdq. angepa&Beta.t werden&per.&rpar.
:p.Um eine Anmerkung zu bearbeiten oder zu l&oe.schen, klickt man auf den farbigen
Anmerkungstext; anschlie&Beta.end kann man ihn bearbeiten oder durch Klicken
auf &odq.L&oe.schen&cdq. loswerden&per.
:p.Es kann auch eine öbersicht aller in der&slash.den aktuellen Hilfedatei&lpar.en&rpar. gemachten Anmerkungen
&ue.ber die Indexzunge Anmerkungen angezeigt werden&per. Diese bietet M&oe.glichkeiten
zum Hinzuf&ue.gen, Bearbeiten und L&oe.schen von Anmerkungen sowie zum Anspringen
der Themen, welche die Anmerkungen enthalten&per.
:p.
:p.Anmerkungen werden in einer Datei mit der Erweiterung &per.nte gespeichert, die sich
im selben Verzeichnis befindet, wie die zugeh&oe.rige Hilfedatei&per.
:note text='Hinweis:'.Wenn sich eine Hilfedatei &ae.ndert &lpar.beispielsweise wenn ein Programm
aktualisiert wird&rpar., dann werden die Anmerkungen nicht mehr an der richtigen Stelle
erscheinen; sie k&oe.nnen jedoch nach wie vor von der Indexzunge Anmerkungen aus
gelesen werden&per.
.*
.*
.* ************************************************************
.* Global Search
.* ************************************************************
:h1 res=18 id='GlobalSearch'.Globale Suche
:p.:hp2.Globale Suche:ehp2.
:p.S&ae.mtliche Hilfedateien des Systems lassen sich durch durch Bet&ae.tigen des
Druckknopfes &odq.Globale Suche&cdq.
:artwork runin name='..\images\search.bmp'.&comma. durch Auswahl von &odq.Werkzeuge&cdq. &endash.
&odq.Alle Hilfedateien durchsuchen&cdq. oder Dr&ue.cken der Tastenkombination Strg&plus.S durchsuchen.
:p.Diese Suche funktioniert &ae.hnlich der :link reftype=hd refid='search'.Suche
in Dateien:elink.&semi. es wird jedoch zus&ae.tzlich ausgegeben, in welcher Datei
ein Treffer gefunden wurde&per.
:p.Abh&ae.ngig von den eingegebenen Suchkriterien kann die Suche einige Zeit
dauern. Sie kînnen die Suche zu jeder Zeit abbrechen.
:p.:hp2.Wo NewView sucht:ehp2.
:p.Nach Hilfedateien wird standardm&ae.&Beta.ig in den Hilfepfaden gesucht&comma. welche
&ue.ber die :link reftype=hd refid='L_EnvironmentVariables'.Umgebungsvariablen:elink.
BOOKSHELF und HELP definiert werden.
:p.Mit Hilfe der DropDown List oder des Druckknopfes &odq.Ausw&ae.hlen&per.&per.&per.&cdq. k&oe.nnen sie die
Suche an ihre Erfordernisse anpassen&per.
:p.:hp2.Suche in&colon. Standardhilfepfade:ehp2.
:p.Dies ist die Voreinstellung. NewView sucht wie oben beschrieben&per.
:p.Mit Hilfe des Druckknopfes &odq.Ausw&ae.hlen&per.&per.&per.&cdq. k&oe.nnen sie festlegen, welche der Verzeichnisse
des Hilfepfades verwendet werden soll. Per Mausklick k&oe.nnen sie beliebige Eintr&ae.ge der Liste
selektieren bzw&per. deselektieren. Wenn sie eine Auswahl vorgenommen und best&ae.tigt haben, dann
wird als Auswahl &odq.Ausgew&ae.lte Hilfepfade&cdq. angezeigt.
:p.:hp2.Suche in&colon. Alle Festplatten:ehp2.
:p.Mit der Auswahl dieser Option k&oe.nnen sie alle Hilfedateien auf allen &lpar.festeingebauten&rpar. Festplatten ihres
Computers durchsuchen. Mit Hilfe des Druckknopfes &odq.Ausw&ae.hlen&per.&per.&per.&cdq. k&oe.nnen sie festlegen, welche Festplatten
durchsucht werden soll&per.
:p.Das Durchsuchen aller Hilfedateien auf allen Festplatten kann mehr Treffer finden. Normalerweise ist es daf&ue.r aber
deutlich langsamer als die Suchen in den Hilfepfaden&per.
:p.:hp2.Suche in&colon. Ausgew&ae.lte Hilfepfade:ehp2.
:p.Wenn sie bereits die Liste der zu durchsuchenden Pfade angepa&Beta.t haben&comma. dann k&oe.nnen sie sie mit
Hilfe des Druckknopfes &odq.Ausw&ae.hlen&per.&per.&per.&cdq. erneut ver&ae.ndern&per.
:p.:hp2.Suche in&colon. Verzeichnisliste:ehp2.
:p.
Wenn sie &odq.Liste der Verzeichnisse&cdq. w&ae.hlen k&oe.nnen sie mit dem Druckknopf &odq.Ausw&ae.hlen&per.&per.&per.&cdq.
eine Liste der zu durchsuchenden Verzeichnisse zusammenstellen.
:p.
W&ae.hlen sie das Laufwerk und das gew&ue.nschte Verzeichnis aus und bet&ae.tigen sie den
Druckknopf &odq.&lt. Verzeichnis hinzuf&ue.gen&cdq.. Selektieren sie &odq.Einschlie&Beta.lich Unterverzeichnisse&cdq. um
auch die Unterverzeichnisse des ausgew&ae.hlten Verzeichnissses zu durchsuchen&per. Diese Verzeichnisse k&oe.nnen
sie an der Endung &odq.&per.&per.&per.&cdq. erkennen&per.
:p.Wenn sie auf diese Weise ein Verzeichnis hinzugef&ue.gt haben, dann erscheint es in der Liste der zu
durchsuchenden Verzeichnisse&per.
:note text='Hinweis:'.
Wenn sie den Standardhilfepfaden oder den Ausgew&ae.hlten Hilfepfaden ein Verzeichnis hinzuf&ue.gen&comma.
dann wird aus der Liste eine Verzeichnisliste&per. Sie k&oe.nnen dann keine Hilfepfade mehr hinzuf&ue.gen&per.
Wenn Sie wieder die orginalen Hilfepfade verwenden wollen&comma. dann m&ue.ssen sie erneut
&odq.Standardhilfepfade&cdq. ausw&ae.hlen und den Druckknopfes &odq.Ausw&ae.hlen&per.&per.&per.&cdq. verwenden&per.
:p.:hp2.Suche in&colon. Direkte Eingabe eines Verzeichnisses:ehp2.
:p.
Sie k&oe.nnen auch direkt in das Feld &odq.Suche in&cdq. einen Verzeichnisnamen eingeben. H&ae.ngen sie &odq.&per.&per.&per.&cdq. an&comma.
um auch in den Unterverzeichnissen zu suchen&per.
:p.Beispiel&colon.
:p. Suche in&colon. &lbracket. E&colon.&bsl.mydocs&bsl.&per.&per.&per.
 &rbracket.
:p.So durchsuchen sis alle Hilfedateien in E&colon.&bsl.mydocs&bsl. und den Unterverzeichnissen&per.
.*
.*
.* ************************************************************
.* Bookmarks
.* ************************************************************
:h1 res=8 id='bookmarks'.Lesezeichen
:p.:hp2.Lesezeichen:ehp2.
:p.
:p.NewView erlaubt es, bestimmte Themen innerhalb der aktuellen Hilfedatei mit
Lesezeichen zu versehen&per. Dazu klickt man einfach auf den Druckknopf
Lesezeichen
:artwork runin name='..\images\bookmark.bmp'. und f&ue.gt
dem aktuellen Thema ein Lesezeichen hinzu&per.
:p.Um zu einem Lesezeichen zu springen, klickt man im Men&ue. &odq.Lesezeichen&cdq. auf
das zu &oe.ffnende Lesezeichen&per.
:p.S&ae.mtliche Lesezeichen k&oe.nnen angezeigt oder gel&oe.scht werden, indem
man auf &odq.Bearbeiten&per.&per.&per.&cdq. im Men&ue. &odq.Lesezeichen&cdq. klickt&per. Das Fenster bleibt
w&ae.hrend des Lesens ge&oe.ffnet, so da&Beta. man die Lesezeichen stets
schnell zur Verf&ue.gung hat&per.
:p.
:p.:hp5.Hinweise:ehp5.
:p.NewViews Lesezeichen beachten alle ge&oe.ffneten Themenfenster, wenn mehr als eines
ge&oe.ffnet ist&per.
:p.Die Lesezeichen werden in einer Datei mit der Erweiterung &per.bmk gespeichert, die sich
im selben Verzeichnis wie die zugeh&oe.rige Hilfedatei befindet&per.
.*
.*
.* ************************************************************
.* Internet Links
.* ************************************************************
:h1 res=100 id='InternetLinks'.Internet&endash.Links
:p.:hp2.Internet&endash.Links:ehp2.
:p.Klickt man auf eine Web&endash.URL wie etwa
http&colon.&slash.&slash.www&per.google&per.com&comma. started NewView den
Standard&endash.Web&endash.Browser&per.
:p.Dieser Web-Browser wird durch Einstellungen des Betriebssystems festgelegt,
nicht von NewView selbst&per. Um hier Einstellungen vorzunehmen, kan man ein
URL&endash.Objekt auf der Arbeitsoberfl&ae.che &oe.ffnen&comma. den Browser&endash.Pfad unter
der Indexzunge :hp2.Browser:ehp2. eingeben und dann auf &odq.Neuer Standard&cdq. dr&ue.cken&per.
:p.Browser k&oe.nnen auch in der Lage sein&comma. sich selbst zum Standard zu machen. Dies geschieht
entweder bei der Installation oder &ue.ber ihre Einstellungen&per.
:p.Links der Typen E&endash.Mail&comma. Newsgruppen und FTP werden ebenfalls an den Web&endash.Browser
weitergeleitet. Derzeit ist es nicht m&oe.glich&comma. hierf&ue.r eine andere Anwendung
festzulegen&per.
:p.:hp2.Hinweis f&ue.r Autoren von Hilfedateien:ehp2.
:p.Das Original-View versteht weder URLs noch E&endash.Mail&endash.Links, deshalb war
die einzige M&oe.glichkeit ihrer Implemtierung, einen Link auf z&per.B&per. &odq.netscape&per.exe&cdq.
mit den korrekten Parametern zu plazieren&per.
:p.NewView &ue.bersetzt Programm-Links auf &odq.netscape&cdq.&comma. &odq.explore&cdq. oder &odq.mozilla&cdq.
in Links f&ue.r den Standard&endash.Browser&per.
:p.Desweiteren erkennt es automatisch Links der Formen&colon.
:p. http&colon.&slash.&slash.  https&colon.&slash.&slash.
 ftp&colon.&slash.&slash.
:p. mailto&colon.  news&colon.
:p.Au&Beta.erdem werden wie URLs aussehende Zeichenketten auch ohne Protokollpr&ae.fix
erkannt&colon.
:p. www&per.a&per.b &endash. browser
:p. ftp&per.a&per.b &endash. ftp
:p. a&atsign.b&per.c &endash. email
:p.wobei a&comma. b und c beliebige alphanumerische Zeichenketten sind&per.
.*
.*
.* ************************************************************
.* Command Line
.* ************************************************************
:h1  res=9 id='CommandLine'.Befehlszeilenparameter
:p.:hp2.Befehlszeilenparameter:ehp2.
:p.Beim Aufruf von NewView aus einer Befehlszeile heraus k&oe.nnen diverse Parameter
&ue.bergeben werden, die alle optional sind&per.
:p.
:p.:hp2.NewView &lbracket.optionen&rbracket. &lbracket.&lt.dateiname&gt. &lbracket.&lt.suchbegriff&gt.&rbracket.&rbracket.:ehp2.
:p.Wurde NewView als Ersatz f&ue.r view installiert&comma. beginnt die Befehlszeile mit
view anstelle von newview&per.
:p.:link reftype=hd refid='CommandLineExamples'.Beispiele:elink.
:p.:hp2.&lt.dateiname&gt.:ehp2.
:p.
Die von NewView zu ladende Datei&per. Es k&oe.nnen mehrere Dateien auf einmal
geladen werden, indem dateiname1&plus.dateiname2 usw&per. angegeben wird&per.
.br
Wird kein Pfad angegeben, so wird in den
:link reftype=hd refid='L_EnvironmentVariables'.Pfaden BOOKSHELF und HELP:elink.
nach den Dateien gesucht&per.
.br
Wenn ihr Verzeichnis&dash. oder Dateiname Sonderzeichen (wie z&per.B&per. Leerzeichen) enth&ae.lt, dann m&ue.ssen sie den
Dateinamen in doppelte Hochkommatas einschlie&Beta.en&per.
:p.:hp2.&lt.suchbegriff&gt.:ehp2.
:p.Es wird nach auf diesen Text passenden Thementiteln und Indexeintr&ae.gen
gesucht. Aus Gr&ue.nden der Kompatibilit&ae.t handelt es sich hierbei :hp2.nicht:ehp2.
um die normale Suche&per. Eine richtige Suche wird bei Verwendung der Option
&slash.s &lpar.siehe unten&rpar. durchgef&ue.hrt&per. Siehe
:link reftype=hd refid='CommandLineTopicSearch'.Befehlszeilen-Themensuche:elink. f&ue.r Details&per.
:p.:hp2.Optionen:ehp2.
:p.:hp2.&slash.s:ehp2.
:p.Nach dem &Oe.ffnen der Datei wird eine :link reftype=hd refid='search'.Suche:elink.
(in diesem Fall anders als bei der Themensuche eine echte Volltextsuche) nach dem angegebenen Text durchgef&ue.hrt&per.
Sie erhalten das geleiche Ergebnis, wenn sie eine Suche &ue.ber das
:link reftype=hd
refid='search'.Indexzunge Suche im Navigationsfenster:elink. durchf&ue.hren&per.
:p.Beispiele&colon.
.br
:lm margin=4.
Um nach dem Begriff copy in gesamten Dokument cmdref zu suchen k&oe.nnen sie folgenden Befehlszeile verwenden
:xmp.
  newview &slash.s cmdref copy
:exmp.
NewView ist schlau genug auch mit mehreren Suchbegriffen umzugehen (like the :link reftype=hd
refid='search'.Indexzunge Suche im Navigationsfenster:elink. Hier ein Beispiel f&ue.r eine ODER-Suche&per.
:xmp.
  newview &slash.s cmdref net access
:exmp.
Um eine UND-Verkn&ue.pfung der Suchbegriffe zu erreichen, m&ue.ssen sie die Begriffe in dopplete Hochkommatas einfassen&per.
:xmp.
  newview &slash.s cmdref &odq.net access&cdq.
:exmp.
:lm margin=1.
.*
:p.:hp2.&slash.g:ehp2.
:p.F&ue.hrt eine :link reftype=hd refid='GlobalSearch'.globale Suche:elink. nach den angegebenen Suchbegriffen in allen Hilfedateien
des Systems durch&per.
:p.Beispiele&colon.
.br
:lm margin=4.
Um nach dem Begriff copy in allen Hilfedateien zu suchen k&oe.nnen sie folgenden Befehlszeile verwenden
:xmp.
  newview &slash.g copy
:exmp.
Sie k&oe.nnen auch eine Dateinamen als ersten Parameter angeben, um vor dem Start der Suche
eine Hilfedatei zu &Oe.ffnen.
:xmp.
  newview &slash.g cmdref copy
:exmp.
:lm margin=1.
.*
:p.:hp2.&slash.?:ehp2.
:p.Zeigt die Befehlszeilenhilfe an&per.
:p.Siehe auch&colon. :link reftype=hd refid='AdvancedParameters'.Fortgeschrittene
Parameter:elink.
:h2 res=13 id='CommandLineTopicSearch'.
Befehlszeilen-Themensuche
.* ************************************************************
.* Command Line Topic Search
.* ************************************************************
:p.:hp2.Befehlszeilen-Themensuche:ehp2.
:p. view &lt.dateiname&gt. &lt.thema&gt.
:p.Der an der Befehlszeile angegebene Themensuchparameter ahmt das Verhalten
des alten view nach&per.
:p.Nach dem Text wird nicht innerhalb der Themen gesucht&comma. nur in Titeln und Registereintr&ae.gen&per.
Das macht diese Funktion f&ue.r Menschen eher ungeeignet, aber sie wird von einigen
Anwendungen verwendet, um auf vorhersehbare Weise auf Hilfethemen zu verweisen&per.
:p.Es k&oe.nnen mehrere W&oe.rter verwendet werden&per.
:p.Die Suche wird folgenderma&Beta.en durchgef&ue.hrt&colon.
:ul.
:li.Thematitel beginnt mit Suchbegriff
:li.Registereintrag beginnt mit Suchbegriff
:li.Thematitel enth&ae.lt Suchtext
:li.Registereintrag enth&ae.lt Suchtext
:eul.
:p.Entwickler sollten sicherstellen, da&Beta. das erwartete Dokument auch gefunden wird,
wenn sie diese Methode zur Identifizierung von Themen beim Starten des alten oder neuen
view verwenden&per.
.* ************************************************************
.* Advanded Parameters
.* ************************************************************
:h2 res=14 id='AdvancedParameters'.
Fortgeschrittene Parameter
:p.:hp2.Fortgeschrittene Parameter:ehp2.
:p.Die folgenden Befehlszeilenparameter richten sich haupts&ae.chlich an Software&endash.Entwickler&comma.
k&oe.nnen aber f&ue.r jeden beliebigen Zweck eingesetzt werden&per.
:p.:hp2.&slash.lang&colon.&lt.sprachkennung&gt.:ehp2.
:p.L&ae.dt die angegebene Sprache. Hierdurch wird der entsprechend der Umgebungsvariable
LANG gew&ae.hlte Standard &ue.bersteuert&per. Beispielsweise l&ae.dt
:xmp.
  newview cmdref &slash.lang&colon.en
:exmp.
Englisch&per. Weitere Informationen finden sie in der Datei readme&per.txt&per.
:p.:hp2.&slash.pos&colon.&lt.links&gt.&comma.&lt.rechts&gt.&comma.&lt.breite&gt.&comma.&lt.h&oe.he&gt.:ehp2.
:p.Setzt das Hauptfenster NewViews auf die angegebene Position und Gr&oe.&Beta.e&per.
Es m&ue.ssen s&ae.mtliche Werte angegeben werden&per. Ein :hp2.P:ehp2. nach einem Wert
gibt einen Prozentwert an&per. Beispielsweise zentriert
:xmp.
  newview &slash.pos&colon.10P,10P,80P,80P
:exmp.
das Fenster und l&ae.&Beta.t es 80% des Bildschirms einnehmen&per.
:p.:hp2.&slash.title&colon.&lt.fenstertitel&gt.:ehp2.
:p.Legt als Titel des NewView-Fensters den angegebenen Text fest und &ue.berschreibt
dabei die Angaben in der Hilfedatei&per. Vor dem angegebenen Text wird stets der
Text &odq.Hilfe &endash.  &cdq. eingef&ue.gt, es sei denn, der angegebene Text w&ae.re
&odq.Hilfe&cdq.&per. In diesem Fall wird der Titel einfach zu &odq.Hilfe&cdq.&per. Damit soll erreicht
werden, da&Beta. Hilfefenster in der Fensterliste immer als solche hervorstechen&per.
:p.Wenn es notwendig ist, mehrere W&oe.rter anzugeben, schlie&Beta.en Sie die gesamte Option
in Anf&ue.hrungszeichen ein, wie beispielsweise in&colon.
:xmp.
  newview cmdref &odq.&slash.title&colon.Command Line Help&cdq.
:exmp.
.* ************************************************************
.* Command Line Examples
.* ************************************************************
:h2 res=15 id='CommandLineExamples'.
Befehlszeilenbeispiele
:p.:hp2.Befehlszeilenbeispiele:ehp2.
.*
:p.In den folgenden Beispielen wird vorausgesetzt, da&Beta. NewView als vollst&ae.ndiger
Ersatz f&ue.r view installiert wurde und view damit tats&ae.chlich newview ist&per.
:p.:hp2.view cmdref:ehp2.
:lm margin=4.
:p.&Oe.ffnet die Datei cmdref&per.inf &lpar.OS&slash.2 Command Reference&rpar. aus
dem Hilfepfad&per.
:lm margin=1.
.*
:p.:hp2.view cmdref&plus.os2ug:ehp2.
:lm margin=4.
:p.&Oe.ffnet die zwei Dateien cmdref&per.inf und os2ug&per.inf &lpar.OS&slash.2 User
Guide&rpar. im selben Fenster&per.
.br
Das Inhaltsverzeichnis von os2ug&per.inf wird am Ende des Inhaltsverzeichnisses
von cmdref&per.inf hinzugef&ue.gt&per. Die Register werden alphabetisch sortiert verschmolzen&per.
:lm margin=1.
.*
:p.:hp2.view c&colon.&bsl.os2&bsl.book&bsl.os2ug&per.inf:ehp2.
:lm margin=4.
:p.&Oe.ffnet die Datei os2ug&per.inf im Verzeichnis c&colon.&bsl.os2&bsl.book&per.
:lm margin=1.
.*
:p.:hp2.view &odq.c&colon.&bsl.os2 book&bsl.os2ug&per.inf&cdq.:ehp2.
:lm margin=4.
:p.Wenn das Verzeichnis oder der Dateiname Sonderzeichen enhh&ae.lt, dann mu&Beta. er in Hochkommatas eingschlossen werden&per.
:lm margin=1.
.*
:p.:hp2.view cmdref dir:ehp2.
:lm margin=4.
:p.&Oe.ffnet die Datei cmdref &lpar.OS&slash.2 command reference&rpar. und sucht in
den Titeln und im Register nach dem Wort &odq.dir&cdq.&per. Zeigt die Hilfe f&ue.r den Befehl DIR
an&per.
:lm margin=1.
.*
:p.:hp2.view &slash.s os2ug arbeitsoberfl&ae.che:ehp2.
:lm margin=4.
:p.&Oe.ffnet die Datei os2ug&per.inf und sucht nach dem Wort &odq.arbeitsoberfl&ae.che&cdq.&per. Der beste
Treffer wird angezeigt&per.
:lm margin=1.
.*
:p.:hp2.view &slash.g zugriffsrechte:ehp2.
:lm margin=4.
:p.F&ue.hrt eine Suche nach dem Wort &odq.zugriffsrechte&cdq. in allen Hilfedateien durch&per.
:lm margin=1.
.*
:p.:hp2.set myhelp&eq.cmdref&plus.os2ug&plus.rexx:ehp2.
.br
:hp2.view myhelp:ehp2.
:lm margin=4.
:p.Die erste Zeile weist der Umgebungsvariable MYHELP die Namen dreier Dateien zu&per.
Die zweite Zeile &oe.ffnet die drei Dateien&per.
:lm margin=1.
.*
.*
.* ************************************************************
.* Keyboard Shortcuts
.* ************************************************************
:h1 res=10 id='KeyboardShortcuts'.
Tastenk&ue.rzel
:p.:hp2.Tastenk&ue.rzel:ehp2.
:p.Die meisten Tastenk&ue.rzel werden in den Men&ue.s angezeigt, aber nicht alle&per.
Es gibt folgende weitere Tastenk&ue.rzel&colon.
:p.:hp2.Alt&plus.F4:ehp2. Beenden
:p.:hp2.Strg&plus.C:ehp2. Ausgew&ae.hlten Text in Zwischenablage kopieren
:p.:hp2.F7:ehp2. Zur&ue.ck
:p.:hp2.F8:ehp2. Weiter
:p.:hp2.Strg&plus.Pfeil&endash.links:ehp2. Zur&ue.ck
:p.:hp2.F11:ehp2. R&ue.ckw&ae.rts im Inhalt
:p.:hp2.F12:ehp2. Vorw&ae.rts im Inhalt
:p.
:p.:hp2.In den Men&ue.s sichtbare Tastenk&ue.rzel:ehp2.
:p.:hp2.Strg&plus.O:ehp2. Dateien &oe.ffnen
:p.:hp2.Strg&plus.E:ehp2. Dateien aus Hilfepfad &oe.ffnen
:p.:hp2.Strg&plus.N:ehp2. Neues Fenster &oe.ffnen
:p.:hp2.Strg&plus.P:ehp2. Thema drucken
:p.:hp2.F3:ehp2. Beenden
:p.
:p.
:p.:hp2.Strg&plus.A:ehp2. Gesamtes Thema ausw&ae.hlen
:p.:hp2.Strg&plus.Ins:ehp2. Ausgew&ae.hlten Text in Zwischenablage kopieren
:p.
:p.:hp2.Strg&plus.F:ehp2. Suche in derzeitigem Thema
:p.:hp2.Strg&plus.G:ehp2. Letzte Suche wiederholen
:p.
:p.:hp2.Strg&plus.S:ehp2. Globale Suche aufrufen
:p.
:p.:hp2.Alt&plus.C:ehp2. Indexzunge Inhaltsverzeichnis aufrufen
:p.:hp2.Alt&plus.I:ehp2. Indexzunge Register aufrufen
:p.:hp2.Alt&plus.S:ehp2. Indexzunge Suche aufrufen
:p.:hp2.Alt&plus.N:ehp2. Indexzunge Anmerkungen aufrufen
:p.:hp2.Alt&plus.P:ehp2. Linken Navigationsbereich &lpar.Indexzungen&rpar. an- und ausschalten
:p.:hp2.F5:ehp2. Alle Themen erweitern
:p.:hp2.F6:ehp2. Alle Themen schrumpfen
:p.
:p.:hp2.Esc:ehp2. Zur&ue.ck
:p.:hp2.Strg&plus.Right:ehp2. Weiter
:p.:hp2.Strg&plus.Up:ehp2. R&ue.ckw&ae.rts im Inhalt
:p.:hp2.Strg&plus.Down:ehp2. Vorw&ae.rts im Inhalt
:p.
:p.:hp2.Strg&plus.D:ehp2. Lesezeichen bearbeiten
:p.:hp2.Strg&plus.B:ehp2. Lesezeichen f&ue.r derzeitiges Thema anlegen
:p.
:p.:hp2.Strg&plus.M:ehp2. Anmerkung an Cursor-Position einf&ue.gen
:p.
:p.:hp2.F1:ehp2. NewView-Hilfe
.*
.*
.* ************************************************************
.* Environment Variables
.* ************************************************************
:h1 res=11 id='L_EnvironmentVariables'.Umgebungsvariablen
:p.:hp2.Umgebungsvariablen:ehp2.
:p.
:p.Die beiden Umgebungsvariablen :hp2.BOOKSHELF:ehp2. und :hp2.HELP:ehp2. definieren
Pfade &lpar.Verzeichnislisten&rpar. f&ue.r die Suche nach Hilfedateien&per.
NewView macht bei der Verwendung der Pfade keinen Unterschied&per.
:p.In diesen Pfaden wird gesucht wenn man&colon.
:ul.
:li.an der Befehlszeile eine Hilfedatei ohne Pfad angibt
:li.den Men&ue.eintrag &odq.Datei&cdq. &endash. &odq.&Oe.ffnen spezial&per.&per.&per.&cdq. benutzt
:li.eine :link reftype=hd refid='GlobalSearch'.Globale Suche:elink. durchf&ue.hrt
:eul.
:p.Man kann den Pfaden aus :hp2.HELP:ehp2. und :hp2.BOOKSHELF:ehp2. neue Verzeichnisse
permanent hinzuf&ue.gen, indem man die Datei CONFIG&per.SYS anpa&Beta.t&per. Wenn auch
das alte view die Dateien finden k&oe.nnen soll, f&ue.gen Sie die Verzeichnisse
beiden Pfaden hinzu&per.
:p.:hp2.Weitere Umgebungsvariablen:ehp2.
:p.Die Umgebungsvariable :hp2.LANG:ehp2. wird untersucht, um die bei der Anzeige von
NewView zu verwendende Sprache festzustellen&per. &lpar.Wird durch den
&slash.lang :link reftype=hd refid='AdvancedParameters'.Befehlszeilenparameter:elink.
&ue.bersteuert&per.&rpar. Weitere Informationen &ue.ber Sprachen siehe readme&per.txt.
:p.Das in :hp2.LOGFILES:ehp2. angegebene Verzeichnis wird zur Protokollierung
von Abst&ue.rzen und anderen Informationen verwendet.
:p.Das Unterverzeichnis &odq.lang&cdq. des durch :hp2.OSDIR:ehp2. definierten Verzeichnisses
wird beim Start nach Sprachdateien durchsucht&per.
:p.Auch der Pfad in :hp2.ULSPATH:ehp2. wird nach Sprachdateien durchsucht&per.
.*
.*
.* ************************************************************
.* For Authors and Developers
.* ************************************************************
:h1 res=20 id='ForAuthors'.
F&ue.r Authoren und Entwickler
:p.:hp2.F&ue.r Authoren und Entwickler:ehp2.
:p.
:p.Dieser Abschnitt enth&ae.lt einige Hinweise fÅr Authoren von Dokumenten
und Software-Entwickler&per.
:p.Beachten sie bitte auch die Abschnitte zur URL-Erkennung unter :link reftype=hd
refid='InternetLinks'.Internet-Links :elink.&per.
.* ************************************************************
.* Writing Help Files
.* ************************************************************
:h2 res=12 id='WritingHelpFiles'.Erstellen von Hilfedateien
:p.:hp2.Erstellen von OS&slash.2-Hilfedateien:ehp2.
:p.
:p.OS&slash.2-Hilfedateien werden mit Hilfe des IPF-Compilers erstellt&per. IPF steht f&ue.r Information
Presentation Facility&per.
:p.Der IPF-Compiler lie&Beta.t eine Textdatei, die in einer Sprache geschrieben ist,
welche ihm alles &ue.ber Dinge wie öberschriften, Verweise, Text und Bilder
mitteilt, und produziert entweder eine &per.INF- oder eine &per.HLP-Datei&per.
:p.Der offizielle Weg, sich den IPF-Compiler &lpar.ipfc&per.exe&rpar. zu besorgen, ist das OS&slash.2
Developers Toolkit&per. Dies ist Teil des Lieferumfangs von eComStation
&lpar.http&colon.&slash.&slash.www&per.ecomstation&per.com&rpar.&per.
:p.Da die Sprache f&ue.r IPFC recht erm&ue.dend ist &lpar.beispielsweise mu&Beta.
die gesamte Interpunktion &ue.ber Schl&ue.sselw&oe.rter wie &amp.comma&per.
eingegeben werden&rpar.&comma. benutzen viele neben dem IPF-Compiler selbst weitere
Dienstprogramme&per.
:p.
Ich verwende Vyperhelp &lpar.http&colon.&slash.&slash.www&per.vyperhelp&per.com&rpar.&comma.
weil es einfach und grafisch ist&per.
Es kann auch Windows-Hilfe, HTML und andere Formate exportieren, obwohl es nur unter
OS&slash.2 l&ae.uft&per. Kostenpflichtig&per.
:p.Einige weitere beliebte M&oe.glichkeiten&colon.
:ul.
:li.HyperText&slash.2 IPF Preprocessor
&lpar.http&colon.&slash.&slash.www&per.clanganke&per.de&slash.os2&slash.sw&slash.htext&slash.&rpar.
&endash. setzt eine einfachere Sprache in das sehr komplizierte
IPF&endash.Format um&per. Gratis&per.
:li.HyperMake
&lpar.http&colon.&slash.&slash.www&per.hypermake&per.com&rpar. &endash.
&Ae.hnlich&comma. kann aber auch Windows-Hilfe und HTML ausgeben&per.
:li.Sibyl &lpar.mit dem NewView entwickelt wurde&rpar. enth&ae.lt einen
IPF&endash.Pr&ae.prozessor&per.
:li.IPFEditor von PCS
&lpar.http&colon.&slash.&slash.www&per.pcs&endash.soft&per.com&slash.productipfe212&per.htm&rpar.
&endash. Wahrscheinlich das vollst&ae.ndigste Produkt&comma. aber auch das teuerste&per.
Hinweis&colon. NewView unterst&ue.tzt nicht alle von IPFE gebotenen M&oe.glichkeiten&xclm.
:eul.
:p.Fr&ue.her gab es noch viele weitere M&oe.glichkeiten&per. Die oben aufgef&ue.hrten sollten
noch erh&ae.ltlich sein und zu einem gewissen Ma&Beta. unterst&ue.tzt werden&per.
.* ************************************************************
.* Topic Resource IDs
.* ************************************************************
:h2 res=16 id='TopicResourceIDs'.Themen-Ressourcenkennungen
:p.:hp2.Themen-Ressourcenkennungen:ehp2.
:p.Ressourcenkennungen werden von den Autoren der Hilfedateien f&ue.r Anwendungen
zur Identifizierung von Hilfethemen verwendet&per. Anwendungen rufen den Hilfe-Manager
unter Angabe einer Ressourcenkennung auf &endash. entweder direkt &ue.ber
die HM&us.DISPLAY&us.HELP Nachricht oder indirekt &ue.ber
ihren Ressourcen hinzugef&ue.gte Hilfetabellen, die der PM automatisch handhabt&per.
Die Ressourcenkennung wird in einer Tabelle innerhalb der Hilfedatei gespeichert&per.
:p.Autoren von Dokumenten bietet NewView die F&ae.higkeit&comma. Ressourcenkennungen
zu sehen und zu finden&per.
:p.:hp2.Suche nach Ressourcenkennung:ehp2.
:p.Zur Suche einer angegebenen Ressourcenkennung in allen ge&oe.ffneten Dateien
w&ae.hlen Sie &odq.Werkzeuge&cdq. &endash. &odq.Suche nach Ressourcenkennung&cdq.&per.
:p.:hp2.Ressourcenkennungen anzeigen:ehp2.
:p.Mit Hilfe der Themeneigenschaften &lpar.rechte Maustaste &endash. Einstellungen&rpar.
l&ae.&Beta.t sich herausfinden&comma. welche Ressourcenkennung einem Thema zugeteilt ist&per.
.* ************************************************************
.* TopicNames
.* ************************************************************
:h2 res=19 id='TopicNames'.
Themen-Namen
:p.:hp2.Themen-Namen:ehp2.
:p.
:p.&Ae.hnlich wie Ressourcenkennungen k&oe.nnen auch Ressourcennamen von Applikationsentwicklern
genutzt werden, um Themen in der Hilfedatei zu referenzieren (per HM&us.DISPLAY&us.HELP
Nachricht mit dem HM&us.PANELNAME als zwetem Parameter&per.
:p.Diese Variante wird allerdings nicht so h&ae.ufig verwendet&per.
:p.NewView kann einen Themennamen finden. Verwenden sie dazu Werkzeuge &endash. Thema
nach Title suchen&per.
:euserdoc.
