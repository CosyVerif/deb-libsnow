#!/usr/bin/perl

# call me from project root directory i.e. where ./sources/ and ./interfaces/ are located

use Getopt::Std;

use strict 'vars';   # After obtaining $opt_t, which is not a local variable



open IN, "< ./scripts/classes.txt";
while (my $name = <IN>) {
  chomp $name;
  my $ff ="./interfaces/$name.h";
  print STDERR "working on file $ff\n";
  open OUT, ">$ff";
  select OUT;
  print "#ifndef _".uc($name)."_H_\n";
  print "#define _".uc($name)."_H_\n";
  print "#include <iostream>\n";
  print "#include <function.h>\n";
  print "\n\/\/Declaration header file for class $name";
  print "\n\n\nclass $name \{";
  print "\nprotected:\n";
  print "\npublic:\n";
  print "  \/\/ *******************Constructor/destructor \n";
  print "  \/\/default constructor\n  $name ();\n";
  print "  \/\/constructor by copy\n  $name (const $name&);\n";
  print "  \/\/default destructor\n  virtual ~$name ();\n\n";
  print "  \/\/ *******************basic operators\n";
  print "  \/\/ clone by operator=\n  $name& operator=(const $name&);\n";
  print "  \/\/ comparison by operator==\n";  # friend int operator==(const $name&,const $name&);\n";
  print "  int operator==(const $name&);\n";
#  print "  \/\/ comparison by operator<\n  int operator<(const $name&);\n";
#  print "  friend int operator<(const $name&,const $name&);\n";
  print "  \/\/printing with operator<<\n  friend ostream& operator<<(ostream&,const $name&);\n";
  print "\};\n";
  print "#endif\n\n";
  close OUT;

  my $ff ="./sources/$name.cpp";
  print STDERR "working on file $ff\n";

  open OUT, "> $ff";
  $name=~ /(\w).+/;
  my $id = lc $1;
  print "#include \"$name.h\"\n";
  print "\n\/\/Implementation for class $name";
  print "\n\/\/default constructor\n$name\:\:$name () \{\n\n\}\n";
  print "\/\/constructor by copy\n$name\:\:$name (const $name& $id)\{\n\n\}\n\n";
  print "\/\/default destructor\n$name\:\:~$name ()\{\}\n\n";
  print "\/\/ *******************basic operators\n\n";
  print "\/\/ clone by operator=\n$name& $name\:\:operator=(const $name& $id)\{\n  if (this != &$id) \{\n\n\n  \}\n  return *this;\n\}\n\n";
  print "\/\/ comparison by operator==\n"; # int operator==(const $name& a,const $name& b)\{\n\n\}\n\n";
  print "int $name::operator==(const $name& $id)\{\n\n\}\n\n";
#  print "\/\/ comparison by operator<\nint operator<(const $name& a,const $name& b)\{\n\n\}\n\n";
#  print "int $name::operator<(const $name& $id)\{\n\n\}\n\n";
  print "\/\/ printing with operator<<\nostream& operator<<(ostream& os,const $name& $id)\{\n\n  return os;\n\}\n\n";
  close OUT;
}
close IN;
