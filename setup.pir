#! /usr/local/bin/parrot
# $Id$

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    $P0 = new 'Hash'
    $P0['name'] = 'nqptap'
    $P0['abstract'] = 'the nqptap compiler'
    $P0['description'] = 'the nqptap for Parrot VM.'

    # build
#    $P1 = new 'Hash'
#    $P1['nqptap_ops'] = 'src/ops/nqptap.ops'
#    $P0['dynops'] = $P1

#    $P2 = new 'Hash'
#    $P3 = split ' ', 'src/pmc/nqptap.pmc'
#    $P2['nqptap_group'] = $P3
#    $P0['dynpmc'] = $P2

    $P4 = new 'Hash'
    $P5 = split ' ', 'src/parser/grammar.pg src/parser/grammar-oper.pg'
    $P4['src/gen_grammar.pir'] = $P5
    $P0['pir_pge'] = $P4

    $P6 = new 'Hash'
    $P6['src/gen_actions.pir'] = 'src/parser/actions.pm'
    $P0['pir_nqp'] = $P6

    $P7 = new 'Hash'
    $P8 = split "\n", <<'SOURCES'
src/nqptap.pir
src/gen_grammar.pir
src/gen_actions.pir
src/builtins.pir
src/builtins/say.pir
SOURCES
    $S0 = pop $P8
    $P7['nqptap/nqptap.pbc'] = $P8
    $P7['nqptap.pbc'] = 'nqptap.pir'
    $P0['pbc_pir'] = $P7

    $P9 = new 'Hash'
    $P9['parrot-nqptap'] = 'nqptap.pbc'
    $P0['installable_pbc'] = $P9

    # test
    $S0 = get_parrot()
    $S0 .= ' nqptap.pbc'
    $P0['prove_exec'] = $S0

    # install
    $P0['inst_lang'] = 'nqptap/nqptap.pbc'

    .tailcall setup(args :flat, $P0 :flat :named)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

