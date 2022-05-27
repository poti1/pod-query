package Pod::Query;

use v5.24;    # Postfix defef :)
use strict;
use warnings;
use FindBin qw/ $RealBin /;

# use lib "$RealBin/Pod-LOL/lib";
use Carp qw/ croak /;
use List::Util qw/ first /;
use Mojo::Base qw/ -base -signatures /;
use Mojo::Util qw/ dumper class_to_path /;
use Mojo::ByteStream qw/ b/;
use Term::ReadKey qw/ GetTerminalSize /;
use Pod::Text();
use Pod::LOL;

=head1 NAME

Pod::Query - Query pod documents

=head1 VERSION

Version 0.07

=cut

our $VERSION      = '0.07';
our $DEBUG_TREE   = 0;
our $DEBUG_FIND   = 0;
our $DEBUG_INVERT = 0;
our $DEBUG_RENDER = 0;
our $MOCK_ROOT    = 0;


has [
   qw/
     path lol
     tree
     title
     events
     /
];

=head1 SYNOPSIS

Query POD information from a file

	use Pod::Query;
	my $pod = Pod::Query->new('Pod::LOL');

$pod contains the Pod::LOL object and a tree like:

 "tree" => [
    {
      "kids" => [
        {
          "tag" => "Para",
          "text" => [
            "Pod::LOL - Transform POD into a list of lists"
          ]
        }
      ],
      "tag" => "head1",
      "text" => [
        "NAME"
      ]
    },
    {
      "kids" => [
        {
          "tag" => "Para",
          "text" => [
            "Version 0.01"
          ]
        }
      ],
      "tag" => "head1",
      "text" => [
        "VERSION"
      ]
    },
    ...

Find Methods:

	say $pod->find_title;
	say $pod->find_method;
	say $pod->find_method_summary;
	say $pod->find_events;
	say $pod->find(@queries);

Inline (Debugging)
	perl -IPod-Query/lib -MPod::Query -MMojo::Util=dumper -E "say dumper(Pod::Query->new('Pod::LOL'))"

=head1 DESCRIPTION

This module takes a class name, extracts the POD
and provides methods to query specific information.

=head1 SUBROUTINES/METHODS

=head2 new

Create a new object.

=cut

sub new ( $class, $pod_class, $path_only = 0 ) {
   state %CACHE;

   my $cached;
   return $cached if $cached = $CACHE{$pod_class};

   my $s = bless {
      pod_class => $pod_class,
      path      => _class_to_path( $pod_class ),
   }, $class;

   return $s if $path_only;

   my $lol = $MOCK_ROOT ? _mock_root() : Pod::LOL->new_root( $s->path );
   $lol = _flatten_for_tags( $lol );

   $s->lol( $lol );
   $s->tree( _lol_to_tree( $lol ) );

   $CACHE{$pod_class} = $s;

   $s;
}


=head2 _class_to_path

Given a class name, retuns the path to the pod file.

=cut

sub _class_to_path ( $pod_class ) {
   state %CACHE;
   my $p;

   return $p if $p = $CACHE{$pod_class};

   $p = $INC{ class_to_path( $pod_class ) };
   return $CACHE{$pod_class} = $p if $p;

   $p = qx(perldoc -l $pod_class);
   chomp $p;
   return $CACHE{$pod_class} = $p if $p;

   croak "Missing: pod_class=$pod_class";
}


=head2 _mock_root

For debugging only.
Builds a sample object.

=cut

sub _mock_root {
   [

      [ "head1",    "HEAD1", ],
      [ "head2",    "HEAD2_1", ],
      [ "Verbatim", "HEAD2_1-VERBATIM_1", ],
      [ "Para",     "HEAD2_1-PARA_1" . ( "long" x 20 ), ],
      [ "Verbatim", "HEAD2_1-VERBATIM_2", ],
      [ "Para",     "HEAD2_1-PARA_2", ],
      [ "head2",    "HEAD2_2", ],
      [ "Verbatim", "HEAD2_2-VERBATIM_1", ],
      [ "Para",     "HEAD2_2-PARA_1", ],
      [ "Para",     "OPTS:", ],
      [
         "over-text",
         [ "item-text", "OPT-A", ],
         [ "Verbatim",  "OPT-A => 1", ],
         [ "Para",      "OPT-A DESC", ],
         [ "item-text", "OPT-B", ],
         [ "Verbatim",  "OPT-B => 1", ],
         [ "Para",      "OPT-B DESC", ],
      ],
      [ "Verbatim", "HEAD2_2-VERBATIM_2", ],
      [ "Para",     "HEAD2_2-PARA_2", ],

   ]
}

=head2 _flatten_for_tags

Removes for tags from the lol and flattens
out the inner tags to be on the same level as the for
tag was.

=cut

sub _flatten_for_tags ( $lol ) {
   my @flat;

   for ( @$lol ) {
      my ( $tag, @data ) = @$_;
      $tag //= '';

      push @flat, ( $tag eq "for" ) ? @data : $_;
   }

   \@flat;
}

=head2 _lol_to_tree

Transforms a Pod::LOL object into a structured
tree.

=cut

sub _lol_to_tree ( $lol ) {
   my ( $is_in, $is_out );
   my $is_head = qr/ ^ head (\d) $ /x;
   my @tree;
   my $node = {};

   my $push = sub {    # push to tree.
      return if not %$node;
      my $kids     = $node->{kids};    # sub tags
      my $has_head = ref( $kids ) && first { $_->{tag} =~ /$is_head/ } @$kids;
      $node->{kids} = _lol_to_tree( $kids ) if $has_head;
      push @tree, $node;
      $node = {};
   };

   say "\n_ROOT_TO_TREE()" if $DEBUG_TREE;

   for ( $lol->@* ) {
      say "\n_=", dumper $_ if $DEBUG_TREE;

      my $leaf = _make_leaf( $_ );
      say "\nleaf=", dumper $leaf if $DEBUG_TREE;

      # Outer tag.
      if ( not $is_in or $leaf->{tag} =~ /$is_out/ ) {
         $push->();
         $node = $leaf;
         if ( $leaf->{tag} =~ /$is_head/ ) {
            ( $is_in, $is_out ) = _get_heads_regex( $1 );
         }
      }
      else {
         $node->{kids} //= [];
         push $node->{kids}->@*, $leaf;
         say "node: ", dumper $node if $DEBUG_TREE;
      }
   }

   $push->();

   \@tree;
}


=head2 _make_leaf

Creates a new node (aka leaf).

=cut

sub _make_leaf ( $node ) {
   return $node if ref $node eq ref {};

   my ( $tag, @text ) = @$node;
   my $leaf = {
      tag  => $tag,
      text => \@text,
   };

   # TODO: Why have this since most pod are not using "over-text"?
   if ( $tag eq "over-text" ) {
      $leaf->{is_over} = 1;
      $leaf->{text}    = _structure_over( \@text );
   }

   $leaf;
}


=head2 _structure_over

Restructures the text for an "over-text" element.

=cut

sub _structure_over ( $text_list ) {
   my @struct;
   my @q;

   for ( @$text_list ) {
      my ( $tag, $text ) = @$_;
      if ( $tag eq "item-text" ) {
         push @struct, [ splice @q ] if @q;
      }

      push @q, $_;
   }

   push @struct, [ splice @q ] if @q;

   \@struct;
}


=head2 _get_heads_regex

Generates the regexes for head elements inside
and outside the current head.

=cut

sub _get_heads_regex ( $num ) {
   my $inner  = join "", ( $num + 1 .. 5 );    # num=2, inner=345
   my $outer  = join "", ( 0 .. $num );        # num=2, outer=012
   my $is_in  = qr/ ^ head ([$inner]) $ /x;
   my $is_out = qr/ ^ head ([$outer]) $ /x;

   ( $is_in, $is_out );
}


=head2 find_title

Extracts the title information.

=cut

sub find_title ( $s ) {
   scalar $s->find(
      {
         tag  => "head1",
         text => "NAME",
         nth  => 0,
      },
      {
         tag => "Para",
         nth => 0,
      },
   );
}


=head2 find_method

Extracts the complete method information.

=cut

sub find_method ( $s, $method ) {
   $s->find(
      {
         tag      => qr/ ^ head \d $ /x,
         text     => quotemeta( $method ) . $s->_is_function_call,
         nth      => 0,
         keep_all => 1,
      },
   );
}


=head2 find_method_summary

Extracts the method summary.

=cut

sub find_method_summary ( $s, $method ) {
   scalar $s->find(
      {
         tag  => qr/ ^ head \d $ /x,
         text => quotemeta( $method ) . $s->_is_function_call,
         nth  => 0,
      },
      {
         tag => qr/ (?: Data | Para ) /x,
         nth => 0,
      },
   );
}


=head2 _is_function_call

Regex for function call parenthesis.

=cut

sub _is_function_call {

   # Optional "()".
   qr/ (?:
         \( [^()]* \)
      )?
   /x;
}


=head2 find_events

Extracts a list of events with a description.

Returns a list of key value pairs.

=cut

sub find_events ( $s ) {
   $s->find(
      {
         tag  => qr/ ^ head \d $ /x,
         text => "EVENTS",
         nth  => 0,
      },
      {
         tag  => qr/ ^ head \d $ /x,
         keep => 1,
      },
      {
         tag       => "Para",
         nth_group => 0,
      },
   );
}


=head2 find

Generic extraction command.

context sensitive!

   $pod->find(@sections)

   Where each condition can contain:
   {
      tag       => "TAG_NAME",    # Find all matching tags.
      text      => "TEXT_NAME",   # Find all matching texts.
      keep      => 1,             # Capture the text.
      keep_all  => 1,             # Capture entire section.
      nth       => 0,             # Use only the nth match.
      nth_group => 0,             # Use only the nth matching group.
   }

   # Return contents of entire head section:
   find (
      {tag => "head", text => "a", keep_all => 1},
   )

   # Results:
   # [
   #    "  my \$app = a('/hel...",
   #    {text => "Create a route with ...", wrap => 1},
   #    "  \$ perl -Mojo -E ...",
   # ]

=cut

sub find ( $s, @find_conditions ) {

   _check_conditions( \@find_conditions );
   _set_condition_defaults( \@find_conditions );

   my @tree = $s->tree->@*;
   my $kept_all;

   for ( @find_conditions ) {
      @tree = _find( $_, @tree );
      if ( $_->{keep_all} ) {
         $kept_all++;
         last;
      }
   }

   if ( not $kept_all ) {
      @tree = _invert( @tree );
   }

   _render( $kept_all, @tree );
}


=head2 _check_conditions

Check if queries are valid.

=cut

sub _check_conditions ( $sections ) {

   my $error_message = <<~'ERROR';

      Invalid input: expecting a hash reference!

      Syntax:

         $pod->find(
            # section1
            {
               tag       => "TAG",  # Search to look for.
               text      => "TEXT", # Text of the tag to find.
               keep      => 1,      # Must only be in last section.
               keep_all  => 1,      # Keep this tag and sub tags.
               nth       => 0,      # Stop searching after find so many matches.
               nth_group => 0,      # Nth only in the current group.
            },
            # ...
            # conditionN
         );
   ERROR

   die "$error_message"
     if not $sections
     or not @$sections
     or grep { ref() ne ref {} } @$sections;

   # keep_all should only be in the last section
   my $last = $#$sections;
   while ( my ( $n, $section ) = each @$sections ) {
      die "Error: keep_all is not in last query!\n"
        if $section->{keep_all} and $n < $last;
   }

   # Cannot use both nth and nth_group (makes no sense, plus may cause errors)
   while ( my ( $n, $section ) = each @$sections ) {
      die "Error: nth and nth_group are exclusive!\n"
        if defined $section->{nth}
        and defined $section->{nth_group};
   }
}


=head2 _set_condition_defaults

Assigns default query options.

=cut

sub _set_condition_defaults ( $conditions ) {
   for my $condition ( @$conditions ) {

      # Text Options
      for ( qw/ tag text / ) {
         if ( defined $condition->{$_} ) {
            if ( ref $condition->{$_} ne ref qr// ) {
               $condition->{$_} = qr/ ^ $condition->{$_} $ /x;
            }
         }
         else {
            $condition->{$_} = qr/./;
         }
      }

      # Bit Options
      for ( qw/ keep keep_all / ) {
         if ( defined $condition->{$_} ) {
            $condition->{$_} = !!$condition->{$_};
         }
         else {
            $condition->{$_} = 0;
         }
      }

      # Range Options
      my $is_digit = qr/ ^ -?\d+ $ /x;
      for ( qw/ nth nth_group / ) {
         my $v = $condition->{$_};
         if ( defined $v and $v =~ /$is_digit/ ) {
            $v ||= "0 but true";
            my $end  = ( $v >= 0 ) ? "pos" : "neg";    # Set negative or
            my $name = "_${_}_$end";                   # positive form.
            $condition->{$name} = $v;
         }
      }

   }
}


=head2 _find

Lower level find command.

TODO: Need to clean this up and possibly restructure.

=cut

sub _find ( $need, @groups ) {
   if ( $DEBUG_FIND ) {
      say "\n_FIND()";
      say "need:   ", dumper $need;
      say "groups: ", dumper \@groups;
   }

   my $nth_p       = $need->{_nth_pos};         # Simplify code by already
   my $nth_n       = $need->{_nth_neg};         # knowing if neg or pos.
   my $nth_group_p = $need->{_nth_grou_pos};    # Set in _set_section_defaults.
   my $nth_group_n = $need->{_nth_grou_neg};
   my @found;

 GROUP:
   for my $group ( @groups ) {
      my @tries = ( $group );                  # Assume single group to process.
      my @prev  = @{ $group->{prev} // [] };
      my $locked_prev = 0;
      my @found_in_group;
      if ( $DEBUG_FIND ) {
         say "\nprev: ", dumper \@prev;
         say "group:  ", dumper $group;
      }

    TRY:
      while ( my $try = shift @tries ) {   # Can add to this queue if a sub tag.
         say "\nTrying: try=", dumper $try if $DEBUG_FIND;

         my ( $try_text ) = $try->{text}->@*;   # TODO: why only the first text?

         if ( defined $try->{keep} ) {          # TODO; Why empty block?
            say "ENFORCING: keep" if $DEBUG_FIND;
         }
         elsif ($try->{tag} =~ /$need->{tag}/
            and $try_text =~ /$need->{text}/ )
         {
            say "Found:  tag=$try->{tag}, text=$try_text" if $DEBUG_FIND;
            push @found_in_group, {
               %$try,                    # Copy current search options.
               prev => \@prev,           # Need this for the inversion step.
               keep => $need->{keep},    # Remember for later.
            };

            # Specific match (positive)
            if ( $nth_p and @found_in_group > $nth_p ) {
               say "ENFORCING: nth=$nth_p" if $DEBUG_FIND;
               @found = $found_in_group[$nth_p];    # Big match
               last GROUP;
            }

            # Specific group match (positive)
            elsif ( $nth_group_p and @found_in_group > $nth_group_p ) {
               say "ENFORCING: nth_group=$nth_group_p" if $DEBUG_FIND;
               @found_in_group = $found_in_group[$nth_group_p];    # Submatch
               last TRY;
            }
         }

         if ( $try->{kids} and not @found_in_group ) {
            say "Got kids and nothing yet in queue" if $DEBUG_FIND;
            unshift @tries, $try->{kids}->@*;    # Process kids tags.
            if ( $try->{keep} and not $locked_prev++ ) {
               unshift @prev,
                 {
                  tag  => $try->{tag},
                  text => [$try_text],
                 };
               say "prev changed: ", dumper \@prev if $DEBUG_FIND;
            }
            say "locked_prev: $locked_prev" if $DEBUG_FIND;
         }
      }

      # Specific group match (negative)
      if ( $nth_group_n and @found_in_group >= abs $nth_group_n ) {
         say "ENFORCING: nth_group_n=$nth_group_n" if $DEBUG_FIND;
         @found_in_group = $found_in_group[$nth_group_n];
      }

      push @found, splice @found_in_group if @found_in_group;
   }

   # Specific match (negative)
   if ( $nth_n and @found >= abs $nth_n ) {
      say "ENFORCING: nth=$nth_n" if $DEBUG_FIND;
      @found = $found[$nth_n];
   }

   say "found: ", dumper \@found if $DEBUG_FIND;

   @found;
}


=head2 _to_list

NOT USED

Converts a tree to a plain list.

=cut

sub _to_list ( $groups, $recursive = 0 ) {
   my @groups = @$groups;
   my @list;

   say "\n_TO_LIST()";
   say "groups: ", dumper \@groups;

   while ( my $group = shift @groups ) {
      my ( $tag, $text, $sub, $opts ) = @$group;
      push @list,
        {
         tag  => $tag,
         text => $text,
        };

      if ( $sub and $recursive ) {
         unshift @groups, @$sub;
      }
   }

   @list;
}


=head2 _invert

Previous elements are inside of the child
(due to the way the tree is created).

This method walks through each child and puts
the parent in its place.

=cut

sub _invert ( @groups ) {
   if ( $DEBUG_INVERT ) {
      say "\n_INVERT()";
      say "groups: ", dumper \@groups;
   }

   my @tree;
   my %navi;

   for my $group ( @groups ) {
      push @tree, { %$group{qw/tag text kids is_over/} };
      if ( $DEBUG_INVERT ) {
         say "\nInverting: group=", dumper $group;
         say "tree: ",              dumper \@tree;
      }

      my $prevs = $group->{prev} // [];
      for my $prev ( @$prevs ) {
         my $prev_node = $navi{$prev};
         if ( $DEBUG_INVERT ) {
            say "prev: ",      dumper $prev;
            say "prev_node: ", dumper $prev_node;
         }
         if ( $prev_node ) {
            push @$prev_node, pop @tree;
            if ( $DEBUG_INVERT ) {
               say "FOUND: prev_node=", dumper $prev_node;
            }
            last;
         }
         else {
            $prev_node = $navi{$prev} = [ $tree[-1] ];
            $tree[-1] = { %$prev, kids => $prev_node };
            if ( $DEBUG_INVERT ) {
               say "NEW: prev_node=", dumper $prev_node;
            }
         }
      }

      say "tree end: ", dumper \@tree if $DEBUG_INVERT;
   }

   @tree;
}


=head2 _render

Transforms a tree of found nodes in a simple list
or a string depending on context.

=cut

sub _render ( $kept_all, @tree ) {
   if ( $DEBUG_RENDER ) {
      say "\n_RENDER()";
      say "tree: ",     dumper \@tree;
      say "kept_all: ", dumper $kept_all;
   }

   my $formatter = Pod::Text->new( width => get_term_width(), );
   $formatter->{MARGIN} = 2;

   my @lines;
   my $n;

   for my $group ( @tree ) {
      my @tries = ( $group );
      say "\ngroup:  ", dumper $group if $DEBUG_RENDER;

      while ( my $try = shift @tries ) {
         say "\nTrying: try=", dumper $try if $DEBUG_RENDER;

         my $_tag  = $try->{tag};
         my $_text = $try->{text}[0];
         my $kids  = $try->{kids};

         if ( $try->{is_over} ) {
            $_text = _render_over( $try->{text}, $kept_all, );
         }
         elsif ( $kept_all ) {
            $_text .= ":" if ++$n == 1;
            if ( $_tag eq "Para" ) {
               say "USING FORMATTER" if $DEBUG_RENDER;
               $_text = $formatter->reformat( $_text );
            }
         }

         push @lines, $_text;
         push @lines, "" if $kept_all;

         if ( $kids ) {
            unshift @tries, @$kids;
            if ( $DEBUG_RENDER ) {
               say "Got kids";
               say "tries:  ", dumper \@tries;
            }
         }

      }

   }

   say "lines: ", dumper \@lines if $DEBUG_RENDER;

   return @lines if wantarray;
   join "\n", @lines;
}


=head2 _render_over

Specifically called for rendering "over" elements.

=cut

sub _render_over ( $list, $kept_all ) {
   if ( $DEBUG_RENDER ) {
      say "\n_RENDER_OVER()";
      say "list=", dumper $list;
   }

   my @txt;

   # Formatters
   state $f_norm;
   state $f_sub;
   if ( not $f_norm ) {
      $f_norm           = Pod::Text->new( width => get_term_width(), );
      $f_norm->{MARGIN} = 2;
      $f_sub            = Pod::Text->new( width => get_term_width(), );
      $f_sub->{MARGIN}  = 4;
   }

   for my $items ( @$list ) {
      my $n;
      for ( @$items ) {
         say "over-item=", dumper $_ if $DEBUG_RENDER;

         my ( $tag, $text ) = @$_;

         if ( $kept_all ) {
            say "USING FORMATTER" if $DEBUG_RENDER;
            $text .= ":"          if ++$n == 1;
            if ( $tag eq "item-text" ) {
               $text = $f_norm->reformat( $text );
            }
            else {
               $text = b( $text )->trim;
               $text = $f_sub->reformat( $text );
            }
         }

         push @txt, $text;
         push @txt, "" if $kept_all;
      }
   }

   my $new_text = join "\n", @txt;

   say "Changed over-text to: $new_text" if $DEBUG_RENDER;

   $new_text;
}


=head2 get_term_width

Caches and returns the terminal width.

=cut


sub get_term_width {
   state $term_width;

   if ( not $term_width ) {
      ( $term_width ) = GetTerminalSize();
      $term_width--;
   }

   $term_width;
}


=head1 SEE ALSO

L<App::Pod>

L<Pod::LOL>

L<Pod::Text>


=head1 AUTHOR

Tim Potapov, C<< <tim.potapov[AT]gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to L<https://github.com/poti1/pod-query/issues>.


=head1 CAVEAT


These options to _find() appear to only be currently working if set to o or -1:
   nth
   nth_group


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Pod::Query


You can also look for information at:

L<https://metacpan.org/pod/Pod::Query>
L<https://github.com/poti1/pod-query>


=head1 ACKNOWLEDGEMENTS

TBD

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2022 by Tim Potapov.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1;    # End of Pod::Query
