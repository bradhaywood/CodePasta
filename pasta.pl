#!/opt/perl5/bin/perl

use warnings;
use strict;
use 5.010;

use LWP::UserAgent;
use HTTP::Request::Common 'POST';
use Sysadm::Install 'slurp';
my $title;
my $syntax;
my $file;
my $url;

while(my $arg = shift @ARGV) {
    given($arg) {
        when('-t') {
            $title = shift @ARGV;
        }
        when('-s') {
            $syntax = shift @ARGV;
        }
        when('-u') {
            $url = shift @ARGV;
        }
        when('-f') {
            $file = shift @ARGV;
        }
    }
}

print $file . "\n";
if (not $title or not $syntax or not $url or not $file) {
    print STDERR "Usage: cat <file> | $0 -t \"Title of paste\" -s \"Syntax\" -u \"URL of CodePasta\"\n";
    exit 1;
}

my $data    = slurp $file
    or die "Could not open $file: $!\n";

my $ua      = LWP::UserAgent->new();
my $req     = POST("${url}/_post", [ 'title' => $title, 'syntax' => $syntax, code => $data ]);
my $content = $ua->request($req)->as_string();

say $content;
