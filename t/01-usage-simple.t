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
      name          => "Empty",
      pod_class     => $class++,
      lol           => [],
      expected_tree => [],
   },
   {
      name      => "Head1-Para",
      pod_class => $class++,
      lol       => [
         [ "head1", "NAME" ],
         [
            "Para",
            "Example - Just an example"
         ],

      ],
      expected_tree => [
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => ["Example - Just an example"]
               }
            ],
            "tag"  => "head1",
            "text" => ["NAME"]
         }
      ],
   },
   {
      name      => "Head1-Para (no cut)",
      pod_class => $class++,
      lol       => [
         [ "head1", "NAME" ],
         [
            "Para",
            "Example - Just an example"
         ],

      ],
      expected_tree => [
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => ["Example - Just an example"]
               }
            ],
            "tag"  => "head1",
            "text" => ["NAME"]
         }
      ],
   },
   {
      name          => "Head2",
      pod_class     => $class++,
      lol           => [ [ "head2", "Function1" ], ],
      expected_tree => [
         {
            "tag"  => "head2",
            "text" => ["Function1"]
         }
      ],
   },
   {
      name          => "Head2-Para",
      pod_class     => $class++,
      lol           => [ [ "head2", "Function1" ], [ "Para", "Summary" ], ],
      expected_tree => [
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => ["Summary"]
               }
            ],
            "tag"  => "head2",
            "text" => ["Function1"]
         }
      ],
   },
   {
      name      => "Head2-Para-Verbatim",
      pod_class => $class++,
      lol       => [
         [ "head2",    "Function1" ],
         [ "Para",     "Summary" ],
         [ "Verbatim", " Desc" ],
      ],
      expected_tree => [
         {
            "sub" => [
               {
                  "tag"  => "Para",
                  "text" => ["Summary"]
               },
               {
                  "tag"  => "Verbatim",
                  "text" => [" Desc"]
               }
            ],
            "tag"  => "head2",
            "text" => ["Function1"]
         }
      ],
   },
);

# TODO: Tidy up after restructuring Pod::Query.
$Pod::Query::MOCK_ROOT = 1;
{
   no warnings 'redefine';
   *Pod::Query::_class_to_path = sub { "$class_dir/" . shift() . ".pm" };
}

for my $case ( @cases ) {
   pass "=== Starting $case->{pod_class} - $case->{name} ===";

   # TODO: Tidy up after restructuring Pod::Query.
   {
      no warnings 'redefine';
      *Pod::Query::_mock_root = sub { $case->{lol} };
   }

   my $query = Pod::Query->new( $case->{pod_class} );

   # say "query=" . dumper $query;

   # Parse and compare
   is_deeply( $query->{path}, "$class_dir/$case->{pod_class}.pm", "path", );
   is_deeply( $query->{tree}, $case->{expected_tree},             "tree", );
}

done_testing();

