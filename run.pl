#!/usr/bin/perl

use warnings;
use utf8;
#use encode;
use Encode;
#use utf8::all;
use POSIX;

$PATH="ly.txt";
$WPATH="w.csv";
$index=1;
@list;
open(FILE,$PATH) || die("bad file");

open(WFILE,">",$WPATH) || die ("bad boy");
while ($line=<FILE>)
{
	$line =~ s/\r\n//g;
	$line =~ s/\n//g;
	$line =~ s/\r//g;
	
	$len = length($line)/3;
	$len = ceil($len);
	print "len:".$len."\n";
	$line_val="";
	
	if ($len <= 10)
	{			
		$list[$index] = $line;
		$index=$index+1;
		#$line_val="";
		next;
	
	}
	
	for ($id=1;$id<=$len;$id=$id+1)
	{
		$val = substr($line, ($id-1) *3,  3);
		$remain=$id%20;
		

		if ($remain == 0)
		{
			$val = $val."\n";
			$line_val=$line_val.$val;
			$list[$index] = $line_val;
			$index=$index+1;
			$line_val="";
			
		}
		else 
		{
			$line_val=$line_val.$val;
		}
		
	}
	
	if ($line_val ne "")
	{
		$list[$index] = $line_val."\n";
		$index=$index+1;
	}

}
#test
#for ($i =1;$i < 1024; $i++)
#{
#	$list[$i] = $i."|";
#}
@plist;
$index = 0;
$page = @list;
$page = $page/44;
$ls=1;
$page = ceil($page);

for ($i = 1; $i <= $page; $i=$i+2)
{
	$ls=1;
	for ($t =1; $t <=44; $t++)
	{
		#first line
		if ($ls == 1)
		{
			print WFILE "\n";
			$ls=$ls+1;
		}
		#midlle
		if ($ls == 24)
		{
			print WFILE "\n";
			$ls=$ls+1;
		}
		#line value
		$start = $list[($i - 1)*44 + $t];
		$end = $list[($i - 1)*44 + $t + 44];
		$start =~ s/\r\n//g;
		$start =~ s/\n//g;
		$end =~ s/\r\n//g;
		$end =~ s/\n//g;
		print WFILE $start.",".$end."\n";
		
		
		#last
		if ($ls == 46)
		{
			print WFILE "\n";
			$ls=$ls+1;
		}
		$ls=$ls+1;
		
	}
	#$i=$i+1;
	
}
close(WFILE);
exit;
