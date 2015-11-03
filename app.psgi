use 5.012;
use Imager;
use IO::File;
use Plack::Request;

use constant TYPE_TEXT => 'text/plain;charset=UTF-8';
use constant STATUS_OK => 200;
use constant STATUS_NOT_FOUND => 404;

sub app {
	my ($env) = @_;

	my $req = Plack::Request->new($env);

	if ($req->path eq '/ok') {
		my $res = $req->new_response;
		$res->status(STATUS_OK);
		$res->content_type(TYPE_TEXT);
		$res->body('ok');
		return $res->finalize;
	}

	if ($req->path eq '/img') {
		my $res = $req->new_response;
		$res->status(STATUS_OK);
		$res->content_type('image/png');
		$res->header('Cache-Control' => 'private, max-age=600');
		$res->body(get_img_fh());
		return $res->finalize;
	}


	my $res = $req->new_response;
	$res->status(STATUS_NOT_FOUND);
	$res->content_type(TYPE_TEXT);
	$res->body('not found');
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
