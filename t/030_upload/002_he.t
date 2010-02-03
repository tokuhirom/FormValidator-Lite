use strict;
use warnings;
use FormValidator::Lite;
use Test::More;
plan skip_all => 'this test requires HTTP::Engine' unless eval 'use HTTP::Engine; use HTTP::Request; 1;';
plan tests => 8;

do {
    my $q = do {
        my $file = 't/dat/file_post.txt';
        open my $fh, "<", $file
        or die "missing test file $file";
        binmode $fh;
        my $body = do { local $/; <$fh> };

        HTTP::Request->new(
            'POST', '/',
            HTTP::Headers->new(
                'Content-Type' => 'multipart/form-data; boundary=xYzZY',
                'Content-Length' => length($body),
            ),
            $body
        );
    };

    my $res = HTTP::Engine->new(
        interface => {
            module => 'Test',
            request_handler => sub {
                my $q = shift;
                my $u = FormValidator::Lite::Upload->new(
                    $q, 'hello_world'
                );
                is($u->size, 13);
                is($u->type, 'text/plain');
                is(do { local $/; my $fh = $u->fh; <$fh>}, "Hello World!\n");

                HTTP::Engine::Response->new(status => 200, body => 'ok');
            },
        },
    )->run($q);
    is $res->content, 'ok';
};

# -------------------------------------------------------------------------

do {
    {
        package MyApp::Request;
        use base qw/HTTP::Engine::Request/;
        sub new {
            my ($self, $orig) = @_;
            bless {%$orig}, __PACKAGE__;
        }
    }

    my $q = do {
        my $file = 't/dat/file_post.txt';
        open my $fh, "<", $file
        or die "missing test file $file";
        binmode $fh;
        my $body = do { local $/; <$fh> };

        HTTP::Request->new(
            'POST', '/',
            HTTP::Headers->new(
                'Content-Type' => 'multipart/form-data; boundary=xYzZY',
                'Content-Length' => length($body),
            ),
            $body
        );
    };

    my $res = HTTP::Engine->new(
        interface => {
            module => 'Test',
            request_handler => sub {
                my $q = shift;
                   $q = MyApp::Request->new($q);
                my $u = FormValidator::Lite::Upload->new(
                    $q, 'hello_world'
                );
                is($u->size, 13);
                is($u->type, 'text/plain');
                is(do { local $/; my $fh = $u->fh; <$fh>}, "Hello World!\n");

                HTTP::Engine::Response->new(status => 200, body => 'ok');
            },
        },
    )->run($q);
    is $res->content, 'ok';
};
