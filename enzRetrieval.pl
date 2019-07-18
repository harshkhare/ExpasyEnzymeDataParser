#!usr/bin/perl
use strict;

#main

my(@enzyme,$line,$EC,$name,%enz,@EC,$cofactor,$outFile);
my($c,$sc,$ssc,$en);

open(IN,"enzyme.dat")||die"Can not open IN.\n";
@enzyme = <IN>;
close(IN);

#build enzyme information hash, %enz
foreach $line(@enzyme)
{
	if($line=~m/^ID\s+(\d+)\.(\d+)\.(\d+)\.(\d+)/)
	{
		$c = $1; $sc = $2; $ssc = $3; $en = $4;
	}

	if($line=~m/^DE\s\s(.*\n)/)
	{
		${${${${$enz{$c}}{$sc}}{$ssc}}{$en}}{"DE"} .= $1;
	}
	
	if($line=~m/^AN\s\s(.*\n)/)
	{
		${${${${$enz{$c}}{$sc}}{$ssc}}{$en}}{"AN"} .= $1;
	}
	
	if($line=~m/^CA\s\s(.*\n)/)
	{
		${${${${$enz{$c}}{$sc}}{$ssc}}{$en}}{"CA"} .= $1;
	}
	
	if($line=~m/^CF\s\s(.*\n)/)
	{
		${${${${$enz{$c}}{$sc}}{$ssc}}{$en}}{"CF"} .= $1;
	}

}

#user input
print "(for all the fields, press return/enter if not known)\n\n";
print "Entre EC No.:\t"; $EC = <STDIN>;
print "Entre name of enzyme:\t"; $name = <STDIN>;
print "Entre cofactor:\t"; $cofactor = <STDIN>;
print "Entre output file path(default - \\enzRetrievalOut.txt):"; $outFile = <STDIN>;

#print %{${${${$enz{$EC[0]}}{$EC[1]}}{$EC[2]}}{$EC[3]}};


if($EC eq "\n"){$EC = ".*";}
if($name eq "\n"){$name = ".*";}
if($cofactor eq "\n"){$cofactor = ".*";}
if($outFile eq "\n"){$outFile = "enzRetrievalOut.txt";}
chomp $EC; chomp $name; chomp $cofactor;

print "======================================================\n\n\n";
open(OUT,">$outFile")||die"Can not open OUT.\n";
print OUT "Query:\nEC(ID) : $EC\nName : $name\nCofactor : $cofactor\n";
print OUT "===================================================\n\n\n";

if(split("\\.",$EC) == 4)
{
	getEnzById($EC);
}
else
{
	getEnzByInfo($EC,$name,$cofactor);
}
close(OUT);
print "\nOutput written to file : $outFile\n";
print "\n\nPress return/enter to exit..."; <STDIN>;



###############################################################
sub getEnzByInfo
{
	my($EC,$name,$cofactor) = @_;
	
	my($c,$sc,$ssc,$en,$enzNo,$cnt);
	
	$cnt = 0;
	foreach $c(sort {$a<=>$b} keys %enz)
	{
		foreach $sc(sort {$a<=>$b} keys %{$enz{$c}})
		{
			foreach $ssc(sort {$a<=>$b} keys %{${$enz{$c}}{$sc}})
			{
				foreach $en(sort {$a<=>$b} keys %{${${$enz{$c}}{$sc}}{$ssc}})
				{
						$enzNo = "$c.$sc.$ssc.$en";
						if( 	(${${${${$enz{$c}}{$sc}}{$ssc}}{$en}}{"DE"}=~m/$name/ig || ${${${${$enz{$c}}{$sc}}{$ssc}}{$en}}{"AN"}=~m/$name/ig) 
							 &&	(${${${${$enz{$c}}{$sc}}{$ssc}}{$en}}{"CF"}=~m/$cofactor/ig)
							 && ($enzNo =~m/^$EC/g))
						{
							print "ID $enzNo\n";
							print %{${${${$enz{$c}}{$sc}}{$ssc}}{$en}};
							print "\n----------------------------\n";
							print OUT "ID $enzNo\n";
							print OUT %{${${${$enz{$c}}{$sc}}{$ssc}}{$en}};
							print OUT "\n----------------------------\n";
							$cnt++;
						}
				}
			}
		}
	}
	print  "\n\n================================================\nTotal hits : $cnt";
	print OUT "\n\n=================================================\nTotal hits : $cnt";

}




sub getEnzById
{
	my $EC = $_[0];
	
	my($c,$sc,$ssc,$en,$enzNo,$cnt);
	
	$cnt = 0;
	foreach $c(sort {$a<=>$b} keys %enz)
	{
		foreach $sc(sort {$a<=>$b} keys %{$enz{$c}})
		{
			foreach $ssc(sort {$a<=>$b} keys %{${$enz{$c}}{$sc}})
			{
				foreach $en(sort {$a<=>$b} keys %{${${$enz{$c}}{$sc}}{$ssc}})
				{
						$enzNo = "$c.$sc.$ssc.$en";
						if($enzNo eq $EC)
						{
							print "ID $enzNo\n";
							print %{${${${$enz{$c}}{$sc}}{$ssc}}{$en}};
							print "\n----------------------------\n";
							print OUT "ID $enzNo\n";
							print OUT %{${${${$enz{$c}}{$sc}}{$ssc}}{$en}};
							print OUT "\n----------------------------\n";
							$cnt++;
						}
				}
			}
		}
	}
	print  "\n\n================================================\nTotal hits : $cnt";
	print OUT "\n\n=================================================\nTotal hits : $cnt";

}
