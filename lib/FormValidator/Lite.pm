package FormValidator::Lite;
use strict;
use warnings;
use 5.008_001;
use Carp ();
use Scalar::Util qw/blessed/;
use FormValidator::Lite::Constraint::Default;
use FormValidator::Lite::Upload;
use Class::Accessor::Lite 0.05 (
    rw => [qw/query/]
);
use Class::Load ();

our $VERSION = '0.32';

our $Rules;
our $FileRules;

sub import {
    my ($class, @constraints) = @_;
    $class->load_constraints(@constraints);
}

sub new {
    my ($class, $q) = @_;
    Carp::croak("Usage: ${class}->new(\$q)") unless $q;

    bless { query => $q, _error => {} }, $class;
}

sub check {
    my ($self, @rule_ary) = @_;
    Carp::croak("this is instance method") unless ref $self;

    my $q = $self->{query};
    while (my ($key, $rules) = splice(@rule_ary, 0, 2)) {
        my @values;
        if (ref $key) {
            $key = [%$key];
            @values = [ map { $q->param($_) } @{ $key->[1] } ];
            $key = $key->[0];
        } else {
            @values = defined $q->param($key) ? $q->param($key) : undef;
        }
        for my $value (@values) {
            local $_ = $value;
            for my $rule (@$rules) {
                my $rule_name = ref($rule) ? $rule->[0]                        : $rule;
                my $args      = ref($rule) ? [ @$rule[ 1 .. scalar(@$rule)-1 ] ] : +[];

                if ($FileRules->{$rule_name}) {
                    $_ = FormValidator::Lite::Upload->new($q, $key);
                }
                my $is_ok = do {
                    if ((not (defined $_ && length $_)) && $rule_name !~ /^(NOT_NULL|NOT_BLANK|REQUIRED)$/) {
                        1;
                    } else {
                        if (my $file_rule = $FileRules->{$rule_name}) {
                            $file_rule->(@$args) ? 1 : 0;
                        } else {
                            my $code = $Rules->{$rule_name} or Carp::croak("unknown rule $rule_name");
                            $code->(@$args) ? 1 : 0;
                        }
                    }
                };
                if ($is_ok==0) {
                    $self->set_error($key => $rule_name);
                }
            }
        }
    }

    return $self;
}

sub is_error {
    my ($self, $key) = @_;
    $self->{_error}->{$key} ? 1 : 0;
}

sub is_valid {
    my $self = shift;
    !$self->has_error ? 1 : 0;
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

sub errors {
    my ($self) = @_;
    $self->{_error};
}

sub load_constraints {
    my $class = shift;
    for (@_) {
        my $constraint = $_;
        $constraint = ($constraint =~ s/^\+//) ? $constraint : "FormValidator::Lite::Constraint::${constraint}";
        Class::Load::load_class($constraint);
    }
}

sub load_function_message {
    my ($self, $lang) = @_;
    my $pkg = "FormValidator::Lite::Messages::$lang";
    Class::Load::load_class($pkg);

    no strict 'refs';
    $self->{_msg}->{function} = ${"${pkg}::MESSAGES"};
}

sub set_param_message {
    my ($self, %args) = @_;
    $self->{_msg}->{param} = \%args;
}

sub set_message_data {
    my ($self, $msg) = @_;
    for my $key (qw/message param function/) {
        Carp::croak("missing key $key") unless $msg->{$key};
    }
    $self->{_msg} = $msg;
}

sub set_message {
    my ($self, @args) = @_;
    my %msg = ref $args[0] ? %{$args[0]} : @args;
    $self->{_msg}->{message} = +{
        %{ $self->{_msg}->{message} || +{} },
        %msg
    };
}

sub get_error_messages {
    my $self = shift;
    Carp::croak("No messages loaded yet") unless $self->{_msg};

    my %dup_check;
    my @messages;
    for my $err (@{$self->{_error_ary}}) {
        my $param = $err->[0];
        my $func  = $err->[1];

        next if exists $dup_check{"$param.$func"};
        push @messages, $self->get_error_message( $param, $func );
        $dup_check{"$param.$func"}++;
    }

    return wantarray ? @messages : \@messages;
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

    my $gen_msg = sub {
        my ($tmpl, @args) = @_;
        local $_ = $tmpl;
        s!\[_(\d+)\]!$args[$1-1]!ge;
        $_;
    };
    
    if ($err_message) {
        return $gen_msg->($err_message, $err_param);
    } elsif ($err_function && $err_param) {
        return $gen_msg->($err_function, $err_param);
    } else {
        Carp::carp  "${param}.${function} is not defined in message file.";
        if ($msg->{default_tmpl}) {
            return $gen_msg->($err_function || $msg->{default_tmpl}, $err_function || $param);
        } else {
            return '';
        }
    }
}

sub get_error_messages_from_param {
    my ($self, $target_param) = @_;

    my %dup_check;
    my @messages;
    for my $err (@{$self->{_error_ary}}) {
        my $param = $err->[0];
        my $func  = $err->[1];

        next if $target_param ne $param;
        next if exists $dup_check{"$param.$func"};
        push @messages, $self->get_error_message( $param, $func );
        $dup_check{"$param.$func"}++;
    }

    return wantarray ? @messages : \@messages;
}

1;

__END__

=head1 NAME

FormValidator::Lite - lightweight form validation library

=head1 SYNOPSIS

    use FormValidator::Lite;

    FormValidator::Lite->load_constraints(qw/Japanese/);

    my $q = CGI->new();
    my $validator = FormValidator::Lite->new($q);
    $validator->load_function_message('en');
    my $res = $validator->check(
        name => [qw/NOT_NULL/],
        name_kana => [qw/NOT_NULL KATAKANA/],
        {mails => [qw/mail1 mail2/]} => ['DUPLICATION'],
    );
    if ( ..... return_true_if_error() ..... ) {
        $validator->set_error('login_id' => 'DUPLICATION');
    }
    if ($validator->has_error) {
        ...
    }

    # in your template
    <ul>
    ? for my $msg ($validator->get_error_messages) {
        <li><?= $msg ?></li>
    ? }
    </ul>

=head1 DESCRIPTION

FormValidator::Lite is a simple, fast implementation for form validation.

IT'S IN BETA QUALITY. API MAY CHANGE IN THE FUTURE.

=head1 HOW TO WRITE YOUR OWN CONSTRAINTS

    http parameter comes from $_
    validator args comes from @_

=head1 METHODS

=over 4

=item my $validator = FormValidator::Lite->new($q);

Create a new instance.

C<<$q>> is a query-like object such as Apache::Request, CGI.pm, Plack::Request.
The object MUST have a C<< $q->param >> method.

=item $validator->query()

=item $validator->query($query)

Getter/Setter for the query object.

=item $validator->check(@rule_ary)

    my $res = $validator->check(
        name      => [qw/NOT_NULL/],
        name_kana => [qw/NOT_NULL KATAKANA/],
        {mails => [qw/mail1 mail2/]} => ['DUPLICATION'],
    );

This method does the validation. You can write a rule in C<< @rule_ary >>. In
the example code above, I<name> is a parameter name, I<NOT_NULL>, I<KATAKANA> and
I<DUPLICATION> are the names of the constraints.

=item $validator->is_error($key)

Return true value if there is an error for the C<< $key >> parameter.

=item $validator->is_valid()

Return true value if C<< $validator >> didn't detect any error.

This is the same as C<< !$validator->has_error() >>.

=item $validator->has_error()

Return true value if C<< $validator >> detects error.

This is the same as C<< !$validator->is_valid() >>.

=item $validator->set_error($param, $rule_name)

Manually set a new error to the parameter named C<<$param>>. The rule's name
is C<<$rule_name>>.

=item $validator->errors()

Return all the errors as a hash reference where the keys are the problematic
parameters and the values are a hash reference with the failed constraints.
    
    {
        'foo' => { 'NOT_NULL' => 1, 'INT' => 1 },
        'bar' => { 'EMAIL' => 1, },
    }

=item $validator->load_constraints($name)

    $validator->load_constraints("DATE", "Email");

    # or load your own constraints
    $validator->load_constraints("+MyApp::FormValidator::Lite::Constraint");

There is an import style.

    use FormValidator::Lite qw/Date Email/;

load constraint components named C<< "FormValidator::Lite::Constraint::${name}" >>.

=item $validator->load_function_message($lang)

    $validator->load_function_message('ja');

Load function message file.

Currently, L<FormValidator::Lite::Messages::ja> and L<FormValidator::Lite::Messages::en> are available.

=item $validator->set_param_message($param => $message, ...)
    
    $validator->set_param_message(
        name => 'Your Name',
    );

Add a message-friendly description for the parameter.

=item $validator->set_message("$param.$func" => $message)

    $v->set_message('zip.jzip' => 'Please input correct zip number.');

Set an error message for a given $param and $func pair.

=item $validator->set_message_data({ message => $msg, param => $param, function => $function })

    $v->set_message_data(YAML::Load(<<'...'));
    ---
    message:
      zip.jzip: Please input correct zip number.
    param:
      name: Your Name
    function:
      not_null: "[_1] is empty"
      hiragana: "[_1] is not Hiragana"
    ...

Set the error message map. In the 'function' and 'message' sections,
C<< [_1] >> will be replaced with the description of the failing parameter
provided in the 'param' section.

Note that it will nullify any previous calls to
C<< load_function_message >>, C<< set_message >> or C<< set_param_message >>.

=item my @errors = $validator->get_error_messages()

=item my $errors = $validator->get_error_messages()

Get all the error messages for C<<$q>> in array/arrayref.
This method returns an array in list context and an array reference otherwise.

=item my $msg = $validator->get_error_message($param => $func)

Generate the error message for parameter $param and function named $func.

=item my @msgs = $validator->get_error_messages_from_param($param)

Get all the error messages by $q for the parameter $param.

=back

=head1 WHY NOT FormValidator::Simple?

Yes, I know. This module is very similar with FV::S.

But, FormValidator::Simple is too heavy for me.
FormValidator::Lite is fast!

   Perl: 5.010000
   FVS: 0.23
   FVL: 0.02
                           Rate FormValidator::Simple   FormValidator::Lite
   FormValidator::Simple  353/s                    --                  -75%
   FormValidator::Lite   1429/s                  304%                    --

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF@ gmail.comE<gt>

=head1 THANKS TO

craftworks

nekokak

tomi-ru

=head1 SEE ALSO

L<FormValidator::Simple>, L<Data::FormValidator>, L<HTML::FormFu>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
