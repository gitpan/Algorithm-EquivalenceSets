package Algorithm::EquivalenceSets;

use strict;
use warnings;


our $VERSION = '0.01';


use base 'Exporter';


our @EXPORT = qw(equivalence_sets);


sub equivalence_sets {
    my $item_list = shift;
    my $next_group = 1;
    my %group;  # key = item, value = group this item belongs to
    my %member; # key = group name, value = list of items in this group
    for my $item_def (@$item_list) {
        # flatten item aliases
        my @alias = map { ref eq 'ARRAY' ? @$_ : $_ } @$item_def;

        my %seen_group;
        # known groups that these aliases belong to
        my @group =
            grep { !$seen_group{$_}++ }
            map  { $group{$_} || () }
            @alias;

        # unify the groups listed in @group by dissolving them and adding
        # their members to the aliases, then forming a new group from the
        # aliases

        push @alias, map { @{ $member{$_} } } @group;
        my %seen_member;
        @alias = grep { !$seen_member{$_}++ } @alias;
        delete @member{@group};
        my $new_group = $next_group++;
        $group{$_} = $new_group for @alias;
        $member{$new_group} = \@alias;
    }
    wantarray ? values %member : [ values %member ];
}


1;


__END__



=head1 NAME

Algorithm::EquivalenceSets - FIXME

=head1 SYNOPSIS

    use Algorithm::EquivalenceSets;

    my @sets = (
        [ 'a', 1, 2 ],
        [ 'b', 3, 4 ],
        [ 'c', 5    ],
        [ 'd', 1, 6 ],
        [ 'e', 3, 6 ],
        [ 'f', 5, 7 ],
    );

    my @equiv_sets = equivalence_sets(@sets);

    # @equiv_sets is ([ qw(c f 5 7) ], [ qw(a b d e 1 2 3 4 6) ])

=head1 DESCRIPTION

This module exports one function, C<equivalence_sets()>, which takes a list of
sets and returns another list of sets whose contents are transitively grouped
from the input sets.

Imagine the input sets to be C<[ 1, 2 ]>, C<[ 3, 4 ]>, C<[ 5, 6 ]>
and C<[ 1, 3, 7 ]>. The returned sets would be C<[ 1, 2, 3, 4, 7 ]> and
C<[ 5, 6 ]>, because C<[ 1, 2 ]> and C<[ 3, 4 ]> are tied together by
C<[ 1, 3, 7 ]>, but C<[ 5, 6 ]> stands on its own. So you could say the
returned sets represent a kind of transitive union. (Real mathematicians may
now flame me about the misuse of terminology.)

Each set is an array reference. The return sets are given as an array in list
context, or as a reference to that array in scalar context.

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<algorithmequivalencesets> tag.

=head1 VERSION 
                   
This document describes version 0.01 of L<Algorithm::EquivalenceSets>.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<<bug-algorithm-equivalencesets@rt.cpan.org>>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

