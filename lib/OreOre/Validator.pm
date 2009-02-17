package OreOre::Validator;
use strict;
use warnings;
use 5.008_001;
use Carp ();
use UNIVERSAL::require;
use Scalar::Util qw/blessed/;
use OreOre::Validator::Plugin::Default;

our $VERSION = '0.01';

our $Rules;

sub import {
    my ($class, @plugins) = @_;
    $class->load_plugins(@plugins);
}

sub new {
    my ($class, $q) = @_;
    Carp::croak("Usage: ${class}->new(\$q)") unless $q;

    bless { _q => $q, _alias => {}, _error => {} }, $class;
}

sub check {
    my ($self, @rule_ary) = @_;
    Carp::croak("this is instance method") unless ref $self;

    my $q = $self->{_q};
    while (my ($key, $rules) = splice(@rule_ary, 0, 2)) {
        local $_;
        if (ref $key) {
            $key = [%$key];
            $_ = [ map { $q->param($_) } @{ $key->[1] } ];
            $key = $key->[0];
        } else {
            $_ = $q->param($key);
        }
        for my $rule (@$rules) {
            my $rule_name = ref $rule ? shift(@$rule) : $rule;
            my $invert_fg = 0;
            $rule_name =~ s{^NOT_}{$invert_fg++; ''}eo;
            my $result = do {
                if (!$_ && $rule_name ne 'NULL') {
                    0; # avoid warnings
                } else {
                    my $code = $Rules->{$rule_name} or Carp::croak("unknown rule $rule_name");
                    $code->(ref $rule ? @$rule : ()) ? 1 : 0;
                }
            };
            unless ($result ^ $invert_fg) { # XOR
                $self->set_error($key => $rule_name);
            }
        }
    }

    return $self;
}

sub is_error {
    my ($self, $key) = @_;

    if ($self->{_alias}->{$key}) {
        # aliased params
        for my $alias (@{ $self->{_alias}->{$key} }) {
            return 1 if $self->{_error}->{$alias};
        }
        return 0;
    } else {
        # normal params
        $self->{_error}->{$key} ? 1 : 0;
    }
}

sub has_error {
    my ($self, ) = @_;
    %{ $self->{_error} } ? 1 : 0;
}

sub set_error {
    my ($self, $param, $rule_name) = @_;
    $self->{_error}->{$param}->{$rule_name}++;
    push @{$self->{_error_ary}}, [$param, $rule_name];
}

sub set_alias {
    my ($self, @alias) = @_;
    while (my ($key, $target) = splice(@alias, 0, 2)) {
        $target = [$target] unless ref $target;
        $self->{_alias}->{$key} = $target;
    }
}

sub load_plugins {
    my $class = shift;
    for (@_) {
        my $plugin = $_;
        $plugin = ($plugin =~ s/^\+//) ? $plugin : "OreOre::Validator::Plugin::${plugin}";
        $plugin->use or die $@;
    }
}

sub set_message_data {
    my ($self, $msg) = @_;
    for my $key (qw/message param function/) {
        Carp::croak("missing key $key") unless $msg->{$key};
    }
    $self->{_msg} = $msg;
}

sub get_error_messages {
    my $self = shift;
    Carp::croak("message doesn't loaded yet") unless $self->{_msg};

    # invert the alias hash
    #     param_name => aliased_name
    my %param2aliased = do {
        my %v;
        while ( my ( $alias, $params ) = each %{ $self->{_alias} } ) {
            for my $param ( @{$params} ) {
                $v{$param} = $alias;
            }
        }
        %v;
    };

    my %dup_check;
    my @messages;
    for my $err (@{$self->{_error_ary}}) {
        my $param = $err->[0];
        my $func  = $err->[1];

        if (exists $param2aliased{$param} ) {
            $param = $param2aliased{$param};
        }

        next if exists $dup_check{"$param.$func"};
        push @messages, $self->get_error_message( $param, $func );
        $dup_check{"$param.$func"}++;
    }

    return @messages;
}

# $validator->get_error_message('email', 'NOT_NULL');
sub get_error_message {
    my ($self, $param, $function) = @_;
    $function = lc($function);

    my $msg = $self->{_msg};
    Carp::croak("please load message file first") unless $msg;

    my $err_message  = $msg->{message}->{"${param}.${function}"};
    my $err_param    = $msg->{param}->{$param};
    my $err_function = $msg->{function}->{$function};
    
    if ($err_message) {
        return sprintf($err_message, $err_param);
    } elsif ($err_function && $err_param) {
        return sprintf($err_function, $err_param);
    } else {
        Carp::carp  "${param}.${function} is not defined in message file.";
        if ($msg->{default_tmpl}) {
            return sprintf($err_function || $msg->{default_tmpl}, $err_function || $param);
        } else {
            return '';
        }
    }
}

1;

__END__

=head1 NAME

OreOre::Validator -

=head1 SYNOPSIS

    use OreOre::Validator;

    OreOre::Validator->load_plugins(qw/Japanese/);

    my $validator = OreOre::Validator->new;
    my $q = CGI->new();
    my $res = $validator->check(
        $q => [
            name => [qw/NOT_NULL/],
            name_kana => [qw/NOT_NULL KATAKANA/],
        ]
    );
    if ( ..... return_true_when_if_error() ..... ) {
        $validator->set_error('login_id' => 'DUPLICATE');
    }
    $validator->set_alias(
        zip  => [qw(zip1 zip2)]
    );
    if ($validator->has_error) {
        ...
    }

    # in your tmpl
    <ul>
    ? for my $msg ($validator->get_error_messages) {
        <li><?= $msg ?></li>
    ? }
    </ul>

=head1 DESCRIPTION

OreOre::Validator is

=head1 WHY NOT FormValidator::Simple?

FormValidator::Simple is too heavy for me.

=head1 HOW TO WRITE YOUR OWN PLUGINS

    http parameter comes from $_
    validator args comes from @_

=head1 AUTHOR

Default Name E<lt>default {at} example.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
