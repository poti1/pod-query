#!perl

package Role::Test::Module;

use Mojo::Base -role;
use Test::More;

#TODO: Remove this debug code !!!
use feature qw(say);
use Mojo::Util qw(dumper);

requires qw(
  lol
  expected_tree
  expected_find_title
  expected_find_events
  define_cases
  define_find_cases
);

sub run {
   my ( $obj, %parms ) = @_;
   my $module = "Mojo::UserAgent";

   use_ok( "Pod::Query" ) || print "Bail out!\n";
   diag( "Testing Pod::Query $Pod::Query::VERSION, Perl $], $^X" );
   pass "=== Using saved pod from $parms{module} ===";

   my $class_dir = "dir";
   my $class     = "MyClass";

   # TODO: Tidy up after restructuring Pod::Query.
   {
      no warnings qw( redefine once );
      $Pod::Query::MOCK_ROOT      = 1;
      *Pod::Query::_class_to_path = sub { "$class_dir/" . shift() . ".pm" };
      *Pod::Query::_mock_root     = sub { $obj->lol };
      *Pod::Query::get_term_width = sub { 56 };    # Match android.
   }

   my $query = Pod::Query->new( $class );

   # path.
   is_deeply( $query->{path}, "$class_dir/$class.pm", "path", );

   # tree.
   is_deeply( $query->{tree}, $obj->expected_tree, "tree", );

   # find_title.
   is( $query->find_title(), $obj->expected_find_title, "find_title" );

   # find_events.
   my $expected_find_events = $obj->expected_find_events;
   is(
      scalar $query->find_events,
      join( "\n", @$expected_find_events ),
      "find_events - scalar context"
   );
   is_deeply(
      [ $query->find_events ],
      $expected_find_events,
      "find_events - list context"
   );

   # Methods.
   my $cases = $obj->define_cases;
   for my $case ( @$cases ) {
      pass "=== Starting $module - method: $case->{method} ===";

      # say dumper [ $query->find_method( $case->{method} ) ];

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
   }

   # find.
   my $find_cases = $obj->define_find_cases;
   for my $case ( @$find_cases ) {
      my $debug = $case->{debug} // '';
      my $skip  = $case->{skip}  // '';

      if ( $skip ) {
       SKIP: {
            skip $skip;
         }
         next;
      }

      # say dumper [ $query->find_method( $case->{method} ) ];
      my $name     = "find - $case->{name}";
      my $find     = $case->{find} // [];
      my $expected = $case->{expected_find};

      # say dumper { find => $find };
      my $scalar_find = eval { $query->find( @$find ) };

      if ( $@ ) {
         $case->{error} ? pass( $name ) : fail( $name );
         next;
      }

      is( $scalar_find, join( "\n", @$expected ), "$name - scalar context", );

      {
         local $Pod::Query::DEBUG_FIND = 1 if $debug eq "find";
         my @list_find = $query->find( @$find );
         say dumper \@list_find
           unless is_deeply( \@list_find, $expected, "$name - list context", );
      };
   }

   done_testing();
}

1;
