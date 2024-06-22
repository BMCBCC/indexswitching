#! /usr/bin/perl -w
use strict;

if (@ARGV != 2) {
    die "\nUsage: <infile> <outfile>\n\n";
}

my $infile = shift;
my $outfile = shift;

open (INSTREAM, $infile) or die "Couldn't open file: $infile\n";
open (OUT, ">$outfile") or die "can not open file: $outfile\n";

my $n=0;
my $current_line = "";
my @s="";
my @s1="";

while ($current_line = <INSTREAM>) {
	chomp ($current_line);
	$n++;
	if ($n%4==1 && $current_line=~/^\@/) {
		@s=split(/\s+/, $current_line);
		if ($s[1]=~/\+/) {
			@s1=split(/\:/, $s[1]);
			if ($s1[@s1-1]=~/(\S+)\+(\S+)/){
				print OUT "$1\t$2\n";
			}
		}
		else {
			@s1=split(/\:/, $s[0]);
			if ($s1[@s1-1]=~/(\S+)\+(\S+)/){
				print OUT "$1\t$2\n";
			}
		}
	}
}
