 #!/usr/bin/env perl

use strict;
use warnings;
use WWW::Mechanize;
use feature qw(say switch);
use LWP::Simple;

my $mech = WWW::Mechanize->new( autocheck => 1 );

our $single;
my $junk;
my @images = ();
my $img;
my $PATH = "/media/G_Raid_4TB/GuyImages";

sub savePic {
	my @urls = @_;
	my $tot = scalar(@urls); 
	my $cnt = 0;
	say "I have $tot images to fetch!";
	foreach my $url (@urls) {
		$cnt++;

		($junk,$img) = split(/tumblr_/,$url);
		print "Downloading ($cnt of $tot) \t...$url -- ImageName: $img\n";

		# Download the specified HTML page and print it to the console.
		# print get("http://www.caveofprogramming.com/");

		# Download the Cave of Programming home page HTML and save it to "home.html"
		# getstore("http://www.caveofprogramming.com/", "home.html");

		# Download logo.png from the Internet and store it in a file named "logo.jpg"
		my $saved = $PATH . "/" . $img;
		my $code = getstore($url, $saved);
		# Did we get code 200 (successful request) ?
		if($code != 200) {
			print "Failed\n"; ###exit;
		}
	}
	print "Finished\n";
	return;
}

sub main {
say "ARGV: $single";
	my $base = "http://hot-rods.tumblr.com/tagged/uncut";
	### my $base = "http://hot-rods.tumblr.com/tagged/hairy";
	### my $base = "http://hot-rods.tumblr.com/tagged/jockstrap";
	my $pgNum = 1;
	my $site;
	while (1 == 1) {
		if ($pgNum == 1) { $site = $base; } 
		### $site = $base . "/page/$pgNum";

		print "Scrapping site: $site\n";
		$mech->get( $site );
		### print $mech->content;
		my @lines = split(/\n/, $mech->content);
		undef @images;
		foreach my $line (@lines) {
			if ($line =~ "photo-url") {
				### print "Line: $line\n";
				($junk,$line) = split(/<a class="photo-url" href="/, $line);
				($line,$junk) = split(/">View Separately<\/a>/, $line);
				### print "Image file: $line\n";
				push (@images,$line);
			} else {
				next;
			}
		}
		say "Number of elements: " . @images;
		if (!@images) {
			say "No more images...we're done!\n";
			exit;
		}
		exit unless (@images);

		savePic(@images) if (@images);
		exit if ($single);
		$pgNum++;
		$site = $base . "/page/$pgNum";

	}
}

if (@ARGV) { say $ARGV[0]; $single = 1; say $single}

main();
exit;
