use 5.010;
use warnings;
use Imager;
use IO::File;
use Plack::Request;

my $textType = 'text/plain; charset=utf-8';
my $statusOk = 200;
my $statusNotFound = 404;

sub app {
	my ($env) = @_;

	my $req = Plack::Request->new($env);
	my $res = $req->new_response;

	if ($req->path eq '/ok') {
		$res->status($statusOk);
		$res->content_type($textType);
		$res->body('ok');
	} elsif ($req->path eq '/img') {
		$res->status($statusOk);
		$res->content_type('image/png');
		$res->header('Cache-Control' => 'private, max-age=600');
		$res->body(get_img_fh());
	} else {
		$res->status($statusNotFound);
		$res->content_type($textType);
		$res->body('not found');
	}

	return $res->finalize;
}

sub get_img_fh {
	my ($xsize, $ysize) = (60, 60);

	my $img = Imager->new(
		xsize => $xsize,
		ysize => $ysize,
	);

	$img->box(filled => 1, color => 'white');

	my $hue1 = rand(360);
	my $hue2 = $hue1 + 60;

	for my $i (0 .. 9) {
		my $color =  Imager::Color->new(
			hue => ($i % 2 ? $hue1 : $hue2),
			saturation => rand(0.1),
			value => 1,
		);

		$img->box(
			xmin => rand($xsize),
			ymin => rand($ysize),
			filled => 1,
			color => $color,
		);
	}

	my $fh = IO::File->new_tmpfile;
	$fh->binmode;
	$img->write(fh => $fh, type => 'png') or die $img->errstr;
	$fh->seek(0, 0);

	return $fh;
}

\&app;
