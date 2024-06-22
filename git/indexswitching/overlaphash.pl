#! /usr/bin/perl -w
use strict;


if (@ARGV != 3) {
    die "\nUsage: <infile> <outfile>\n\n";
}

my $infile = shift;
my $infile1 = shift;
my $outfile = shift;

open (INSTREAM, $infile) or die "Couldn't open file: $infile\n";
open (INSTREAM1, $infile1) or die "Couldn't open file: $infile1\n";
open (OUT, ">$outfile") or die "can not open file: $outfile\n";

my $index=0;
my $current_line = "";
my $current_line1 = "";
my @s="";
my @s1="";
my %dic=();
while ($current_line1 = <INSTREAM1>) {
	chomp ($current_line1);
	@s1=split(/\t+/, $current_line1);
	my $pos=uc $s1[0];
	$dic{$pos} = $current_line1;
}

while ($current_line = <INSTREAM>) {
	chomp ($current_line);
	@s=split(/\t+/, $current_line);
	my $index=uc $s[0];
	if (exists $dic{"$index"}) {
		print OUT "$current_line\n";
	}
}
