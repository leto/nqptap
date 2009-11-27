# $Id$

=head1 TITLE

nqptap.pir - A nqptap compiler.

=head2 Description

This is the base file for the nqptap compiler.

This file includes the parsing and grammar rules from
the src/ directory, loads the relevant PGE libraries,
and registers the compiler under the name 'nqptap'.

=head2 Functions

=over 4

=item onload()

Creates the nqptap compiler using a C<PCT::HLLCompiler>
object.

=cut

.namespace [ 'nqptap::Compiler' ]

#.loadlib 'nqptap_group'

.sub 'onload' :anon :load :init
    load_bytecode 'PCT.pbc'

    $P0 = get_hll_global ['PCT'], 'HLLCompiler'
    $P1 = $P0.'new'()
    $P1.'language'('nqptap')
    $P1.'parsegrammar'('nqptap::Grammar')
    $P1.'parseactions'('nqptap::Grammar::Actions')
.end

.include 'src/builtins.pir'
.include 'src/gen_grammar.pir'
.include 'src/gen_actions.pir'

=back

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

