#! /usr/local/bin/parrot
# $Id$

.include 'sysinfo.pasm'
.include 'iglobals.pasm'

.sub 'main' :main
    load_bytecode 'Configure.pbc'

    # Wave to the friendly users
    print "Hello! I'm Configure. My job is to poke and prod\n"
    print "your system to figure out how to build nqpTAP.\n"

    .local pmc config
    $P0 = getinterp
    config = $P0[.IGLOBALS_CONFIG_HASH]
    .local string OS
    OS = sysinfo .SYSINFO_PARROT_OS

    # Here, do the job
    push_eh _handler
    genfile('Makefile.in', 'Makefile', config)
#    genfile('src/ops/Makefile.in', 'src/ops/Makefile', config)
#    genfile('src/pmc/Makefile.in', 'src/pmc/Makefile', config)
    pop_eh

    # Give the user a hint of next action
    .local string make
    make = config['make']
    print "Configure completed for platform '"
    print OS
    print "'.\n"
    print "You can now type '"
    print make
    print "' to build nqptap.\n"
    print "You may also type '"
    print make
    print " test' to run the nqptap test suite.\n"
    print "\nHappy Hacking,\n\tThe nqpTAP Team.\n"
    end

  _handler:
    .local pmc e
    .local string msg
    .get_results (e)
    printerr "\n"
    msg = e
    printerr msg
    printerr "\n"
    end
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
