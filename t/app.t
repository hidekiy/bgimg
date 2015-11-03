use HTTP::Request;
use Plack::Test;
use Test::More;

my $app = require 'app.psgi';

test_psgi $app, sub {
    my $cb = shift;

    my $req = HTTP::Request->new(GET => 'http://localhost/img');
    my $res = $cb->($req);

    is($res->code, 200);
    ok(length($res->content) > 0);
};

done_testing;
