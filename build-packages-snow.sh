#! /bin/sh
################################################################################
# List of Variables
#      DIRECTORYNAME  : Source Code directory.
#      BINPACKAGENAME : Name of the package that will contain the binary files.
#                       In order to create that package, you have to put "s" in
#                       the array PACKAGETYPE (see below).
#      LIBPACKAGENAME : Name of the package that will contain the library files.
#                       In order to create that package, you have to put "l" in
#                       the array PACKAGETYPE (see below).
#      VERSION        : Current version of the program.
#      COPYRIGHT      : Is one of the following :
#                       gpl,gpl2,gpl3,lgpl,lgpl2,lgpl3, artistic, apache, bsd or
#                       mit
#      BINARYNAMES    : Name of the binary files you want to include in the  
#                       binary package.
#      LIBNAMES       : Name of the libraries you want to include in the 
#                       library package.
#      HEADERNAMES    : Name of the headers you want to include in the library 
#                       package
#      PACKAGETYPE    : String that contains the type of packages you want to 
#                       create. You have to separate each type with a space. 
#                       Here are the type of packages you can create with this
#                       script :
#                            -Put "l" in the string if you want to create a 
#                             library package 
#                            -Put "s" in the string if you want to create a 
#                             package that will contain binary files.
#      BINPACKAGEDESC : Path of the file containing the description of 
#                       the package. It must be in the following format : the 
#                       first line contains a short description of the package
#                       (up to 60 chars), and the rest of the file contains a
#                       long description of the package (no limit).
#      LIBPACKAGEDESC : Path of the file which contains the description of the 
#                       library packages. It must follow the rules that are
#                       described below :
#                           The first line is a short description of the package
#                       that will contain the libraries (without the headers).
#                           After that line, you can put the long description
#                       of the package (no limit).
#                           After those descriptions, YOU HAVE TO PUT A BLANK
#                       LINE. 
#                           After that blank line, you have to put the short
#                       description of the package dedicated to the devellopers
#                       (i.e. the package that will contain the header files).
#                       That line must be shorter than 60 chars. After that line
#                       you can put a long description of the package.
#      HOMEPAGE       : Homepage of the thing you're going to package.
#      LOGFILE        : File that will contain the errors/warnings of the
#                       build of the package
#                       
#      DEBEMAIL       : Email of the package maintainer
#      DEBFULLNAME    : Name of the package maintainer

DIRECTORYNAME="libsnow-1.4.2";
BINPACKAGENAME=snow;
LIBPACKAGENAME=libsnow;
VERSION=1.4.2;
COPYRIGHT=gpl;
BINARYNAMES="lib/cami2gspn lib/cami2smart lib/snow";
LIBNAMES="lib/libPNet.a";
HEADERNAMES="lib/FuncParser.h lib/GguardParser.h lib/GcolParser.h lib/GmarkParser.h lib/MarkParser.h lib/GfuncParser.h lib/GuardParser.h lib/tobsParser.h interfaces/*.h";
PACKAGETYPE="s l";
BINPACKAGEDESCFILE="";
LIBPACKAGEDESCFILE="";
HOMEPAGE="";
LOGFILE="";
DEBEMAIL="maxime.bittan@gmail.com";
DEBFULLNAME="Maxime Bittan";
export DEBEMAIL; export DEBFULLNAME;
export HOMEPAGE; export LOGFILE;
export BINPACKAGEDESCFILE; export LIBPACKAGEDESCFILE;
################################################################################

#Create Makefile
cd $DIRECTORYNAME && autoreconf -vfi && ./configure;
rm -f config.status config.log;
cd ..;

#Create TARBALLs
for var in $PACKAGETYPE; do
#Check if user want to build a library package
    if [ $var = "l" ]
    then
	LIBTARBALL="$LIBPACKAGENAME""_$VERSION.orig.tar.gz";
	tar czf "$LIBTARBALL" $DIRECTORYNAME;
    fi
#Check if user want to build a binary package
    if [ $var = "s" ]
    then
	BINTARBALL="$BINPACKAGENAME""_$VERSION.orig.tar.gz";
	tar czf "$BINTARBALL" $DIRECTORYNAME;
    fi
done;

if [ ! -z $BINTARBALL ] && [ ! -z $LIBTARBALL ]
then
#Creation of the debian packaging files
    cd $DIRECTORYNAME;
    env echo -e -n "\n" > tmpfile
    rm -rf debian/
    dh_make -l -c $COPYRIGHT -p "$LIBPACKAGENAME""_$VERSION" < tmpfile
    rm -f tmpfile
    
#Removing packaging version
    perl -pi -e 's/\(((\d+\.?)+)-\d+\)/($1)/' debian/changelog

#Removing useless generated files
    rm -rf debian/*.EX debian/*.ex debian/README*
#Renaming files correctly
    mv debian/"$LIBPACKAGENAME"1.dirs debian/"$LIBPACKAGENAME".dirs
    mv debian/"$LIBPACKAGENAME"1.install debian/"$LIBPACKAGENAME".install
    sed -i -r -e s/"$LIBPACKAGENAME"BROKEN/"$LIBPACKAGENAME"/g debian/control

#Creating correct *.install/*.dirs files
    rm -f debian/$LIBPACKAGENAME.install
    for library in $LIBNAMES
    do
	echo "$library usr/lib" >> debian/$LIBPACKAGENAME.install
    done;

    rm -f debian/$LIBPACKAGENAME-dev.install;
    for header in $HEADERNAMES
    do
	echo "$header usr/include/" >> debian/$LIBPACKAGENAME-dev.install
    done;

    for binary in $BINARYNAMES
    do
	echo "$binary usr/bin" >> debian/$BINPACKAGENAME.install
    done;
    echo "usr/bin" >> debian/$BINPACKAGENAME.dirs

#Adding binary package to control file
    env echo -e -n "\n" >> debian/control
    echo "Package: $BINPACKAGENAME" >> debian/control
    echo "Architecture: any" >> debian/control
    echo 'Depends: ${shlibs:Depends}, ${misc:Depends}' >> debian/control
    echo 'Description: <insert up to 60 chars description>' >> debian/control
    echo ' <insert long description, indented with spaces>' >> debian/control

#Fixing generated files
    debuild -S -uc -us
    ../correct_lintian.pl  ../"$BINPACKAGENAME""_$VERSION-1_source.build"
   
#Build package
    debuild -us -uc;

#Clean-up
    #rm -rf debian/ && cd ..;
    cd ..
    rm -f "$BINTARBALL" "$LIBTARBALL";
    rm -f "$LIBPACKAGENAME""_$VERSION.debian.tar.gz";
    rm -f "$LIBPACKAGENAME""_$VERSION.dsc";
    rm -f *.build *.changes;
elif [ ! -z $BINTARBALL ] 
then

echo toto;
fi
