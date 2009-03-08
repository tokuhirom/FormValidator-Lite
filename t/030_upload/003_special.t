use strict;
use warnings;
use FormValidator::Lite;
use CGI;
use Test::More tests => 3;

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
    local *STDIN;
    open STDIN, "<", $file
      or die "missing test file $file";
    binmode STDIN;
    CGI->new;
};

{
    package MyFoo;
    sub new { bless { }, shift }
    sub upload {
        my ($self, $name) = @_;
        FormValidator::Lite::Upload->new(
            $q, $name
        );
    }
}

my $u = FormValidator::Lite::Upload->new(MyFoo->new, 'hello_world');
is($u->size, 13);
is($u->type, 'text/plain');

my $fh = $u->fh;
is do { local $/; <$fh> }, "Hello World!\n";

