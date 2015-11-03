use HTTP::Request;
use HTTP::Request::Common;
use Plack::Test;
use Test::More;

my $app = require 'app.psgi';

test_psgi $app, sub {
    my $cb = shift;
    my $res = $cb->(GET '/ok');

    is($res->code, 200);
    ok($res->content, 'ok');
};

test_psgi $app, sub {
    my $cb = shift;
    my $res = $cb->(GET '/img');

    is($res->code, 200);
    ok(length($res->content) > 0);
};

done_testing;
