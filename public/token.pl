#!/usr/bin/perl

use strict;
use CGI::Fast qw//;
use CGI;
use Crypt::JWT qw(encode_jwt);
use DateTime;
use DateTime::Format::Strptime;

my $jwt_secret = file_get_contents("/keys/jwtservice.key");

while ( CGI::Fast->new ) {
	my $q = new CGI;
	my $expires = DateTime->now;
	$expires->add(minutes => 5);
	my $formatter = DateTime::Format::Strptime->new(pattern => '%Y-%m-%dT%H:%M:%S%z');
	my $expirestring = $formatter->format_datetime($expires);
	my $data = {
		expires => $expirestring
	};
	my $token = encode_jwt(payload=>$data, key=>\$jwt_secret, alg=>'RS256');
	print $q->header(-type => 'text/plain');
	print $token;
}

sub file_get_contents {
	my $filename = shift;
	open my $fh, "<", $filename;
	my @lines = <$fh>;
	return join("", @lines);
}
