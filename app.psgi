use 5.010;
use warnings;
use Imager;
use IO::File;
use Plack::Request;

my $app = sub {
	my ($env) = @_;

	my $req = Plack::Request->new($env);
	my $res;

	if ($req->path eq '/') {
		$res = $req->new_response(
			200,
			['Content-Type' => 'text/plain; charset=utf-8'],
			'ok, ' . $]
		);
	} elsif ($req->path eq '/img') {
		$res = get_img_response($req);
	} else {
		$res = $req->new_response(
			404,
			['Content-Type' => 'text/plain; charset=utf-8'],
			'not found'
		);
	}

	return $res->finalize;
};

sub get_img_response {
	my ($req) = @_;

	my $res = $req->new_response(
		200,
		[
			'Content-Type' => 'image/png',
			'Cache-Control' => 'private, max-age=600',
		]
	);

	$res->body(get_img_fh());

	return $res;
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

$app;
