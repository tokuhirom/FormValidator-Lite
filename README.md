# NAME

FormValidator::Lite - lightweight form validation library

# SYNOPSIS

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

# DESCRIPTION

FormValidator::Lite is a simple, fast implementation for form validation.

IT'S IN BETA QUALITY. API MAY CHANGE IN THE FUTURE.

# HOW TO WRITE YOUR OWN CONSTRAINTS

Create your own constraint package as such :

    package MyApp::Validator::Constraint;
    use strict;
    use warnings;
    use FormValidator::Lite::Constraint;
    

    rule 'IS_EVEN' => sub {
        return $_ % 2 ? 0 : 1;
    };
    

    rule 'IS_GREATER_THAN' => sub {
        my ($min) = @_;
        return $_ >= $min;
    }
    alias 'IS_GREATER_THAN' => 'IS_BIGGER_THAN';
    

    1;

And in your controller :

    use FormValidator::Lite qw("+MyApp::Validator::Constraint");
    

    my $validator = FormValidator::Lite->new(...);
    $validator->set_message_data(...);
    $validator->check(
        some_param => [ 'UINT', 'IS_EVEN', ['IS_GREATER_THAN' => 42] ],
    );

When defining a rule keep in mind that the value for the parameter comes from
`$_` and the additional arguments defined in your validation
specifications come from `@_`.

# METHODS

- my $validator = FormValidator::Lite->new($q);

    Create a new instance.

    The constructor takes a mandatory argument `$q` that is a query-like 
    object such as Apache::Request, CGI.pm, Plack::Request. The object MUST have
    a `$q->param` method.

- $validator->query()
- $validator->query($query)

    Getter/Setter for the query attribute.

- $validator->check(@specs\_array)

    Validate the query against a set of specifications defined in the
    `@specs_array` argument. In the most common case, the array is a sequence
    of pairs : the first item is the parameter name and the second item is an
    array reference with a list of constraint rules to apply on the query's value
    for the parameter.

        my $res = $validator->check(
            name      => [qw/NOT_NULL/],
            name_kana => [qw/NOT_NULL KATAKANA/],
            {mails => [qw/mail1 mail2/]} => ['DUPLICATION'],
        );

    In the above example _name_ is a parameter. _NOT\_NULL_, _KATAKANA_ and
    _DUPLICATION_ are the names of the constraints.

- $validator->is\_error($key)

    Return true value if there is an error for the `$key` parameter.

- $validator->is\_valid()

    Return true value if `$validator` didn't detect any error.

    This is the same as `!$validator->has_error()`.

- $validator->has\_error()

    Return true value if `$validator` detects error.

    This is the same as `!$validator->is_valid()`.

- $validator->set\_error($param, $rule\_name)

    Manually set a new error for the parameter named `$param`. The rule's name
    is `$rule_name`.

- $validator->errors()

    Return all the errors as a hash reference where the keys are the parameters
    and the values are a hash reference with the failing constraints.
        

        {
            'foo' => { 'NOT_NULL' => 1, 'INT' => 1 },
            'bar' => { 'EMAIL' => 1, },
        }

- $validator->load\_constraints($name)

        $validator->load_constraints("DATE", "Email");

        # or load your own constraints
        $validator->load_constraints("+MyApp::FormValidator::Lite::Constraint");

    You can also load the constraints during import :

        use FormValidator::Lite qw/Date Email/;

    Load constraint components named `"FormValidator::Lite::Constraint::${name}"`.

- $validator->load\_function\_message($lang)

        $validator->load_function_message('ja');

    Load function message file.

    Currently, [FormValidator::Lite::Messages::ja](http://search.cpan.org/perldoc?FormValidator::Lite::Messages::ja) and
    [FormValidator::Lite::Messages::en](http://search.cpan.org/perldoc?FormValidator::Lite::Messages::en) are available.

- $validator->set\_param\_message($param => $message, ...)
    

        $validator->set_param_message(
            name => 'Your Name',
        );

    Add a message-friendly description for the parameter.

- $validator->set\_message("$param.$func" => $message)

        $v->set_message('zip.jzip' => 'Please input correct zip number.');

    Set an error message for a given $param and $func pair.

- $validator->set\_message\_data({ message => $msg, param => $param, function => $function })

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
    `[_1]` will be replaced by `build_message` with the description of
    the failing parameter provided in the 'param' section.

- `$validator->build_message($tmpl, @args)`

    replace \[\_1\] in `$tmpl` by `@args`.

    Setup error message map.

- `$validator->set_message("$param.$func" => $message)`

        $v->set_message('zip.jzip' => 'Please input correct zip number.');

    Note that it will void any previous calls to `load_function_message`,
    `set_message` or `set_param_message`.

- my @errors = $validator->get\_error\_messages()
- my $errors = $validator->get\_error\_messages()

    Get all the error messages for the query. This method returns an array in list
    context and an array reference otherwise.

- my $msg = $validator->get\_error\_message($param => $func)

    Generate the error message for parameter `$param` and function
    `$func`.

- my @msgs = $validator->get\_error\_messages\_from\_param($param)

    Get all the error messages for the parameter `$param`.

# WHY NOT FormValidator::Simple?

Yes, I know. This module is very similar with FV::S.

But, FormValidator::Simple is too heavy for me.
FormValidator::Lite is fast!

    Perl: 5.010000
    FVS: 0.23
    FVL: 0.02
                            Rate FormValidator::Simple   FormValidator::Lite
    FormValidator::Simple  353/s                    --                  -75%
    FormValidator::Lite   1429/s                  304%                    --

# AUTHOR

Tokuhiro Matsuno <tokuhirom AAJKLFJEF@ gmail.com>

# THANKS TO

craftworks

nekokak

tomi-ru

# SEE ALSO

[FormValidator::Simple](http://search.cpan.org/perldoc?FormValidator::Simple), [Data::FormValidator](http://search.cpan.org/perldoc?Data::FormValidator), [HTML::FormFu](http://search.cpan.org/perldoc?HTML::FormFu)

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
