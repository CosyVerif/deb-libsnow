#!/bin/bash

# Variables
PACKAGENAME=libsnow
VERSION=1.4.2
SRCDIR="$PACKAGENAME-$VERSION"
TARBALL="$PACKAGENAME""_$VERSION"
DEBTYPE=l
MAIL=redha.gouicem@gmail.com
URL='http://www.ljdfd.fr/testpag.html'
#LICENCE=-c gpl;
INCLUDEFILES="lib/*.h"
LIBFILES="lib/libPNet.a"
SHORTDESC="short description blalala"
LONGDESC=" long descritpion blablanazjnqsoncqslcqpsfjdbfdcdjvns lq qs q qs qiqs,klcl nfiqd qc,qsin qi ncqcdn snv iqj q cqn"

echo "!!!!!!!!!!!!!!!!!!!!!!       VARS !     !!!!!!!!!!!!!!!!!!!!!!!!!";
echo "srcdir = $SRCDIR";
echo "tarball = $PACKAGENAME""_$VERSION"

# cleaning
rm -rf $SRCDIR/debian;
rm -rf *.gz *.build *.changes *.dsc;

#tarball creation
cd $SRCDIR && autoreconf -i && ./configure && cd ..;
tar czfv $TARBALL.orig.tar.gz $SRCDIR;

#creation of configuration files for debian packaging (and some cleaning)
cd $SRCDIR && dh_make -$DEBTYPE -e $MAIL $LICENCE -y;
cd debian && rm -rf *.ex *.EX README*;
mv "$PACKAGENAME"1.dirs $PACKAGENAME.dirs;
mv "$PACKAGENAME"1.install $PACKAGENAME.install;

sed -i -r -e s/"$PACKAGENAME"BROKEN/"$PACKAGENAME"/g control


> $PACKAGENAME.install
for i in $LIBFILES; do
    echo "$i usr/lib" >> $PACKAGENAME.install;
done;
> $PACKAGENAME-dev.install
for i in $INCLUDEFILES; do
    echo "$i usr/include/" >> $PACKAGENAME-dev.install;
done;

cd .. && debuild -us -uc;
