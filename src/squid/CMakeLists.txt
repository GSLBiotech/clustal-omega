set(CMAKE_INCLUDE_CURRENT_DIR ON)

add_definitions(-DCLUSTALO)

set(squid_sources
    a2m.c
    aligneval.c
    alignio.c 
    clustal.c
    cluster.c
    dayhoff.c
    eps.c
    file.c
    getopt.c
    gki.c 
    gsi.c 
    gsi64.c
    hsregex.c
    iupac.c
    msa.c
    msf.c
    phylip.c
    revcomp.c
    rk.c
    selex.c 
    seqencode.c
    shuffle.c
    sqerror.c
    sqio.c 
    squidcore.c
    sre_ctype.c 
    sre_math.c
    sre_random.c
    sre_string.c
    ssi.c 
    stack.c 
    stockholm.c
    stopwatch.c 
    translate.c
    types.c
    vectorops.c
    weight.c)
    
set(squid_headers
    gki.h
    gsi64.h
    msa.h
    rk.h
    sqfuncs.h
    squid.h
    sre_random.h
    ssi.h
    stockholm.h
    stopwatch.h
    vectorops.h
    version.h)

add_library(squid_library OBJECT ${squid_sources})

install(FILES ${squid_headers} DESTINATION ${INSTALL_INC_DIR}/squid)
