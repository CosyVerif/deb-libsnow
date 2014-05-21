#!/usr/bin/perl

# call me from interfaces directory

use Getopt::Std;

use strict 'vars';   # After obtaining $opt_t, which is not a local variable

my $INPUTDIR = "../sources";

opendir DIRHANDLE , $INPUTDIR ;
while (my $ff = readdir DIRHANDLE) {
  if ($ff =~ /(.+)\.cpp/ )
    {
      my $name = $1;
      print STDERR "working on file $ff\n";
      system ("touch $name.h");
    }
}
closedir DIRHANDLE;
