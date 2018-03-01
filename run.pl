#!/usr/bin/perl

use warnings;
use utf8;
#use encode;
use Encode;
#use utf8::all;
use POSIX;

$PATH="ly.txt";
$WPATH="w.csv";
$index=0;
#limit line len max 
$LINE_LEN_MAX = 18;
#show header page num
$SHOW_HEADER=0;

open(FILE,$PATH) || die("bad source file:".$PATH." is exists?\n");
print "open source file:".$PATH." succ\n";

open(WFILE,">",$WPATH) || die ("bad output file:".$WPATH." may be already opened or permission deney\n");
print "open output file:".$WPATH." succ\n";
print "read all source buffer,reading......\n";
while ($line=<FILE>)
{
	$line =~ s/\r\n//g;
	$line =~ s/\n//g;
	$line =~ s/\r//g;
	$line =~ s/ //g;
	
	$len = length($line)/3;
	$len = ceil($len);
	#print "len:".$len."\n";
	$line_val="";
	
	if ($len == 0) 
	{
		next;
	}
	
	if ($len <= $LINE_LEN_MAX)
	{			
		$list[$index] = $line;
		$index=$index+1;
		#$line_val="";
		next;
	
	}
	
	for ($id=0;$id<$len;$id=$id+1)
	{
		$val = substr($line, ($id) *3,  3);
		$remain=$id%$LINE_LEN_MAX;
		

		if ($remain == 0 && $id != 0)
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
print "read all source buffer finish\n";
print "makeing.........\n";
method_double();
print "finish.........\n";
print "***********************************************\n";
print "***********************************************\n";
print "       ouput file: ".$WPATH."\n";
print "***********************************************\n";
print "***********************************************\n";
#method_sequence();
sub method_sequence{
	
	$index = 0;
	$page = @list;
	$page = $page/48;
	$ls=1;
	$page = ceil($page);
							  #两折页
	for ($i = 0; $i < $page; $i=$i+2)
	{
		$ls=1;
		for ($t =0; $t <48; $t++)
		{
			#first line
			if ($ls == 1)
			{
				print WFILE "\n";
				$ls=$ls+1;
			}
			#midlle
			if ($ls == 26)
			{
				print WFILE "\n";
				print WFILE "\n";
				print WFILE "\n";
				$ls=$ls+3;
			}
			#line value
			if(defined $list[$i*48 + $t])
			{
				$start = $list[$i*48 + $t];
			}else {
				$start = "";
			}
			
			if (defined $list[$i*48 + ($t + 48)])
			{
				$end = $list[$i*48 + ($t + 48)];
			} else {
				$end = "";
			}
			$start =~ s/\r\n//g;
			$start =~ s/\n//g;
			$end =~ s/\r\n//g;
			$end =~ s/\n//g;
			print WFILE $start.",,".$end."\n";
			$ls=$ls+1;
		
			#last
			if ($ls == 53)
			{
				print WFILE "\n";
				$ls=$ls+1;
			}
			
			
		}
		#$i=$i+1;
		
	}
}

sub method_double{

	$index = 0;
	$page = @list;
	$page = $page/48;
	$header=1;
	
	$page = ceil($page);
							  #2折页 + 一次处理2页
	for ($i = 0; $i < $page; $i=$i+4)
	{
	#page 1
		#1
		$header=($i/4) * 8;
		$left_header = $header + 1;
		$right_header = $header + 3;
		if ($SHOW_HEADER == 1)
		{
			print WFILE $left_header.",,".$right_header."\n";
		}
		else
		{
			print WFILE "\n";
		}
		
		#pre set value
		for ($t = 0; $t < 48 *4; $t++)
		{
			if (!defined $list[$i * 48 + 0 + $t])
			{
				$list[$i * 48 + 0 + $t] = "";
			}
		}
		
		for ($t = 0; $t < 24; $t=$t+1) 
		{
			$start = $list[$i * 48 + 0 + $t];
			$end   = $list[$i * 48 + 2 * 24 + $t];
			$start =~ s/\r\n//g;
			$start =~ s/\n//g;
			$end =~ s/\r\n//g;
			$end =~ s/\n//g;
			print WFILE $start.",,".$end."\n";
		}
		#26
		print WFILE "\n";
		#27
		print WFILE "\n";
		#28
		$left_header = $header + 5;
		$right_header = $header + 7;
		if ($SHOW_HEADER == 1)
		{
			print WFILE $left_header.",,".$right_header."\n";
		}
		else
		{
			print WFILE "\n";
		}
		
		#29
		for ($t = 0; $t < 24; $t=$t+1) 
		{
			$start = $list[$i * 48 + 4 * 24 + $t];
			$end   = $list[$i * 48 + 6 * 24 + $t];
			$start =~ s/\r\n//g;
			$start =~ s/\n//g;
			$end =~ s/\r\n//g;
			$end =~ s/\n//g;
			print WFILE $start.",,".$end."\n";
		}
		#53
		print WFILE "\n";
	
	#page2	
		#1
		$left_header = $header + 4;
		$right_header = $header + 2;
		if ($SHOW_HEADER == 1)
		{
			print WFILE $left_header.",,".$right_header."\n";
		}
		else
		{
			print WFILE "\n";
		}
		
		for ($t = 0; $t < 24; $t=$t+1) 
		{
			$start = $list[$i * 48 + 3 * 24 + $t];
			$end   = $list[$i * 48 + 1 * 24 + $t];
			$start =~ s/\r\n//g;
			$start =~ s/\n//g;
			$end =~ s/\r\n//g;
			$end =~ s/\n//g;
			print WFILE $start.",,".$end."\n";
		}
		#26
		print WFILE "\n";
		#27
		print WFILE "\n";
		#28
		$left_header = $header + 8;
		$right_header = $header + 6;
		if ($SHOW_HEADER == 1)
		{
			print WFILE $left_header.",,".$right_header."\n";
		}
		else
		{
			print WFILE "\n";
		}
		
		#29
		for ($t = 0; $t < 24; $t=$t+1) 
		{
			$start = $list[$i * 48 + 7 * 24 + $t];
			$end   = $list[$i * 48 + 5 * 24 + $t];
			$start =~ s/\r\n//g;
			$start =~ s/\n//g;
			$end =~ s/\r\n//g;
			$end =~ s/\n//g;
			print WFILE $start.",,".$end."\n";
		}
		#53
		print WFILE "\n";
		
	}
	
}
close(WFILE);
exit;
