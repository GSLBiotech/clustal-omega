set(CMAKE_INCLUDE_CURRENT_DIR ON)

include_directories(${CMAKE_SOURCE_DIR}/src)

set(clustal_sources
    hhalign_wrapper.c
    ktuple_pair.c
    list.c 
    log.c
    mbed.c 
    muscle_tree.c
    muscle_upgma.c
    pair_dist.c
    progress.c
    seq.c
    symmatrix.c
    tree.c
    util.c
    weights.c)

set(clustal_headers
    hhalign_wrapper.h
    ktuple_pair.h
    log.h
    mbed.h
    muscle_tree.h
    pair_dist.h
    progress.h
    seq.h
    symmatrix.h
    tree.h
    util.h
    weights.h)

add_library(clustal_library OBJECT ${clustal_sources})

install(FILES ${clustal_headers} DESTINATION ${INSTALL_INC_DIR}/clustal)
