use 5.012;
use HTTP::Request;
use HTTP::Request::Common;
use Plack::Test;
use Test::More;

my $app = require 'app.psgi';

test_psgi $app, sub {
    my $cb = shift;
    my $res = $cb->(GET '/robots.txt');

    is($res->code, 200);
};

test_psgi $app, sub {
    my $cb = shift;
    my $res = $cb->(GET '/img');

    is($res->code, 200);
    ok(length($res->content) > 0);
};

done_testing;
