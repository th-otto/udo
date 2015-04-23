:userdoc.
:docprof toc=123456.
.nameit symbol=prodname text=':hp2.:color fc=default bc=default.NewView:color fc=default bc=default.:ehp2.'
:title.Aide de NewView
.* Subject: Help for &prodname.
.* Version:
.* Copyright: Copyright 2005 Aaron Lawrence
.* Author: Aaron Lawrence
.* French translation : Guillaume Gay
.* French version : 2007-05-25

.**************************************************************************
.* SECTION : INTRODUCTION                                                 *
.**************************************************************************
:h1 res=30000 id='Introduction'.Introduction
:i1 id=30001.Support
:artwork runin name='..\images\newview.bmp'.
:hp2.Bienvenue dans :ehp2.&prodname.:hp2. &xclm. :ehp2.
:p.
:artwork align=center name='newview.bmp'.
:p.
:p.&prodname. est un programme qui permet de lire les fichiers d'aide
d'OS&slash.2 &lpar.ou eComStation&rpar.&per.
:p.:link reftype=hd refid='Support'.Licence et support:elink.
:p.:link reftype=hd refid='Utilisation'.Utilisation de &prodname.:elink.
:p.:hp1.Pour Çviter que ce fichier apparaisse lorsque vous lancez
&prodname. sans spÇcifier de fichier d'aide, allez sur l'onglet GÇnÇral
dans Outils &endash. Options&per. :ehp1.
:p.:hp2.Historique:ehp2.
:p.&prodname. se substitue au programme original d'IBM fourni avec
OS&slash.2&per.
:p.Il amÇliore plusieurs aspects de View&comma. avec une interface
plus moderne et facile Ö utiliser&comma. plus d'options&comma.
et de nouvelles fonctionnalitÇs que View n'avait tout simplement
pas&per.
:p.
.**************************************************************************
.* SECTION : SUPPORT AND LICENSING                                        *
.**************************************************************************
:h2 res=1 id='Support'.Licence et support
:i1 id=30002.Licence
:i2 refid=30001.Licence et support
:i2 refid=30001.Introduction
:i1 id=30003.Bugs
:i1 id=30004.Code source
:p.:hp2.Licence et support:ehp2.
:p.&prodname. est un copyright &bx0012. 1999&endash.2006 Aaron Lawrence&per.
Il est aussi  distribuÇ sous licence publique GNU (GNU Public
License ou GPL)&comma. ce qui signifie que vous avez le droit
d'obtenir le code source&per.
:p.Depuis 2006, Ronald Brill maintient le produit&per.
:p.&prodname. est un projet Netlabs&per.
:p.Veuillez consulter le fichier LisezMoi.txt pour plus de dÇtails
techniques&per.
:p.Veuillez consulter le fichier Changes&per.txt pour un
historique des modifications apportÇes Ö &prodname.&per.
:p.Si vous trouvez &prodname. utile&comma. veuillez m'envoyer un Mêl
et&slash.ou faire un don pour supporter les dÇveloppements futurs&per.
C'est toujours sympa. de recevoir des nouvelles ! Vous pourrez
alors &colon.
:ul compact.
:li.faire vos suggestions, compliments ou rapports de bugs
ici &colon. http&colon.&slash.&slash.svn.netlabs.org&slash.newview
:li.nous faire parvenir la traduction de &prodname. dans votre langue
:li.faire un don Ö Netlabs &colon. http&colon.&slash.&slash.www.mensys.nl
:eul.
:p.:hp2.Rapport de bugs:ehp2.
:p.Si vous deviez reporter un plantage ou autre probläme, soyez alors
aussi prÇcis que possible quant aux fichiers qui Çtaient utilisÇs, sur
ce que vous faisiez, etc.&per. S'il est disponible, vous àtes PRIê(E)
d'inclure le fichier newview.log. Ce fichier de rapport se trouve SOIT
:ul compact.
:li.dans le màme rÇpertoire que celui de &prodname.,
:li.dans le dossier dÇfini dans la variable d'environnement
:hp2.LOGFILES:ehp2. (dans le cas des versions 1.1 et ultÇrieures de eCS).
:eul.
Si le probläme est spÇcifique Ö un fichier d'aide particulier, envoyez-le
moi, du moment qu'il n'est pas trop gros (taille supÇrieure Ö 1 Mo).
:p.La plupart des informations se trouve dans le fichier
:hp2.newview&per.log:ehp2., mais ce serait träs utile si vous pouviez le
donner pour vÇrification &colon.
:ol compact.
:li.La version de &prodname. &lpar.":hp2.Aide:ehp2." &endash. ":hp2.Info.
produit:ehp2."&rpar.&comma.
:li.les noms des fichiers d'aide&per.
:eol.
:p.Une copie d'Çcran pourrait se rÇvÇler utile s'il s'agit d'un affichage
incorrect ou corrompu.
:p.:hp2.Pourquoi mon fichier d'aide ne fonctionne-t-il pas correctement ? :ehp2.
:p.Certaines des fonctionnalitÇs les moins utilisÇes du programme View
original non pas ÇtÇ implÇmentÇes. C'est soit parceque je ne l'ai pas
vues, soit parceque cela ne vaut pas le peine d'y perdre du temps. Comme
exemples, il y a les mÇtafichiers, l'index des synonymes, l'API de
contrìle dans son intÇgralitÇ, et ainsi de suite.
:p.Malheureusement, il semblerait qu'au moins un dÇveloppeur a utilisÇ
une ou plusieurs de ces fonctionnalitÇs, il vous arrivera donc
occasionnellement de trouver quelques fichiers qui ne se chargent pas
ou qui ne fonctionnent pas correctement.
:p.
.**************************************************************************
.* SECTION : USAGE                                                        *
.**************************************************************************
:h1 res=2 id='Utilisation'.Utilisation de NewView
:p.:hp2.Utilisation de &prodname.:ehp2.
:p.Apräs avoir :link reftype=hd refid='OuvertureDeFichiers'.ouvert un
fichier:elink.&comma. vous pouvez le lire de diffÇrentes maniäres.
:p.Vous pouvez consulter la :link reftype=hd refid='Contenu'.table
des matiäres:elink.&comma. utiliser l':link reftype=hd refid='Index'.index
alphabÇtique:elink. ou la
:link reftype=hd refid='Recherche'.recherche:elink.&per.
:p.Pour lire simplement le fichier d'aide comme s'il s'agissait d'un
livre, utilisez les boutons ":hp2.PrÇcÇdent:ehp2."
:artwork runin name='..\images\previous.bmp'. et ":hp2.Suivant:ehp2."
:artwork runin name='..\images\next.bmp'. pour parcourir une Ö une
toutes les sections.
:p.Vous pouvez aussi naviguer dans le fichier d'aide comme sur le Web en
utilisant les boutons ":hp2.Arriäre:ehp2."
:artwork runin name='..\images\back.bmp'. et ":hp2.Avant:ehp2."
:artwork runin name='..\images\forward.bmp'. pour retourner lÖ oó vous
Çtiez avant ou bien retourner sur vos pas.
:p.Les couleurs et certains comportements de &prodname. peuvent àtre
personnalisÇs via l'ÇlÇment ":hp2.Options:ehp2." du menu
":hp2.Outils:ehp2.".
:p.Vous pouvez en outre :link reftype=hd refid='Notes'.annoter:elink. ou
:link reftype=hd refid='Signets'.mettre en signet:elink. des sections.
:p.
.**************************************************************************
.* SECTION : OPENING FILES                                                *
.**************************************************************************
:h1 res=3 id='OuvertureDeFichiers'.Ouverture de fichiers
:i1 id=30005.Ouvrir
:p.:hp2.Ouverture de fichiers d'aide:ehp2.
:p.Pour ouvrir un fichier d'aide, vous pouvez utiliser l'une des
mÇthodes suivantes &colon.
:ul compact.
:li.en double-cliquant sur une :link reftype=hd refid='IconesAide'.icìne
d'aide:elink. dÇjÖ paramÇtrÇe&comma.
:li.en tapant "view :hp1.NomFichier:ehp1." depuis la
:link reftype=hd refid='LigneDeCommandes'.ligne de commandes:elink.&comma.
:li.en cliquant sur le bouton "Ouvrir..."
:artwork runin name='..\images\open.bmp'. dans &prodname.&comma.
:li.en rechargeant un fichier ouvert rÇcemment depuis le menu
"Fichier"&comma.
:li.par glisser&slash.dÇposer d'un fichier d'aide depuis le bureau.
Une fois le fichier chargÇ, vous devriez voir s'afficher la
:link reftype=hd refid='Contenu'.table des matiäres:elink. et la
premiäre section.
:eul.
:note.il est supposÇ ici que vous avez installÇ &prodname. comme
remplacement du programme View original. Si ce n'est pas le cas, les
icìnes d'aide existantes et la ligne de commandes peuvent se comporter
diffÇremment.
:p.:hp2.Chargement simultanÇ de plusieurs fichiers:ehp2.
:p.&prodname. peut charger plusieurs fichiers simultanÇment, en les
prÇsentant comme s'ils n'Çtaient qu'un seul et rechercher des noms de
fichiers dans les variables d'environnement.
:p.Par exemple, dans la documentation du Kit de DÇveloppement d'OS&slash.2
("OS&slash.2 Developer&apos.s Toolkit") &colon.
.br
  :font facename='Courier' size=14x8.NewView cpref:font facename='Default' size=0x0.
.br
charge le Guide et rÇfÇrence du programme de contrìle ("Control Program
Guide and Reference"). :hp2.CPREF:ehp2. est une variable d'environnement
paramÇtrÇe dans le fichier :hp2.CONFIG.SYS:ehp2. et consiste en
"CP1&plus.CP2&plus.CP3" indiquant Ö &prodname. &lpar.ou
:hp2.View:ehp2.&rpar. qu'il faut charger les fichiers d'aide CP1, CP2 et
CP3. Les fichiers sont recherchÇs dans les chemins spÇcifiÇs dans deux
:link reftype=hd refid='VariablesEnvironnement'.variables
d'environnement:elink.&per.
:p.Les fichiers sont tous chargÇs et effectivement ajoutÇs les uns aux
autres.
:p.êtant capable de charger ainsi plusieurs fichiers peut se rÇvÇler
utiles pour plusieurs raisons. Par exemple, :hp2.4OS&slash.2:ehp2.
&lpar.une alternative Ö :hp2.CMD&per.EXE:ehp2.&rpar. utilise cette
technique pour ajouter sa propre aide par-dessus l'aide de CMD originale.
Vous pouvez le faire vous-màme avec les fichiers que vous voulez.
:p.Vous pouvez charger plusieurs fichiers dans la boåte de dialogue
d'ouverture de fichiers en utilisant la touche :hp2.Ctrl:ehp2. ou la
touche :hp2.Maj:ehp2. pour sÇlectionner un ensemble de fichiers.
:p.Lorsque vous cliquez sur un lien vers un fichier d'aide diffÇrent,
&prodname. charge l'autre fichier sans fermer le fichier en cours.
:p.∑ n'importe quel moment vous pouvez savoir quels sont les fichiers
ouverts en utilisant l'option ":hp2.Information...:ehp2." du menu
":hp2.Fichier:ehp2.".
:p.:hp2.Chargement de fichiers supplÇmentaires:ehp2.
:p.Vous pouvez cocher la case ":hp2.Conserver les fichiers ouverts:ehp2."
dans la boåte de dialogue d'ouverture de fichiers, et &prodname. ouvrira
le(s) fichier(s) que vous avez sÇlectionnÇ(s) sans fermer les fichiers en
cours.
:p.:hp2.Glisser&slash.dÇposer:ehp2.
:p.Vous pouvez glisser et dÇposer des fichiers &per.INF ou &per.HLP sur
&prodname. pour les ouvrir. Si vous maintenez appuyÇ la touche
:hp2.Maj:ehp2., ils seront ouverts sans que les fichiers en cours ne
soient fermÇs.
:p.Vous pouvez dÇposer des fichiers Ö n'importe quel endroit de la
fenàtre de contenu comme les fenàtres de table des matiäres ("Contenu") ou
d'Index, ou une fenàtre de section existante.
:note.certains liens de fichiers Ö fichiers ne fonctionneront que si
l'ensemble des fichiers est correctement chargÇ.
:p.
.**************************************************************************
.* SECTION : HELPICONS                                                    *
.**************************************************************************
:h2 res=17 id='IconesAide'.Icìnes d'aide
:p.:hp2.Icìnes d'aide:ehp2.
:p.Les icìnes d'aide sur le bureau sont en gÇnÇral des objets "programme"
ayant pour nom de fichier ":hp2.VIEW&per.EXE:ehp2." et pour paramätres
les noms des fichiers d'aide.
:p.Certains programmes crÇent ces icìnes automatiquement au moment de
l'installation.
:p.Vous pouvez crÇer ces icìnes vous-màme en utilisant le modäle d'objet
programme du bureau. Veuillez vous rÇfÇrer Ö l'aide du bureau pour plus
d'informations.
:p.Si vous crÇez des icìnes en glissant des fichiers d'aide sur le
bureau, vous ne pourrez alors pas leur donner un titre plus significatif,
puisque cela changerait le nom du fichier, empàchant alors les
programmes de trouver leurs fichiers d'aide. L'usage d'un objet
programme est donc le moyen recommandÇ pour crÇer des icìnes d'aide.
:p.
.**************************************************************************
.* SECTION : NAVIGATION PANEL                                             *
.**************************************************************************
:h1 res=200 id='PanneauDeNavigation'.Onglets du panneau de navigation
:p.:hp2.Onglets du panneau de navigation:ehp2.
:p.Le panneau de gauche comprends plusieurs onglets pour naviguer de
diffÇrentes maniäres dans le fichier d'aide en cours.
:ul compact.
:li.:link reftype=hd refid='Contenu'.Onglet Contenu &lpar.table des
matiäres&rpar.:elink.
:li.:link reftype=hd refid='Index'.Onglet Index:elink.
:li.:link reftype=hd refid='Recherche'.Onglet Recherche:elink.
:li.:link reftype=hd refid='Notes'.Onglet Notes:elink.
:eul.
:p.Vous pouvez dÇsactiver ce panneau afin d'avoir plus de place, en
sÇlectionnant l'option ":hp2.Panneau de gauche:ehp2." du menu
":hp2.Affichage:ehp2.", ou en appuyant sur la combinaison de touches
:hp2.Alt:ehp2.&plus.:hp2.P:ehp2.&per. RÇpÇtez l'opÇration pour l'activer Ö
nouveau.
:p.Vous pouvez empàcher le panneau de navigation d'apparaåtre lorsqu'un
fichier d'aide est ouvert sur l'onglet ":hp2.GÇnÇral:ehp2." des
":hp2.Options:ehp2." du menu ":hp2.Outils:ehp2.".
:note.pas mal de programmes choisissent d'afficher la table des matiäres
lorsqu'ils ouvrent leurs fichiers d'aide &semi. dans ce cas, le panneau
est alors automatiquement affichÇ, ignorant vos paramätres.
:p.
.**************************************************************************
.* SECTION : CONTENTS                                                     *
.**************************************************************************
:h2 res=4 id='Contenu'.Contenu
:i1 id=30006.Contenu
:hp2.Table des matiäres ("Contenu"):ehp2.
:p.:artwork align=center  name='contentstab.bmp'.
:p.La plupart des fichiers d'aide a une table des matiäres qui affiche
les diffÇrents chapitres (ou sections) du fichier, sous forme hiÇrarchique
ou d'arbre. C'est en gÇnÇral la premiäre vue que vous obtenez lorsque vous
ouvrez ces fichiers.
:p.Vous pouvez dÇrouler ou enrouler les branches de l'arbre en cliquant
sur les boutons :hp2.&plus.:ehp2. ou :hp2.&endash.:ehp2.&comma. ou en
utilisant la barre espace.
:p.Pour afficher une section depuis la fenàtre Contenu, cliquez juste
dessus. Vous pouvez aussi vous dÇplacer dans le contenu en utilisant les
touches fläches.
:p.Pour se dÇplacer Ö travers &asterisk.toutes&asterisk. les sections
de la table des matiäres, dans l'ordre, vous pouvez utiliser les
combinaisons de touches :hp2.Ctrl:ehp2.&plus.:hp2.Haut:ehp2. et
:hp2.Ctrl:ehp2.&plus.:hp2.Bas:ehp2.&comma. ou les boutons
":hp2.PrÇcÇdent:ehp2." :artwork runin name='..\images\previous.bmp'. et
":hp2.Suivant:ehp2." :artwork runin name='..\images\next.bmp'.&per. C'est une
maniäre de traiter le fichier comme s'il s'agissait d'un livre, en
feuilletant une Ö une chaque page.
:p.Vous pouvez consulter la table des matiäres compläte en utilisant
l'option ":hp2.Tout dÇrouler:ehp2." du menu ":hp2.Affichage:ehp2.". Cela
dÇroulera toutes les branches de la table des matiäres de maniäre Ö ce que
vous puissiez la parcourir plus rapidement. Cependant, il est en gÇnÇral
plus aisÇ d'utiliser la
:link reftype=hd refid='Recherche'.recherche:elink. ou
l':link reftype=hd refid='Index'.index:elink. Ö cet effet.
:p.
.**************************************************************************
.* SECTION : INDEX                                                        *
.**************************************************************************
:h2 res=5 id='Index'.Index
:p.:hp2.Index:ehp2.
:p.:artwork align=center name='indextab.bmp'.
:p.L'onglet :hp2.Index:ehp2. contient la liste alphabÇtique des sections
ou mots-clÇs du fichier d'aide. Vous pouvez y effectuer une recherche
rapide en tapant les premiers caractäres du mot dÇsirÇ. &prodname. ira
automatiquement Ö la premiäre correspondance trouvÇe dans l'index. Pour
visualiser la section sÇlectionnÇe, appuyez sur la touche
:hp2.EntrÇe:ehp2.&per.
:nt text='Remarques &colon.'.
:p.les fichiers d'aide peuvent ou non inclure un index "officiel". L'index
est crÇÇ manuellement par l'auteur, son utilitÇ &lpar.pour le programme
View d'origine&rpar. est donc strictement dÇpendante de la quantitÇ de
travail que l'auteur a mis dans le fichier. Il se peut qu'il n'y en ait
màme pas.
:p.Cependant, un index utilisable peut àtre fourni simplement en listant
alphabÇtiquement les titres de chaque section, ce que &prodname. fait.
Il fusionne alors l'index original &lpar.s'il y en a un&rpar. avec la
liste des titres de sections.
:p.Si, pour quelque raison que ce soit, vous n'aimez pas, vous pouvez
dÇsactiver cette fenàtre dans l'onglet ":hp2.GÇnÇral:ehp2." des
":hp2.Options:ehp2." du menu ":hp2.Outils:ehp2.".
:ent.
:p.
.**************************************************************************
.* SECTION : SEARCH                                                       *
.**************************************************************************
:h2 res=6 id='Recherche'.Recherche
:p.:hp2.Recherche:ehp2.
:p.:artwork align=center name='searchtab.bmp'.
:p.Recherche est un moyen rapide pour trouver une information lorsque
vous ne savez pas par oó commencer. Allez tout simplement dans l'onglet
:hp2.Recherche:ehp2.&comma. tapez les mots relatifs Ö votre recherche et
cliquez sur le bouton ":hp2.Recherche:ehp2.".
:p.Vous verrez une liste de toutes les sections contenant ce mot, ou des
mots approchants, les rÇsultats les plus pertinents Çtant en haut de la
liste. La meilleure correspondance sera automatiquement affichÇe.
:p.Les mots qui correspondent Ö votre recherche sont mis en
surbrillance dans la section.
:p.:hp2.Recherche globale:ehp2.
:p.Vous pouvez aussi effectuer une recherche dans tous les fichiers d'aide
de votre systäme en utilisant la
:link reftype=hd refid='RechercheGlobale'.Recherche globale:elink. via
l'option ":hp2.Rechercher tous les fichiers d'aide:ehp2." dans le menu
":hp2.Outils:ehp2.".
:p.:hp2.Recherche de phrase:ehp2.
:p.Si vous voulez rechercher une phrase composÇe de plus d'un mot,
encadrez-la par des guillemets, par exemple "OS&slash.2 warp".
:p.:hp2.Fonction de correspondance:ehp2.
:p.&prodname. vous permet un contrìle plus fin sur la recherche.
:p.:hp2.&plus.:ehp2. prÇcise qu'un mot :hp2.doit:ehp2. correspondre
exactement dans la recherche.
:p.:hp2.&endash.:ehp2. prÇcise qu'un mot :hp2.ne:ehp2. doit :hp2.pas:ehp2.
forcÇment correspondre dans la recherche.
:p.&prodname. est toujours partial dans la correspondance des mots. Ceci
dit, si vous recherchez "cher", &prodname. vous trouvera aussi "chercher" et
"mÉcher". Toute fois, meilleure sera la correspondance, plus haut elle se
trouvera dans la liste.
:p.:hp2.Comment :ehp2.&prodname.:hp2. Çvalue-t-il ses rÇsultats ? :ehp2.
:p.&prodname. Çvalue les sujets correspondants avec divers moyens &colon.
:ul compact.
:li.une correspondance avec le mot entier,
:li.le nombre de mots correspondants dans une section,
:li.correspondances dans le titre,
:li.correspondances dans les entrÇes d'index.
:eul.
:p.
.**************************************************************************
.* SECTION : NOTES                                                        *
.**************************************************************************
:h2 res=7 id='Notes'.Notes
:p.:hp2.Ajout et utilisation de notes:ehp2.
:p.:artwork align=center name='notestab.bmp'.
:p.&prodname. vous permet de placer des notes dans vos fichiers d'aide.
:p.Pour ajouter une note, cliquez simplement Ö l'endroit oó vous voulez
placer une note, cliquez sur le bouton ":hp2.Note:ehp2."
:artwork runin name='..\images\note.bmp'.&comma. puis tapez votre texte et
appuyez sur la touche ":hp2.EntrÇe:ehp2."&per. Le texte sera insÇrÇ dans
la section de l'aide avec une couleur diffÇrente &lpar.verte par
dÇfaut &semi. vous pouvez la changer sur l'onglet ":hp2.Couleurs:ehp2."
des ":hp2.Options:ehp2." du menu ":hp2.Outils:ehp2."&rpar.&per.
:p.Pour Çditer ou supprimer une note, cliquez sur le texte colorÇ de la
note &semi. vous pouvez alors Çditer le texte de cette note, ou cliquer
sur ":hp2.Supprimer:ehp2." pour vous en dÇbarrasser.
:p.Vous pouvez aussi voir toutes les notes que vous avez faites dans
le(s) fichier(s) d'aide en allant sur l'onglet ":hp2.Notes:ehp2." &semi. il
vous permet d'en ajouter, Çditer et supprimer, ainsi que de vous rendre Ö
la section correspondant Ö votre note.
:p.Les notes sont sauvegardÇes dans un fichier portant l'extension
&per.NTE, situÇ dans le màme rÇpertoire que le fichier d'aide auquel elles
se rapportent.
:note.si un fichier d'aide est modifiÇ &lpar.par exemple si un programme
est mis Ö jour&rpar. les notes n'apparaåtront alors plus au bon
endroit &semi. cependant, vous pourrez toujours les consulter dans
l'onglet :hp2.Notes:ehp2.&per.
:p.
.**************************************************************************
.* SECTION : GLOBAL SEARCH                                                *
.**************************************************************************
:h1 res=18 id='RechercheGlobale'.Recherche globale
:p.:hp2.Recherche globale:ehp2.
:p.Vous pouvez effectuer une recherche dans tous les fichiers de votre
systäme en cliquant sur le bouton ":hp2.Recherche globale:ehp2."
:artwork runin name='..\images\search.bmp'.&comma. en utilisant l'option
":hp2.Rechercher tous les fichiers d'aide...:ehp2." du menu
":hp2.Outils:ehp2." ou via la combinaison de touches
:hp2.Ctrl:ehp2.&plus.:hp2.S:ehp2.&per.
:p.Cette recherche fonctionne de la màme maniäre que la
:link reftype=hd refid='Recherche'.recherche normale:elink.&comma. mais
elle vous dit en plus dans quel fichier d'aide les rÇsultats ont ÇtÇ
trouvÇs.
:p.Ces recherches peuvent prendre du temps en fonction de ce que vous
cherchez. Vous pouvez l'interrompre Ö n'importe quel moment.
:p.:hp2.Oó :ehp2.&prodname.:hp2. cherche-t-il  ? :ehp2.
:p.Par dÇfaut, la recherche des fichiers d'aide s'effectue dans les
chemins de recherche spÇcifiÇs dans les
:link reftype=hd refid='VariablesEnvironnement'.variables
d'environnement:elink. :hp2.BOOKSHELF:ehp2. et :hp2.HELP:ehp2.&per.
Vous pouvez choisir d'autres emplacements depuis la liste de sÇlection
dÇroulante, ou personnaliser la liste en cliquant sur le bouton
:hp2.SÇlection...:ehp2.&per.
:p.:hp2.Recherche dans &colon. chemins d'aide standards:ehp2.
C'est l'Çtendue de recherche par dÇfaut, et se fera selon les chemins
:hp2.BOOKSHELF:ehp2. et :hp2.HELP:ehp2. citÇs plus haut.
:p.En cliquant sur le bouton :hp2.SÇlection...:ehp2.&comma. vous aurez la
possibilitÇ de choisir quels seront les rÇpertoires des chemins de
recherche qui seront Ö utiliser. Cliquez sur chaque ÇlÇment de la liste
pour le sÇlectionner ou le dÇsÇlectionner. Apräs avoir fait votre
sÇlection, l'emplacement s'affichera comme :hp2.Chemins d'aide
sÇlectionnÇs:ehp2.&per.
:p.:hp2.Recherche dans &colon. toutes les unitÇs de disques:ehp2.
:p.Cette option permet d'effectuer une recherche sur toutes les unitÇs de
disques durs (non amovibles) de votre systäme. Vous pouvez lÖ encore
cliquer sur le bouton :hp2.SÇlection...:ehp2. pour faire votre sÇlection.
:p.La recherche dans les unitÇs permet certes de toucher tous les
fichiers d'aide, mais se rÇväle bien plus lente qu'une recherche uniqement
dans les chemins d'aide.
:p.:hp2.Recherche dans &colon. chemins d'aide sÇlectionnÇs:ehp2.
:p.Si vous avez dÇjÖ sÇlectionnÇ des chemins d'aide particuliers pour la
recherche, vous pouvez cliquer sur le bouton :hp2.SÇlection...:ehp2. pour
personnaliser Ö nouveau cette sÇlection.
:p.:hp2.Rechercher dans &colon. liste de rÇpertoires:ehp2.
:p.Dans la boåte de dialogue :hp2.SÇlection de rÇpertoires de
recherche:ehp2.&comma. cliquer sur le bouton :hp2.Ajouter...:ehp2. vous
permettra d'ajouter un ou plusieurs rÇpertoire Ö la liste de recherche.
:p.SÇlectionnez l'unitÇ et le rÇpertoire en utilisant la boåte de
contrìle qui apparaåt, puis cliquez sur le bouton :hp2.&lt. Ajouter:ehp2.
pour ajouter Ö la liste le rÇpertoire en cours de sÇlection. Activez
l'option :hp2.avec les sous-rÇpertoires:ehp2. si vous voulez que les
sous-rÇpertoire du rÇpertoire en cours de sÇlection soient aussi ajoutÇs
Ö la liste de recherche. Dans ce cas, ":hp2....:ehp2." s'affichera Ö la
fin du rÇpertoire.
:p.Apräs avoir ainsi ajoutÇ un dossier personnalisÇ, l'emplacement de
recherche affichera :hp2.liste de rÇpertoires:ehp2.
:note.si vous ajoutez un rÇpertoire personnalisÇ aux chemins d'aide
standards ou aux chemins d'aide sÇlectionnÇs, la liste deviendra alors
une liste personnalisÇe, et vous ne pourrez pas resÇlectionner les
chemins d'aide. Pour retourner aux chemins d'aide d'origine,
sÇlectionnez :hp2.chemins d'aide standards:ehp2. et cliquez sur le
bouton :hp2.SÇlection...:ehp2. Ö nouveau.
:p.:hp2.Rechercher dans &colon. entrer un emplacement:ehp2.
:p.Vous pouvez taper une unitÇ ou un rÇpertoire dans le champ d'entrÇe
:hp2.Rechercher dans:ehp2.&per. Ajoutez ":hp2....:ehp2." Ö la fin du
rÇpertoire si vous voulez inclure aussi les sous-rÇpertoires dans la
recherche.
:p.Exemple &colon.
:p.:hp2.Rechercher dans &colon. [E&colon.\MesDocuments\...]:ehp2.
:p.Lancera la recherche dans les fichiers d'aide dans
E&colon.\MesDocuments\ et ses sous-rÇpertoires.
:p.
.**************************************************************************
.* SECTION : BOOKMARKS                                                    *
.**************************************************************************
:h1 res=8 id='Signets'.Signets
:p.:hp2.Signets:ehp2.
:p.&prodname. vous permet de mettre en signet une section particuliäre du
fichier d'aide en cours. Cliquez simplement sur le bouton
":hp2.Signet:ehp2." :artwork runin name='..\images\bookmark.bmp'. pour ajouter la
section en cours Ö la liste des signets.
:p.Pour vous rendre Ö un signet, allez dans le menu ":hp2.Signets:ehp2."
et cliquez sur celui que vous voulez ouvrir.
:p.Vous pouvez voir ou supprimer tous vos signets en cliquant sur l'option
":hp2.êditer...:ehp2." du menu ":hp2.Signets:ehp2.". Cette fenàtre peut
rester ouverte pendant la consultation du fichier d'aide, de maniäre Ö
garder la liste des signets sous les yeux.
:p.
:note text='Remarques &colon.'.
:p.les signets de &prodname. se "souviennent" de toutes les fenàtres de
sections ouvertes s'il y en a plus d'une.
:p.Les signets sont sauvegardÇs dans un fichier portant l'extension
&per.BMK, situÇ dans le màme rÇpertoire que le fichier d'aide auquel ils
se rapportent.
:p.
.**************************************************************************
.* SECTION : INTERNET LINKS                                               *
.**************************************************************************
:h1 res=100 id='LiensInternet'.Liens vers Internet
:p.:hp2.Liens vers Internet:ehp2.
:p.Lorsque vous cliquez sur un lien vers une ressource Internet ("URL" ou
"Uniform Resource Locator") comme
http&colon.&slash.&slash.www&per.google&per.fr, &prodname. lance
votre navigateur par dÇfaut.
:p.Ce navigateur est indiquÇ dans les paramätres du systäme
d'exploitation, pas dans &prodname. lui-màme. Pour le configurer, vous
pouvez ouvrir un objet URL sur le bureau, Çditez le chemin et le nom
de fichier pour le navigateur dans l'onglet ":hp2.Afficheur:ehp2.", puis
cliquez sur le bouton ":hp2.Nouveau paramÇtrage:ehp2.". Autrement, vous
pouvez tÇlÇcharger l'utilitaire ConfigApps depuis Hobbes &colon.
http&colon.&slash.&slash.hobbes&per.nmsu&per.edu&slash.cgi-bin&slash.h-search?key=configapps
:p.Certains navigateurs peuvent aussi proposer de se paramÇtrer comme
navigateur par dÇfaut soit Ö l'installation, soit dans les prÇfÇrences.
:p.Les liens Mêl, FTP et vers les fora de discussion ("newsgroups") sont
aussi passÇs au navigateur. ∑ l'heure actuelle, il n'est pas possible de
choisir un programme diffÇrent pour chacun de ces liens.
:p.:hp2.Remarques pour les auteurs de fichiers d'aide:ehp2.
:p.Le programme View original ne "comprends" absolument rien aux URL ou
liens Mêl. La seule faáon de les implÇmenter Çtait de faire un appel Ö,
par exemple, "NETSCAPE.EXE" avec les paramätres adequats.
:p.&prodname. traduit les liens vers les programmes "NETSCAPE", "EXPLORE"
ou "MOZILLA" en un lien vers le navigateur par dÇfaut.
:p.Il autodÇtecte en outre les URL sous la forme &colon.
:ul compact.
:li.http&colon.&slash.&slash.x  https&colon.&slash.&slash.x
 ftp&colon.&slash.&slash.x
:li.mailto&colon.x  news&colon.x
:eul.
:p.Tout ce qui ressemble Ö un URL est aussi dÇtectÇ, màme sans le
prÇfixe de protocole &colon.
:ul compact.
:li.www&per.a&per.b &endash. Navigateur
:li.ftp&per.a&per.b &endash. lien ftp
:li.a&atsign.b&per.c &endash. lien Mêl
:eul.
:p.Oó a, b et c sont des chaånes alphanumÇriques quelconques.
:p.Vous n'avez rien besoin de faire pour que &prodname. les reconnaisse.
:p.
.**************************************************************************
.* SECTION : COMMANDLINE                                                  *
.**************************************************************************
:h1 res=9 id='LigneDeCommandes'.Paramätres de ligne de commandes
:p.:hp2.Paramätres de ligne de commandes:ehp2.
:p.Lorsque vous lancez &prodname. depuis la ligne de commandes, vous
pouvez lui fournir divers arguments. Aucun d'entre eux n'est requis.
:p.
:p.:hp2.:font facename='Courier' size=14x8.NewView &lbracket.options&rbracket. &lbracket.&lt.NomDeFichier&gt. &lbracket.&lt.Texte Ö rechercher&gt.&rbracket.&rbracket.:font facename='Default' size=0x0.:ehp2.
:p.Si &prodname. est installÇ en remplacement de View, la commande dÇbute
alors par :hp2.VIEW:ehp2. au lieu de :hp2.NEWVIEW:ehp2.&per.
:p.:link reftype=hd refid='ExempleLigneDeCde'.Exemples:elink.
:ul.
:li.:hp2.&lt.NomDeFichier&gt.:ehp2.
.br
Le fichier que &prodname. doit charger. Vous pouvez charger plusieurs
fichiers simultanÇment en sÇparant leurs noms par un
":hp2.&plus.:ehp2." &colon.
:hp2.NomDeFichier1&plus.NomDeFichier2&plus.&per.&per.&per.:ehp2.
:p.Si le chemin n'est pas indiquÇ, les fichiers seront alors recherchÇs
dans les chemins figurant dans les
:link reftype=hd refid='VariablesEnvironnement'.variables d'environnement
BOOKSHELF et HELP:elink.&per.
:li.:hp2.&lt.Texte Ö rechercher&gt.:ehp2.
.br
Recherche le texte donnÇ dans les titres des sections et les entrÇes
d'index. Cela :hp2.n:ehp2.'agit :hp2.pas:ehp2. comme une recherche
normale, pour garder la compatibilitÇ avec View. Pour effectuer la
recherche appropriÇe, utilisez l'option &slash.s &lpar.voir
ci-dessous&rpar.&per. Veuillez consulter
:link reftype=hd refid='RechSectionLigneDeCde'.Recherche de section en
ligne de commandes:elink.&per.
:eul.
:p.:hp2.Options:ehp2.
:ul.
:li.:hp2.&slash.s:ehp2.
.br
Apräs l'ouverture du fichier, une
:link reftype=hd refid='Recherche'.recherche:elink. normale du texte
donnÇ est effectuÇe.
.br
Exemple &colon.
:ul compact.
:li. pour rechercher le mot "copie" dans tout le document cmdref, vous
pouvez utiliser &colon.
.br
:hp2.:font facename='Courier' size=14x8.NewView &slash.s cmdref copie:font facename='Default' size=0x0.:ehp2.
:li.&prodname. est assez intellignet pour prendre en compte plusieurs
mots. Comme dans le
:link reftype=hd refid='Recherche'.panneau de navigation de recherche:elink.&comma.
il s'agit d'une recherche "OR" &colon.
Passez un nom de fichier d'aide particulier comme premier paramätre
si vous voulez qu'il soit ouvert avant que la recherche ne soit
lancÇe &colon.
.br
:hp2.:font facename='Courier' size=14x8.NewView &slash.s cmdref net access:font facename='Default' size=0x0.:ehp2.
:li.Pour effectuer une recherche "AND", placez la phrase Ö rechercher
entre guillemets &colon.
;br
:hp2.:font facename='Courier' size=14x8.NewView &slash.s cmdref "net access":font facename='Default' size=0x0.:ehp2.
:eul.
:li.:hp2.&slash.g:ehp2.
.br
Effectue une
:link reftype=hd refid='RechercheGlobale'.recherche globale:elink. pour
le texte donnÇ dans tous les fichiers d'aide de votre systäme.
.br
Exemple &colon.
:ul compact.
:li. pour rechercher le mot "copie" dans tous les fichiers d'aide,
utilisez &colon.
.br
:hp2.:font facename='Courier' size=14x8.NewView &slash.g copie:font facename='Default' size=0x0.:ehp2.
:li.Passez un nom de fichier d'aide particulier comme premier paramätre
si vous voulez qu'il soit ouvert avant que la recherche ne soit
lancÇe &colon.
.br
:hp2.:font facename='Courier' size=14x8.NewView &slash.g cmdref copie:font facename='Default' size=0x0.:ehp2.
:eul.
:li.:hp2.&slash.?:ehp2.&comma. :hp2.&slash.h:ehp2. ou :hp2.&slash.help:ehp2.
.br
Affichage de l'aide en ligne de commandes.
:eul.
:p.Voir aussi &colon.
:ul compact.
:li.:link reftype=hd refid='ParametresAvances'.Paramätres avancÇs:elink.
:eul.
:p.
.**************************************************************************
.* SECTION : COMMANDLINETOPICSEARCH                                       *
.**************************************************************************
:h2 res=13 id='RechSectionLigneDeCde'.Recherche de section en ligne de commandes
:p.:hp2.Recherche de section en ligne de commandes:ehp2.
:p.:hp2.:font facename='Courier' size=14x8.view &lt.NomDeFichier&gt. &lt.Section&gt.:font facename='Default' size=0x0.:ehp2.
:p.Le paramätre de recherche de section indiquÇ en ligne de commandes,
est calquÇ sur le comportement de l'ancien programme View.
:p.Le texte Ö l'intÇrieur des sections ne sera pas pris en compte, seuls
les titres et entrÇes d'index le seront. Cette recherche est moins utile
pour les humains, mais elle est utilisÇe par quelques programmes pour
rÇfÇrencer les sujets d'aide de maniäre prÇdictive.
:p.Vous pouvez utiliser ici plus d'un mot.
:p.La recherche se dÇroule ici de la sorte &colon.
:ul compact.
:li.le titre de section dÇbute par le texte recherchÇ,
:li.l'entrÇe d'index dÇbute par le texte recherchÇ,
:li.le titre de section contient le texte recherchÇ,
:li.l'entrÇe d'index contient le texte recherchÇ.
:eul.
:p.Les dÇveloppeurs devront s'assurer que le document attendu sera trouvÇ
si cette technique est utilisÇe pour identifier des sections en lanáant le
nouveau ou l'ancien afficheur.
:p.
.**************************************************************************
.* SECTION : ADVANCEDPARAMETERS                                           *
.**************************************************************************
:h2 res=14 id='ParametresAvances'.Paramätres avancÇs
:p.:hp2.Paramätres avancÇs:ehp2.
:p.Les paramätres de ligne de commandes suivants sont principalement
destinÇs aux dÇveloppeurs de logiciels, mais peuvent àtre utilisÇs pour
d'autres buts.
:p.:hp2.:font facename='Courier' size=14x8.&slash.lang&colon.&lt.langue&gt.:font facename='Default' size=0x0.:ehp2.
:p.Charge la langue indiquÇe. Se substitue Ö la valeur par dÇfaut,
choisie en fonction de la variable d'environnement :hp2.LANG:ehp2.&per.
Par exemple,
:font facename='Courier' size=14x8.newview cmdref &slash.lang&colon.fr:font facename='Default' size=0x0.
charge le franáais. Veuillez vous rÇfÇrer au fichier
:hp2.LisezMoi.txt:ehp2. pour plus d'informations.
:p.:hp2.:font facename='Courier' size=14x8.&slash.pos&colon.&lt.Gauche&gt.&comma.&lt.Droite&gt.&comma.&lt.Largeur&gt.&comma.&lt.Hauteur&gt.:font facename='Default' size=0x0.:ehp2.
:p.Paramätre la fenàtre principale du programme aux position et taille
donnÇes. Toutes les valeurs doivent àtre indiquÇes. Placez un
:hp2.P:ehp2. apräs un nombre pour indquer un pourcentage.
Par exemple &colon.
.br
:font facename='Courier' size=14x8.newview &slash.pos&colon.10P&comma.10P&comma.80P&comma.80P:font facename='Default' size=0x0.
.br
donne une fenàtre centrÇe dont la taille fait 80&percent.de celle de
l'Çcran.
:p.:hp2.:font facename='Courier' size=14x8.&slash.title&colon.&lt.Titre de fenàtre&gt.:font facename='Default' size=0x0.:ehp2.
:p.Indique le titre de la fenàtre de &prodname. qui prendra le texte
donnÇ, se substitutant Ö ce qui doit apparaåtre dans le fichier d'aide.
Le texte "Aide &endash.  " sera toujours insÇrÇ avant la chaåne de
caractäres donnÇe. ∑ moins que celle-ci elle-màme ne soit "Aide", auquel
cas, le titre deviendra simplement "Aide". Ceci pour àtre certain que les
fenàtres d'aide soient toujours reconnues comme telles dans la liste de
fenàtres.
:p.Si vous deviez indiquer plusieurs mots, encadrez l'option entiäre avec
des guillemets. Par exemple &colon.
.br
:hp2.:font facename='Courier' size=14x8.newview cmdref "&slash.title&colon.Introduction aux commandes OS&slash.2":font facename='Default' size=0x0.:ehp2.
:p.
.**************************************************************************
.* SECTION : COMMANDLINEEXAMPLES                                          *
.**************************************************************************
:h2 res=15 id='ExempleLigneDeCde'.Exemples de lignes de commandes
:p.:hp2.Exemples de lignes de commandes:ehp2.
:p.Les exemples suivants assument que &prodname. a ÇtÇ installÇ en
remplacement du programme View original, et que, par consÇquent, View est
en fait &prodname.&per.
:p.:hp2.:font facename='Courier' size=14x8.view cmdref:font facename='Default' size=0x0.:ehp2.
:p.Ouvre le fichier :hp2.CMDREF&per.INF:ehp2. &lpar.Manuel de rÇfÇrence
OS&slash.2 Warp&rpar. trouvÇ dans l'un des chemins spÇcifiÇs dans la
variable d'environnement :hp2.HELP:ehp2.&per.
:p.:hp2.:font facename='Courier' size=14x8.view cmdref&plus.os2ug:font facename='Default' size=0x0.:ehp2.
:p.Ouvre les deux fichiers :hp2.CMDREF&per.INF:ehp2. et
:hp2.OS2UG&per.INF:ehp2. &lpar.OS&slash.2 Warp - Guide
d'utilisation&rpar. dans la màme fenàtre.
:p.La table des matiäres de :hp2.OS2UG&per.INF:ehp2. est ajoutÇe Ö la fin
de celle de :hp2.CMDREF&per.INF:ehp2.&per. Les index sont combinÇs
alphabÇtiquement.
:p.:hp2.:font facename='Courier' size=14x8.view c&colon.&bsl.os2&bsl.book&bsl.os2ug&per.inf:font facename='Default' size=0x0.:ehp2.
:p.Ouvre le fichier :hp2.OS2UG&per.INF:ehp2. pris dans le rÇpertoire
":hp2.c&colon.&bsl.os2&bsl.book:ehp2.".
:p.:hp2.:font facename='Courier' size=14x8.view "c&colon.&bsl.os2 book&bsl.os2ug&per.inf":font facename='Default' size=0x0.:ehp2.
:p.Encadrez le chemin d'accäs au fichier par des guillemets s'il contient
des caractäres spÇciaux (comme les espaces).
:p.:hp2.:font facename='Courier' size=14x8.view cmdref dir:font facename='Default' size=0x0.:ehp2.
:p.Ouvre le fichier :hp2.CMDREF:ehp2. &lpar.Manuel de rÇfÇrence OS&slash.2
Warp&rpar. et recherche le mot "dir" dans les titres et les index, pour
afficher la page d'aide de la commande DIR.
:p.:hp2.:font facename='Courier' size=14x8.view &slash.s&colon.os2ug bureau:font facename='Default' size=0x0.:ehp2.
:p.Ouvre le fichier :hp2.OS2UG&per.INF:ehp2. et recherche le mot
"Bureau". La meilleure correspondance sera affichÇe.
:p.:hp2.:font facename='Courier' size=14x8.view &slash.g&colon.permissions:font facename='Default' size=0x0.:ehp2.
:p.Effectue une recherche du mot "permissions" dans tous les fichiers
d'aide.
:p.:hp2.:font facename='Courier' size=14x8.set mon_aide&eq.cmdref&plus.os2ug&plus.rexx:font facename='Default' size=0x0.:ehp2.
:p.:hp2.:font facename='Courier' size=14x8.view mon_aide:font facename='Default' size=0x0.:ehp2.
:p.La premiäre ligne dÇfinit une variable d'environnement
:hp2.MON_AIDE:ehp2. qui contient les noms de trois fichiers d'aide. La
seconde ligne ouvre ces trois fichiers.
:p.
.**************************************************************************
.* SECTION : KEYBOARDSHORTCUTS                                            *
.**************************************************************************
:h1 res=10 id='KeyboardShortcuts'.Touches de raccourcis
:p.:hp2.Touches de raccourcis:ehp2.
:p.La plupart des touches de raccourcis clavier sont affichÇes dans les
menus, mais certaines ne le sont pas.
:p.:hp2.Les touches de raccourcis supplÇmentaires sont &colon.:ehp2.
:p.:hp2.Alt&plus.F4:ehp2. &endash. Sortie du programme
:p.:hp2.Ctrl&plus.C:ehp2. &endash. Copie du texte sÇlectionnÇ dans le
presse-papiers
:p.:hp2.F7:ehp2. &endash. En arriäre
:p.:hp2.F8:ehp2. &endash. En avant
:p.:hp2.Ctrl&plus.Gauche:ehp2. &endash. En arriäre
:p.:hp2.F11:ehp2. &endash. Section prÇcÇdente dans la table des matiäres
:p.:hp2.F12:ehp2. &endash. Section suivante dans la table des matiäres
:p.
:p.:hp2.Les touches de raccourcis visibles dans le menu &colon.:ehp2.
:p.:hp2.Ctrl&plus.O:ehp2. &endash. Ouverture de fichiers
:p.:hp2.Ctrl&plus.E:ehp2. &endash. Ouverture des fichiers dans les
chemins d'aide
:p.:hp2.Ctrl&plus.N:ehp2. &endash. Ouverture d'une nouvelle fenàtre
:p.:hp2.Ctrl&plus.P:ehp2. &endash. Impression de la section
:p.:hp2.F3:ehp2. &endash. Sortie du programme
:p.
:p.
:p.:hp2.Ctrl&plus.A:ehp2. &endash. SÇlection de tout le texte dans la
section
:p.:hp2.Ctrl&plus.Inser:ehp2. &endash. Copie du texte sÇlectionnÇ dans le
presse-papiers
:p.
:p.:hp2.Ctrl&plus.F:ehp2. &endash. Recherche dans la section en cours
:p.:hp2.Ctrl&plus.G:ehp2. &endash. Continuer la derniäre recherche
:p.
:p.:hp2.Ctrl&plus.S:ehp2. &endash. Ouverture de l'outil de recherche
globale
:p.
:p.:hp2.Alt&plus.C:ehp2. &endash. Ouverture de l'onglet Contenu
:p.:hp2.Alt&plus.I:ehp2. &endash. Ouverture de l'onglet Index
:p.:hp2.Alt&plus.S:ehp2. &endash. Ouverture de l'onglet Recherche
:p.:hp2.Alt&plus.N:ehp2. &endash. Ouverture de l'onglet Notes
:p.:hp2.Alt&plus.P:ehp2. &endash. Activation&slash.dÇsactivation du
panneau de gauche &lpar.onglets&rpar.
:p.:hp2.F5:ehp2. &endash. DÇroulement de toute l'arborescence du contenu
:p.:hp2.F6:ehp2. &endash. Enroulement de toute l'arborescence du contenu
:p.
:p.:hp2.êchap:ehp2. &endash. En arriäre
:p.:hp2.Ctrl&plus.Droite:ehp2. &endash. En avant
:p.:hp2.Ctrl&plus.Haut:ehp2. &endash. Section prÇcÇdente dans la table des
matiäres
:p.:hp2.Ctrl&plus.Bas:ehp2. &endash. Section suivante dans la table des
matiäres
:p.
:p.:hp2.Ctrl&plus.D:ehp2. &endash. êdition des signets
:p.:hp2.Ctrl&plus.B:ehp2. &endash. Mise en signets de la section en cours
:p.
:p.:hp2.Ctrl&plus.M:ehp2. &endash. Ajout d'une note Ö la position du
curseur
:p.
:p.:hp2.F1:ehp2. &endash. Affichage de l'aide de &prodname.
:p.
.**************************************************************************
.* SECTION : L_ENVIRONMENTVARIABLES                                       *
.**************************************************************************
:h1 res=11 id='VariablesEnvironnement'.Variables d'environnement
:p.:hp2.Variables d'environnement:ehp2.
:p.
:p.Les deux variables d'environnement :hp2.BOOKSHELF:ehp2. et
:hp2.HELP:ehp2. dÇfinissent les chemins &lpar.liste de rÇpertoires&rpar.
pour la recherche de fichiers d'aide. &prodname. les utilise sans
distinction.
:p.Ces chemins sont utilisÇs lorsque vous &colon.
:ul compact.
:li.spÇcifiez un fichier d'aide sans chemin d'accäs comme argument en
ligne de commandes,
:li.utilisez l'option ":hp2.Ouvrir avec paramätres...:ehp2." du menu
":hp2.Fichier:ehp2.",
:li.effectuez une :link reftype=hd refid='RechercheGlobale'.recherche
globale:elink.&per.
:eul.
:p.Vous pouvez ajouter des rÇpertoires de fichiers d'aide de faáon
permanente aux chemins des variables d'environnement :hp2.HELP:ehp2. ou
:hp2.BOOKSHELF:ehp2. en modifiant le fichier
:hp2.CONFIG&per.SYS:ehp2.&per. Ajoutez-les aux deux si vous voulez aussi
que l'ancien programme View soit capable de trouver les fichiers.
:p.:hp2.Autres variables d'environnement:ehp2.
:p.La variable d'environnement :hp2.LANG:ehp2. est analysÇe pour dÇcider
quelle la langue par dÇfaut &prodname. doit adopter (redÇfinie par le
:link reftype=hd refid='ParametresAvances'.paramätre de ligne de
commandes &slash.lang:elink.&rpar.&per. Veuillez consulter le fichier
:hp2.LisezMoi.txt:ehp2. de &prodname. pour plus d'informations sur le
support multilingue.
:p.Le rÇpertoire dÇfini dans :hp2.LOGFILES:ehp2. est utilisÇ pour les
rapports d'erreurs (de plantages) ou d'autres informations.
:p.Le sous-rÇpertoire "lang" du rÇpertoire dÇfini par :hp2.OSDIR:ehp2. est
utilisÇ pour la recherche de fichiers de langues au dÇmarrage.
:p.Le chemin :hp2.ULSPATH:ehp2. est lui aussi utilisÇ pour la recherche
des fichiers de langue.
:p.
.**************************************************************************
.* SECTION : FORAUTHORS                                                   *
.**************************************************************************
:h1 res=20 id='PourLesAuteurs'.Notes pour les auteurs et dÇveloppeurs
:p.:hp2.Notes pour les auteurs et dÇveloppeurs:ehp2.
:p.
:p.Cette section rassemble quelques informations destinÇes aux auteurs et
dÇveloppeurs de logiciels.
:p.Voir aussi la section traitant de la reconnaissance des URL &colon.
:ul compact.
:li.:link reftype=hd refid='LiensInternet'.Liens vers internet:elink.&per.
:eul.
:p.
.**************************************************************************
.* SECTION : WRITINGHELPFILES                                             *
.**************************************************************************
:h2 res=12 id='CreerFichierAide'.CrÇation de fichiers d'aide
:p.:hp2.CrÇation de fichiers d'aide OS&slash.2:ehp2.
:p.
:p.Les fichiers d'aide d'OS&slash.2 sont crÇÇs Ö l'aide d'un compilateur
d'IPF &colon. IFP Compiler. IPF signifie "Information Presentation
Facility" (service pour la prÇsentation de l'information).
:p.Le compålateur IPF prend en entrÇe un fichier texte Çcrit dans un
langage prenant en compte des tas de choses comme les entàtes, les liens,
le texte et les images, et produit - en sortie, donc - un fichier &per.INF
ou &per.HLP.
:p.La maniäre officielle d'obtenir le compilateur IPF
&lpar.IPFC&per.EXE&rpar. est d'acquÇrir le Kit de dÇveloppement pour
OS&slash.2 (ou "OS&slash.2 Developers Toolkit"). Il est fourni
gratuitement avec eComStation
&lpar.http&colon.&slash.&slash.www&per.ecomstation&per.com&rpar.&per.
:p.Comme le langage pour IPFC est relativement pÇnible &lpar.la
ponctuation, par exemple, devrait àtre remplacÇe par des mots-clÇs
spÇciaux comme "&amp.comma&per." pour la virgule&rpar.&comma. pas mal de
personnes utilisent des outils en plus du compilateur IPF lui-màme.
:p.Un outil graphique et simple qu'on peut utiliser est Vyperhelp
&lpar.http&colon.&slash.&slash.www&per.vyperhelp&per.com&rpar.&per.
Il peut en outre gÇnÇrer de l'aide Windows, du HTML et autres, bien qu'il
ne tourne que sous OS&slash.2 (ou eComStation). Il n'est pas gratuit.
:p.Les autres options &colon.
:ul compact.
:li.Le prÇprocesseur IPF HyperText&slash.2
&lpar.http&colon.&slash.&slash.www&per.clanganke&per.de&slash.os2&slash.sw&slash.htext&slash.&rpar.
prÇpare et gÇnäre du format IPF plus compliquÇ Ö partir d'un langage plus
simple. Gratuit.
:li.HyperMake &lpar.http&colon.&slash.&slash.www&per.hypermake&per.com&rpar.
agit de la màme maniäre que le prÇcÇdent, mais peut gÇnÇrer de l'aide
Windows et du HTML.
:li.Sibyl &lpar.Ö l'aide duquel &prodname. a ÇtÇ crÇÇ&rpar. fournit un
prÇprocesseur IPF.
:li.IPFEditor de PCS
&lpar.http&colon.&slash.&slash.www&per.pcs&endash.soft&per.com&slash.productipfe212&per.htm&rpar.
probablement le plus complet, mais avec un coñt significatif.
:warning.&prodname. ne prend pas en charge tout ce que IPFE peut faire &xclm.
:eul.
:p.Dans le passÇ, il y avait d'autres solutions. Celles listÇes devraient
toujours àtre disponibles et àtre supportÇes.
:p.
.**************************************************************************
.* SECTION : TOPICRESOURCEIDS                                             *
.**************************************************************************
:h2 res=16 id='IDRessourceSection'.Identifiants de ressource des sections
:p.:hp2.Identifiants de ressource des sections:ehp2.
:p.Identifiants de ressource &lpar."Resource IDs"&rpar. sont utilisÇs par
les auteurs pour l'aide en ligne des applications, pour identifier une
section d'aide. Les applications appellent le gestionnaire d'aide en
spÇcifiant un identifiant de ressource, soit directement, soit
indirectement via des tables d'aide ajoutÇes aux ressources, ce que le
Gestionnaire de PrÇsentation &lpar."Presentation Manager" ou "PM"&rpar.
gäre automatiquement. Les identifiants de ressource sont stockÇs dans
une table Ö l'intÇrieur du fichier d'aide.
:p.Aux auteurs de documents, &prodname. offre la possibilitÇ de voir
et rechercher les identifiants de ressource.
:p.:hp2.Recherche par identifiants de ressource:ehp2.
:p.Utiliser l'option ":hp2.Rechercher section par son ID:ehp2." du
menu ":hp2.Outils:ehp2." pour rechercher un identifiant de ressource
indiquÇ dans tous les fichiers ouverts.
:p.:hp2.Affichage des identifiants de ressource:ehp2.
:p.Ouvrez les propriÇtÇs de la section &lpar.clic sur le bouton droit de
la souris sur le contenu de la section en cours &endash.
":hp2.PropriÇtÇs:ehp2."&rpar. pour voir le(s) identifiant(s) de ressource
associÇ(s) Ö cette section.
:p.
.**************************************************************************
.* SECTION : TOPICRESOURCEIDS                                             *
.**************************************************************************
:h2 res=19 id='NomsSection'.Noms de sections
:p.:hp2.Noms de sections:ehp2.
:p.
:p.Comme les identifiants de ressource, les noms de section peuvent àtre
utilisÇs par les dÇveloppeurs pour faire des liens vers les sections
d'aide depuis leur application, en utilisant le HM&us.DISPLAY&us.HELP avec
HM&us.PANELNAME paramätre 2.
:p.Ils ne sont pas utilisÇs si souvent.
:p.&prodname. peut trouver un nom de section particulier en utilisant
l'option ":hp2.Rechercher section par son nom:ehp2." du menu
":hp2.Outils:ehp2."&per.
:p.
:euserdoc.
