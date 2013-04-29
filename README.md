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
    if ( ..... return_true_when_if_error() ..... ) {
        $validator->set_error('login_id' => 'DUPLICATION');
    }
    if ($validator->has_error) {
        ...
    }

    # in your tmpl
    <ul>
    ? for my $msg ($validator->get_error_messages) {
        <li><?= $msg ?></li>
    ? }
    </ul>

# DESCRIPTION

FormValidator::Lite is simple, fast implementation for form validation.

IT'S IN BETA QUALITY. API MAY CHANGE IN FUTURE.

# HOW TO WRITE YOUR OWN CONSTRAINTS

    http parameter comes from $_
    validator args comes from @_

# METHODS

- my $validator = FormValidator::Lite->new($q);

    Create a new instance.

    $q is query like object, such as Apache::Request, CGI.pm, Plack::Request.
    The object MUST have a `$q->param` method.

- $validator->query()
- $validator->query($query)

    Getter/Setter for query like object.

- $validator->check(@rule\_ary)

        my $res = $validator->check(
            name      => [qw/NOT_NULL/],
            name_kana => [qw/NOT_NULL KATAKANA/],
            {mails => [qw/mail1 mail2/]} => ['DUPLICATION'],
        );

    This method do validation. You can write a rule in `@rule_ary`. In above example code, _name_
    is a parameter name, _NOT\_NULL_, _KATAKANA_ and _DUPLICATION_ are name of constraints.

- $validator->is\_error($key)

    Return true value if parameter named `$key` got error.

- $validator->is\_valid()

    Return true value if `$validator` don't detects error.

    This is same as `!$validator->has_error()`.

- $validator->has\_error()

    Return true value if `$validator` detects error.

    This is same as `!$validator->is_valid()`.

- $validator->set\_error($param, $rule\_name)

    Set new error to parameter named `<$param`\>. The rule name is `<$rule_name`\>.

- $validator->errors()

    Return whole errors as HashRef.
        

        {
            'foo' => { 'NOT_NULL' => 1, 'INT' => 1 },
            'bar' => { 'EMAIL' => 1, },
        }

- $validator->load\_constraints($name)

        $validator->load_constraints("DATE", "Email");

        # or load your own constraints
        $validator->load_constraints("+MyApp::FormValidator::Lite::Constraint");

    There is a import style.

        use FormValidator::Lite qw/Date Email/;

    load constraint components named `"FormValidator::Lite::Constraint::${name}"`.

- $validator->load\_function\_message($lang)

        $validator->load_function_message('ja');

    Load function message file.

    Currently, [FormValidator::Lite::Messages::ja](http://search.cpan.org/perldoc?FormValidator::Lite::Messages::ja) and [FormValidator::Lite::Messages::en](http://search.cpan.org/perldoc?FormValidator::Lite::Messages::en) are available.

- $validator->set\_param\_message($param => $message, ...)
    

        $validator->set_param_message(
            name => 'Your Name',
        );

    Make relational map for the parameter name to human readable name.

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

    Setup error message map.

- `$validator->set_message("$param.$func" => $message)`

        $v->set_message('zip.jzip' => 'Please input correct zip number.');

    Set error message for the $param and $func.

- my @errors = $validator->get\_error\_messages()
- my $errors = $validator->get\_error\_messages()

    Get whole error messages for `<$q`\> in array/arrayref.
    This method returns array in list context, otherwise HashRef.

- my $msg = $validator->get\_error\_message($param => $func)

    Generate error message for parameter $param and function named $func.

- my @msgs = $validator->get\_error\_messages\_from\_param($param)

    Get error messages by $q for parameter $param.

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
