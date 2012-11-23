#!/usr/bin/perl

# id = World Text Account ID
# key = World Text secret API key
# dstaddr = Destination mobile number (the number to send SMS to)
# txt = the text message body

use strict;
use JSON;
use LWP::Simple;
use LWP::UserAgent;
use URI::Escape;
use Getopt::Long;
use HTTP::Request::Common;

my %args;

GetOptions(
	'help'      => \$args{help},
	'id=i'      => \$args{id},
	'key=s'     => \$args{key},
	'dstaddr=s' => \$args{dstaddr},
	'txt=s'     => \$args{txt},
	'sim'       => \$args{sim}
	 );

if(defined($args{help}) || !defined($args{id}) || !defined($args{key}) || !defined($args{dstaddr}) || !defined($args{txt}) ) {
	print "usage: notify_worldtext_sms.pl --id <accountid> --key <apikey> --dstaddr <destination number> --txt <message> --sim\n";
	exit(0);
}

## URL Encode the message text
my $text = uri_escape($args{txt});

## Build the URL
my $baseurl = "http://sms.world-text.com/v2.0";
my $getvars = "id=$args{id}&key=$args{key}&dstaddr=$args{dstaddr}&srcaddr=Nagios&txt=$text";

## Has a simulation been requested
if(defined($args{sim})) {
	$getvars = "$getvars&sim";
}

## Create the user agent and send the request
my $ua = LWP::UserAgent->new();
my $rsp = $ua->request(PUT "$baseurl/sms/send?$getvars");

## Process the response
my $data   = decode_json( $rsp->content );
if(${data}->{status} == 0) {
	print "Message sent succesfully to $args{dstaddr}\n";
} else {
	print "Message submission failure: " . ${data}->{desc} . "\n";
}