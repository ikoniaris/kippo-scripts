#!/usr/bin/perl
#
# Generate simple kippo instance stats
# Original Author: Tomasz Miklas
# Modified by Miguel jacq <mig@mig5.net> for Debian package
# GPLv2
#
use strict;
use warnings;
 
# Paths to various kippo components
#
# Data directory
my $kippodatadir = '/opt/kippo/data';
 
# Config directory
my $kippoconfdir = '/opt/kippo';
 
# Log directory
my $kippologdir = '/opt/kippo/log';
 
my $date = $ARGV[0] || 'Lifetime';
 
my (%sources, %usernames, %passwords, %sshversions, %userpasscombo);
my ($left,$right,$cnt,$connections);
my $sensorid = `md5sum $kippoconfdir/kippo.cfg | cut -d " " -f 1`;
 
open (IN, "cat $kippologdir/kippo* |") || die "Can't open log stream: $!\n";
while (<IN>) {
  next if $date ne 'Lifetime' and !/^$date/;
  next if !/(login attempt|New connection:|Remote SSH version:)/;
  chomp;
  # New connection: xx.xx.xx.xx:<port>
  # Remote SSH version: SSH-2.0-libssh-0.1
  # login attempt [nurmi/nurmi] failed
  if (/New connection: (.*?):/) { $sources{$1}++; $connections++ };
  if (/Remote SSH version:\s+(.*?)$/) { $sshversions{$1}++ };
  if (/login attempt \[(.*?)\/(.*?)\]/) { $usernames{$1}++; $passwords{$2}++; $userpasscombo{"$1 / $2"}++ };
}
close (IN);
 
format STDOUT =
@< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<
$cnt, $left,$right
.
 
print "$date stats for kippo instance\nInstance $sensorid\nUnique values ($connections connections):\n - usernames\t" , scalar keys %usernames , "\n - passwords\t" , scalar keys %passwords , "\n - sources\t" , scalar keys %sources , "\n\n\n";
print "# SSH client versions Count\n";
print "--------------------------------------------------------------\n";
$cnt=1;
foreach my $version (sort {$sshversions{$b} <=> $sshversions{$a}} keys %sshversions) {
  $left = $version;
  $right = $sshversions{$version};
  write;
  $cnt++;
}
print "\n\n";
 
print "# Top 10 usernames Count\n";
print "--------------------------------------------------------------\n";
$cnt = 1;
foreach my $username (sort {$usernames{$b} <=> $usernames{$a}} keys %usernames) {
  last if $cnt > 10;
  $left = $username;
  $right = $usernames{$username};
  write;
  $cnt++;
}
print "\n\n";
 
print "# Top 10 passwords Count\n";
print "--------------------------------------------------------------\n";
$cnt = 1;
foreach my $password (sort {$passwords{$b} <=> $passwords{$a}} keys %passwords) {
  last if $cnt > 10;
  $left = $password;
  $right = $passwords{$password};
  write;
  $cnt++;
}
print "\n\n";
 
print "# Top 10 'user / pass' combos Count\n";
print "--------------------------------------------------------------\n";
$cnt = 1;
foreach my $combo (sort {$userpasscombo{$b} <=> $userpasscombo{$a}} keys %userpasscombo) {
  last if $cnt > 10;
  $left = $combo;
  $right = $userpasscombo{$combo};
  write;
  $cnt++;
}
print "\n\n";
 
print "# Top 10 offenders Count\n";
print "--------------------------------------------------------------\n";
$cnt=1;
foreach my $src (sort { $sources{$b} <=> $sources{$a} } keys %sources) {
  last if $cnt > 10;
  $left = $src;
  $right = $sources{$src};
  write;
  $cnt++;
}
print "\n\n";
 
print "# Current Logs in log/tty Folder ";
my $fileCnt = 0;
open (lineCounts, "ls $kippologdir/tty/ |") || die "Can't open log dir: $!\n";
while (<lineCounts>){$fileCnt++;}
print " $fileCnt Files\n";
close (lineCounts);
print "--------------------------------------------------------------\n";
