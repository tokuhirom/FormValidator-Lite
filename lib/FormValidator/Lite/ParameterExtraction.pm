package FormValidator::Lite::ParameterExtraction;
use strict;
use warnings;

sub determine_callback {
    my $q = shift;
    return
          UNIVERSAL::isa($q, 'CGI') ? \&cgi_request_params
        : UNIVERSAL::isa($q, 'Dancer::Request') ? \&dancer_request_params
        : UNIVERSAL::isa($q, 'Mojo::Message::Request') ? \&mojo_request_params
        :   \&generic_request_params;
}

sub cgi_request_params {
    my ($q, $key) = @_;
    $q->multi_param($key);
}

sub mojo_request_params {
    my ($q, $key) = @_;
    my $val = $q->every_param($key);
    @$val;
}

sub dancer_request_params {
    my ($q, $key) = @_;
    my $val = $q->params->{$key};
    ref($val) eq 'ARRAY' ? @$val : $val;
}

sub generic_request_params {
    my ($q, $key) = @_;
    my @values = $q->param($key);
    @values;
}

1;

__END__

=head1 NAME

FormValidator::Lite::ParameterExtraction - extract params from request objects

=head1 SYNOPSIS

    my $cb = FormValidator::Lite::ParameterExtraction::determine_callback($req);
    #=> Get a callback function to get params from given request object

    my @val = $cb->($req, 'name');
    #=> Get all values associated with a named parameter

=head1 DESCRIPTION

Since L<CGI> version 4.08, consistency between various frameworks and libraries
in retrieving multiple values from a named parameter is lost which we formerly used
C<$req->param> for both list and scalar context.

This module provides compatibility in retrieving multiple values associated to a request parameter.

=head1 FUNCTIONS

=over 4

=item determine_callback($req)

Accepts a request object and returns a callback function to retrieve multiple values from the
request object.

A callback function returned from this function should be called as:

    my @val = $cb->($req, 'name');

=item cgi_request_params($req, $name)

A function to be returned by C<determine_callback> when given request object is determined as a L<CGI> object.

=item dancer_request_params($req, $name)

A function to be returned by C<determine_callback> when given request object is determined as a L<Dancer::Request> object.

=item mojo_request_params($req, $name)

A function to be returned by C<determine_callback> when given request object is determined as a L<Mojo::Message::Request> object.

=item generic_request_params($req, $name)

A function to be returned by C<determine_callback> when given request object does not match any of the above.

=back

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
