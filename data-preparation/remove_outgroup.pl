#!/usr/bin/perl -w

use strict;
my $usage = "It removes outgroup sequences from a fasta set\n\n./remove_outgroup.pl -in <FASTA> -outgroup <regular expression>\n\n";

if($#ARGV < 0){ die $usage; }

my $infile = "";
my $outgroup = "";
while(my $args = shift @ARGV){
    if($args =~ /^-in$/i){ $infile = shift @ARGV; next; }
    if($args =~ /^-outgroup/i){ $outgroup = shift @ARGV; next; }
    die "Argument $args is invalid\n";
}

open(IN, $infile) or die "Coudln't open $infile for input\n";

my $cnt = 0;
my $cntrem = 0;
while( defined(my $ln=<IN>)){
    if($ln =~ /^\s*$/){ next; }
    chomp($ln);

    if($ln =~ /^\s*>/ && $ln =~ /$outgroup/){
	$cntrem++;
	while( defined(my $ln=<IN>)){
	    if($ln =~ /^\s*$/){ next; }
	    chomp($ln);
	    if($ln =~ /^\s*>/){ last; }
	}
    }

    if($ln =~ /^\s*>/){
	$cnt++;
    }

    print $ln, "\n";
}

print STDERR "$cnt lines remained... $cntrem lines were removed\n";	
