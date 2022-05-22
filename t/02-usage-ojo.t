#!perl
use v5.16;
use strict;
use warnings;
use Test::More;

#TODO: Remove this debug code !!!
use feature qw(say);
use Mojo::Util qw(dumper);

BEGIN {
   use_ok( 'Pod::Query' ) || print "Bail out!\n";
}

diag( "Testing Pod::Query $Pod::Query::VERSION, Perl $], $^X" );

my $class_dir = "dir";
my $class     = "MyClass1";

my @cases = (
   {
      name      => "Usage",
      pod_class => $class,
      lol       => [
         [ "head1", "NAME" ],
         [ "Para",  "ojo - Fun one-liners with Mojo" ],
         [ "head1", "SYNOPSIS" ],
         [
            "Verbatim",
"  \$ perl -Mojo -E 'say g(\"mojolicious.org\")->dom->at(\"title\")->text'"
         ],
         [ "head1", "DESCRIPTION" ],
         [
            "Para",
"A collection of automatically exported functions for fun Perl one-liners. Ten redirects will be followed by default, you can change this behavior with the MOJO_MAX_REDIRECTS environment variable."
         ],
         [
            "Verbatim",
"  \$ MOJO_MAX_REDIRECTS=0 perl -Mojo -E 'say g(\"example.com\")->code'"
         ],
         [
            "Para",
"Proxy detection is enabled by default, but you can disable it with the MOJO_PROXY environment variable."
         ],
         [
            "Verbatim",
            "  \$ MOJO_PROXY=0 perl -Mojo -E 'say g(\"example.com\")->body'"
         ],
         [
            "Para",
"TLS certificate verification can be disabled with the MOJO_INSECURE environment variable."
         ],
         [
            "Verbatim",
"  \$ MOJO_INSECURE=1 perl -Mojo -E 'say g(\"https://127.0.0.1:3000\")->body'"
         ],
         [
            "Para",
            "Every ojo one-liner is also a Mojolicious::Lite application."
         ],
         [
            "Verbatim",
"  \$ perl -Mojo -E 'get \"/\" => {inline => \"%= time\"}; app->start' get /"
         ],
         [
            "Para",
            "On Perl 5.20+ subroutine signatures will be enabled automatically."
         ],
         [
            "Verbatim",
"  \$ perl -Mojo -E 'a(sub (\$c) { \$c->render(text => \"Hello!\") })->start' get /"
         ],
         [
            "Para",
"If it is not already defined, the MOJO_LOG_LEVEL environment variable will be set to fatal."
         ],
         [ "head1", "FUNCTIONS" ],
         [
            "Para",
"ojo implements the following functions, which are automatically exported."
         ],
         [ "head2", "a" ],
         [
            "Verbatim",
"  my \$app = a('/hello' => sub { \$_->render(json => {hello => 'world'}) });"
         ],
         [
            "Para",
"Create a route with \"any\" in Mojolicious::Lite and return the current Mojolicious::Lite object. The current controller object is also available to actions as \$_. See also Mojolicious::Guides::Tutorial for more argument variations."
         ],
         [
            "Verbatim",
"  \$ perl -Mojo -E 'a(\"/hello\" => {text => \"Hello Mojo!\"})->start' daemon"
         ],
         [ "head2",    "b" ],
         [ "Verbatim", "  my \$stream = b('lalala');" ],
         [ "Para",     "Turn string into a Mojo::ByteStream object." ],
         [
            "Verbatim",
"  \$ perl -Mojo -E 'b(g(\"mojolicious.org\")->body)->html_unescape->say'"
         ],
         [ "head2",    "c" ],
         [ "Verbatim", "  my \$collection = c(1, 2, 3);" ],
         [ "Para",     "Turn list into a Mojo::Collection object." ],
         [ "head2",    "d" ],
         [
            "Verbatim",
"  my \$res = d('example.com');\n  my \$res = d('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = d('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = d('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform DELETE request with \"delete\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
         ],
         [ "head2",    "f" ],
         [ "Verbatim", "  my \$path = f('/home/sri/foo.txt');" ],
         [ "Para",     "Turn string into a Mojo::File object." ],
         [
            "Verbatim", "  \$ perl -Mojo -E 'say r j f(\"hello.json\")->slurp'"
         ],
         [ "head2", "g" ],
         [
            "Verbatim",
"  my \$res = g('example.com');\n  my \$res = g('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = g('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = g('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform GET request with \"get\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
         ],
         [
            "Verbatim",
"  \$ perl -Mojo -E 'say g(\"mojolicious.org\")->dom(\"h1\")->map(\"text\")->join(\"\\n\")'"
         ],
         [ "head2", "h" ],
         [
            "Verbatim",
"  my \$res = h('example.com');\n  my \$res = h('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = h('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = h('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform HEAD request with \"head\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
         ],
         [ "head2", "j" ],
         [
            "Verbatim",
"  my \$bytes = j([1, 2, 3]);\n  my \$bytes = j({foo => 'bar'});\n  my \$value = j(\$bytes);"
         ],
         [
            "Para",
"Encode Perl data structure or decode JSON with \"j\" in Mojo::JSON."
         ],
         [
            "Verbatim",
"  \$ perl -Mojo -E 'f(\"hello.json\")->spurt(j {hello => \"world!\"})'"
         ],
         [ "head2",    "l" ],
         [ "Verbatim", "  my \$url = l('https://mojolicious.org');" ],
         [ "Para",     "Turn a string into a Mojo::URL object." ],
         [
            "Verbatim",
"  \$ perl -Mojo -E 'say l(\"/perldoc\")->to_abs(l(\"https://mojolicious.org\"))'"
         ],
         [ "head2",    "n" ],
         [ "Verbatim", "  n {...};\n  n {...} 100;" ],
         [
            "Para",
"Benchmark block and print the results to STDERR, with an optional number of iterations, which defaults to 1."
         ],
         [
            "Verbatim",
            "  \$ perl -Mojo -E 'n { say g(\"mojolicious.org\")->code }'"
         ],
         [ "head2", "o" ],
         [
            "Verbatim",
"  my \$res = o('example.com');\n  my \$res = o('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = o('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = o('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform OPTIONS request with \"options\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
         ],
         [ "head2", "p" ],
         [
            "Verbatim",
"  my \$res = p('example.com');\n  my \$res = p('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = p('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = p('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform POST request with \"post\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
         ],
         [ "head2",    "r" ],
         [ "Verbatim", "  my \$perl = r({data => 'structure'});" ],
         [
            "Para", "Dump a Perl data structure with \"dumper\" in Mojo::Util."
         ],
         [
            "Verbatim",
            "  perl -Mojo -E 'say r g(\"example.com\")->headers->to_hash'"
         ],
         [ "head2", "t" ],
         [
            "Verbatim",
"  my \$res = t('example.com');\n  my \$res = t('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = t('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = t('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform PATCH request with \"patch\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
         ],
         [ "head2", "u" ],
         [
            "Verbatim",
"  my \$res = u('example.com');\n  my \$res = u('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = u('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = u('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
         ],
         [
            "Para",
"Perform PUT request with \"put\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
         ],
         [ "head2",    "x" ],
         [ "Verbatim", "  my \$dom = x('<div>Hello!</div>');" ],
         [ "Para",     "Turn HTML/XML input into Mojo::DOM object." ],
         [
            "Verbatim",
"  \$ perl -Mojo -E 'say x(f(\"test.html\")->slurp)->at(\"title\")->text'"
         ],
         [ "head1", "SEE ALSO" ],
         [
            "Para",
            "Mojolicious, Mojolicious::Guides, https://mojolicious.org."
         ]
      ],
      expected_tree => [
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => ["ojo - Fun one-liners with Mojo"]
               }
            ],
            "tag"  => "head1",
            "text" => ["NAME"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Verbatim",
                  "text" => [
"  \$ perl -Mojo -E 'say g(\"mojolicious.org\")->dom->at(\"title\")->text'"
                  ]
               }
            ],
            "tag"  => "head1",
            "text" => ["SYNOPSIS"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => [
"A collection of automatically exported functions for fun Perl one-liners. Ten redirects will be followed by default, you can change this behavior with the MOJO_MAX_REDIRECTS environment variable."
                  ]
               },
               {
                  "tag"  => "Verbatim",
                  "text" => [
"  \$ MOJO_MAX_REDIRECTS=0 perl -Mojo -E 'say g(\"example.com\")->code'"
                  ]
               },
               {
                  "tag"  => "Para",
                  "text" => [
"Proxy detection is enabled by default, but you can disable it with the MOJO_PROXY environment variable."
                  ]
               },
               {
                  "tag"  => "Verbatim",
                  "text" => [
"  \$ MOJO_PROXY=0 perl -Mojo -E 'say g(\"example.com\")->body'"
                  ]
               },
               {
                  "tag"  => "Para",
                  "text" => [
"TLS certificate verification can be disabled with the MOJO_INSECURE environment variable."
                  ]
               },
               {
                  "tag"  => "Verbatim",
                  "text" => [
"  \$ MOJO_INSECURE=1 perl -Mojo -E 'say g(\"https://127.0.0.1:3000\")->body'"
                  ]
               },
               {
                  "tag"  => "Para",
                  "text" => [
"Every ojo one-liner is also a Mojolicious::Lite application."
                  ]
               },
               {
                  "tag"  => "Verbatim",
                  "text" => [
"  \$ perl -Mojo -E 'get \"/\" => {inline => \"%= time\"}; app->start' get /"
                  ]
               },
               {
                  "tag"  => "Para",
                  "text" => [
"On Perl 5.20+ subroutine signatures will be enabled automatically."
                  ]
               },
               {
                  "tag"  => "Verbatim",
                  "text" => [
"  \$ perl -Mojo -E 'a(sub (\$c) { \$c->render(text => \"Hello!\") })->start' get /"
                  ]
               },
               {
                  "tag"  => "Para",
                  "text" => [
"If it is not already defined, the MOJO_LOG_LEVEL environment variable will be set to fatal."
                  ]
               }
            ],
            "tag"  => "head1",
            "text" => ["DESCRIPTION"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => [
"ojo implements the following functions, which are automatically exported."
                  ]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$app = a('/hello' => sub { \$_->render(json => {hello => 'world'}) });"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Create a route with \"any\" in Mojolicious::Lite and return the current Mojolicious::Lite object. The current controller object is also available to actions as \$_. See also Mojolicious::Guides::Tutorial for more argument variations."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ perl -Mojo -E 'a(\"/hello\" => {text => \"Hello Mojo!\"})->start' daemon"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["a"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => ["  my \$stream = b('lalala');"]
                     },
                     {
                        "tag"  => "Para",
                        "text" =>
                          ["Turn string into a Mojo::ByteStream object."]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ perl -Mojo -E 'b(g(\"mojolicious.org\")->body)->html_unescape->say'"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["b"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => ["  my \$collection = c(1, 2, 3);"]
                     },
                     {
                        "tag"  => "Para",
                        "text" => ["Turn list into a Mojo::Collection object."]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["c"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$res = d('example.com');\n  my \$res = d('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = d('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = d('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform DELETE request with \"delete\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["d"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => ["  my \$path = f('/home/sri/foo.txt');"]
                     },
                     {
                        "tag"  => "Para",
                        "text" => ["Turn string into a Mojo::File object."]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ perl -Mojo -E 'say r j f(\"hello.json\")->slurp'"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["f"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$res = g('example.com');\n  my \$res = g('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = g('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = g('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform GET request with \"get\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ perl -Mojo -E 'say g(\"mojolicious.org\")->dom(\"h1\")->map(\"text\")->join(\"\\n\")'"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["g"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$res = h('example.com');\n  my \$res = h('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = h('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = h('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform HEAD request with \"head\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["h"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$bytes = j([1, 2, 3]);\n  my \$bytes = j({foo => 'bar'});\n  my \$value = j(\$bytes);"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Encode Perl data structure or decode JSON with \"j\" in Mojo::JSON."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ perl -Mojo -E 'f(\"hello.json\")->spurt(j {hello => \"world!\"})'"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["j"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => ["  my \$url = l('https://mojolicious.org');"]
                     },
                     {
                        "tag"  => "Para",
                        "text" => ["Turn a string into a Mojo::URL object."]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ perl -Mojo -E 'say l(\"/perldoc\")->to_abs(l(\"https://mojolicious.org\"))'"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["l"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => ["  n {...};\n  n {...} 100;"]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Benchmark block and print the results to STDERR, with an optional number of iterations, which defaults to 1."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ perl -Mojo -E 'n { say g(\"mojolicious.org\")->code }'"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["n"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$res = o('example.com');\n  my \$res = o('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = o('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = o('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform OPTIONS request with \"options\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["o"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$res = p('example.com');\n  my \$res = p('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = p('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = p('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform POST request with \"post\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["p"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => ["  my \$perl = r({data => 'structure'});"]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Dump a Perl data structure with \"dumper\" in Mojo::Util."
                        ]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  perl -Mojo -E 'say r g(\"example.com\")->headers->to_hash'"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["r"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$res = t('example.com');\n  my \$res = t('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = t('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = t('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform PATCH request with \"patch\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["t"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  my \$res = u('example.com');\n  my \$res = u('http://example.com' => {Accept => '*/*'} => 'Hi!');\n  my \$res = u('http://example.com' => {Accept => '*/*'} => form => {a => 'b'});\n  my \$res = u('http://example.com' => {Accept => '*/*'} => json => {a => 'b'});"
                        ]
                     },
                     {
                        "tag"  => "Para",
                        "text" => [
"Perform PUT request with \"put\" in Mojo::UserAgent and return resulting Mojo::Message::Response object."
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["u"]
               },
               {
                  "sub" => [
                     {
                        "tag"  => "Verbatim",
                        "text" => ["  my \$dom = x('<div>Hello!</div>');"]
                     },
                     {
                        "tag"  => "Para",
                        "text" => ["Turn HTML/XML input into Mojo::DOM object."]
                     },
                     {
                        "tag"  => "Verbatim",
                        "text" => [
"  \$ perl -Mojo -E 'say x(f(\"test.html\")->slurp)->at(\"title\")->text'"
                        ]
                     }
                  ],
                  "tag"  => "head2",
                  "text" => ["x"]
               }
            ],
            "tag"  => "head1",
            "text" => ["FUNCTIONS"]
         },
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => [
"Mojolicious, Mojolicious::Guides, https://mojolicious.org."
                  ]
               }
            ],
            "tag"  => "head1",
            "text" => ["SEE ALSO"]
         }
      ],
      expected_find_title  => "ojo - Fun one-liners with Mojo",
      method               => "x",
      expected_find_method => [
         "x:",
         "",
         "  my \$dom = x('<div>Hello!</div>');",
         "",
         "  Turn HTML/XML input into Mojo::DOM object.",
         "",
"  \$ perl -Mojo -E 'say x(f(\"test.html\")->slurp)->at(\"title\")->text'",
         ""
      ],
      expected_find_method_summary =>
        "Turn HTML/XML input into Mojo::DOM object.",
      expected_find_events => {},
   },
);

# TODO: Tidy up after restructuring Pod::Query.
$Pod::Query::MOCK_ROOT = 1;
{
   no warnings 'redefine';
   *Pod::Query::_class_to_path = sub { "$class_dir/" . shift() . ".pm" };
}

for my $case ( @cases ) {
   pass
"=== Starting $case->{pod_class} - $case->{name} - method:$case->{method} ===";

   # TODO: Tidy up after restructuring Pod::Query.
   {
      no warnings 'redefine';
      *Pod::Query::_mock_root = sub { $case->{lol} };
   }

   my $query = Pod::Query->new( $case->{pod_class} );

   # path.
   is_deeply( $query->{path}, "$class_dir/$case->{pod_class}.pm", "path", );

   # tree.
   is_deeply( $query->{tree}, $case->{expected_tree}, "tree", );

   # find_title.
   is(
      $query->find_title(),
      $case->{expected_find_title},
      "find_title - scalar context"
   );
   is_deeply(
      [ $query->find_title ],
      [ $case->{expected_find_title} ],
      "find_title - list context"
   );

   # find_method.
   is(
      scalar $query->find_method( $case->{method} ),
      join( "\n", @{ $case->{expected_find_method} } ),
      "find_method($case->{method}) - scalar context"
   );
   is_deeply(
      [ $query->find_method( $case->{method} ) ],
      [ @{ $case->{expected_find_method} } ],
      "find_method($case->{method}) - list context"
   );

   # find_method_summary.
   is(
      scalar $query->find_method_summary( $case->{method} ),
      $case->{expected_find_method_summary},
      "find_method_summary($case->{method}) - scalar context"
   );
   is_deeply(
      [ $query->find_method_summary( $case->{method} ) ],
      [ $case->{expected_find_method_summary} ],
      "find_method_summary($case->{method}) - list context"
   );

   # find_events.
   is_deeply(
      { $query->find_events },
      $case->{expected_find_events},
      "find_events - list context"
   );
}

done_testing();

