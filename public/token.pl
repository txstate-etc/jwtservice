#!/usr/bin/perl

use strict;
use CGI;
use AuthCAS;
use Crypt::JWT qw(encode_jwt);
use DateTime;
use DateTime::Format::Strptime;

my $cas = new AuthCAS(casUrl => $ENV{'CAS_URL'});
my $serviceurl = $ENV{'REQUEST_SCHEME'}."://".$ENV{'HTTP_HOST'}.$ENV{'SCRIPT_NAME'};
my $jwt_secret = file_get_contents("/keys/jwtservice.key");

my $q = new CGI;

if ($ENV{QUERY_STRING} eq '') {
	print $q->header(-location=>$cas->getServerLoginURL($serviceurl));
} else {
	my $user = $cas->validateST($serviceurl, $q->param('ticket'));
	if ($user ne '') {
		my $expires = DateTime->now;
		$expires->add(minutes => 5);
		my $formatter = DateTime::Format::Strptime->new(pattern => '%Y-%m-%dT%H:%M:%S%z');
		my $expirestring = $formatter->format_datetime($expires);
		my $data = {
			user_id => $user,
			expires => $expirestring
		};
		my $token = encode_jwt(payload=>$data, key=>\$jwt_secret, alg=>'RS256');
		print $q->header(-type => 'text/plain');
		print $token;
	} else {
		print $q->header(-status=>'401 Unauthorized');
	}
}

sub file_get_contents {
	my $filename = shift;
	open my $fh, "<", $filename;
	my @lines = <$fh>;
	return join("", @lines);
}
