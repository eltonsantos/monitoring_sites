#!/usr/bin/perl

# Script para monitorar sites
# Author: Elton Santos
# Date: 2025-23-02

use strict;
use warnings;
use LWP::UserAgent;
use POSIX qw(strftime);

my $ua = LWP::UserAgent->new(timeout => 10);

$ua->agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36");
$ua->default_header(
    'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Language' => 'en-US,en;q=0.5',
    'Referer'         => 'https://www.google.com'
);

my $file = "sites.txt";
my $log_file = "historico.txt";

open(my $fh, '<', $file) or die "Não foi possível abrir o arquivo $file: $!";
while (my $url = <$fh>) {
    chomp $url;
    my $response = $ua->get($url);
    
    if ($response->is_success) {
      print "[OK] $url está online\n";
    } else {
      my $timestamp = strftime "%Y-%m-%d %H:%M:%S", localtime;
      print "[ERRO] $url está offline: " . $response->status_line . "\n";

      open(my $log_fh, '>>', $log_file) or die "Erro ao abrir $log_file: $!";
      print $log_fh "$timestamp - $url caiu (Erro: " . $response->status_line . ")\n";
      close($log_fh);
    }
}
close($fh);
