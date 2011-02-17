use strict;
use warnings;
use utf8;
use Test::Base;
use FormValidator::Lite 'File';
use Test::Requires 'Plack::Request';

plan tests => 1*blocks;

# Copied from CGI.pm - http://search.cpan.org/perldoc?CGI
%ENV = (
    %ENV,
    'SCRIPT_NAME'       => '/test.cgi',
    'SERVER_NAME'       => 'perl.org',
    'HTTP_CONNECTION'   => 'TE, close',
    'REQUEST_METHOD'    => 'POST',
    'SCRIPT_URI'        => 'http://www.perl.org/test.cgi',
    'CONTENT_LENGTH'    => 3458,
    'SCRIPT_FILENAME'   => '/home/usr/test.cgi',
    'SERVER_SOFTWARE'   => 'Apache/1.3.27 (Unix) ',
    'HTTP_TE'           => 'deflate,gzip;q=0.3',
    'QUERY_STRING'      => '',
    'REMOTE_PORT'       => '1855',
    'HTTP_USER_AGENT'   => 'Mozilla/5.0 (compatible; Konqueror/2.1.1; X11)',
    'SERVER_PORT'       => '80',
    'REMOTE_ADDR'       => '127.0.0.1',
    'CONTENT_TYPE'      => 'multipart/form-data; boundary=xYzZY',
    'SERVER_PROTOCOL'   => 'HTTP/1.1',
    'PATH'              => '/usr/local/bin:/usr/bin:/bin',
    'REQUEST_URI'       => '/test.cgi',
    'GATEWAY_INTERFACE' => 'CGI/1.1',
    'SCRIPT_URL'        => '/test.cgi',
    'SERVER_ADDR'       => '127.0.0.1',
    'DOCUMENT_ROOT'     => '/home/develop',
    'HTTP_HOST'         => 'www.perl.org'
);

my $q = do {
    my $file = 't/dat/file_post.txt';
    open my $fh, "<:raw", $file
      or die "missing test file $file";
    Plack::Request->new({
        'psgi.input' => $fh,
        %ENV,
    });
};

run {
    my $block = shift;
    my $v = FormValidator::Lite->new($q);
    $v->check(
        hello_world => [eval $block->input]
    );
    die $@ if $@;
    is($v->has_error, $block->expected, $block->input);
};

__END__

===
--- input: ['FILE_MIME', 'plain']
--- expected: 1

===
--- input: ['FILE_MIME', qr{^text/.+$}]
--- expected: 0

===
--- input: ['FILE_MIME', qr{^image/.+$}]
--- expected: 1

===
--- input: ['FILE_MIME', 'image/png']
--- expected: 1

===
--- input: ['FILE_MIME', 'text/plain']
--- expected: 0

=== max only(ok) (real file size is 13)
--- input: ['FILE_SIZE', 100]
--- expected: 0

=== max only(no good)
--- input: ['FILE_SIZE', 3]
--- expected: 1

=== max and min
--- input: ['FILE_SIZE', 20, 15]
--- expected: 1

=== max and min(ok)
--- input: ['FILE_SIZE', 20, 13]
--- expected: 0

