#!/usr/bin/perl

# call me from project root directory

use Getopt::Std;

use strict 'vars';   # After obtaining $opt_t, which is not a local variable

my $INPUTDIR = "./sources";

opendir DIRHANDLE , $INPUTDIR ;
open OUT, "> ./scripts/classes.txt";
select OUT;
while (my $ff = readdir DIRHANDLE) {
  if ($ff =~ /(.+)\.cpp/ )
    {
      my $name = $1;
      print STDERR "adding class $name\n";
      print "$name\n";
    }
}
close OUT;
closedir DIRHANDLE;
