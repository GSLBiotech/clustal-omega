set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCLUSTALO -DCLUSTALO_NOFILE -DDEFAULT_FILTER=90")

if(NOT WIN32)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-strict-aliasing")
endif()

set(hhalign_sources hhalign.cpp)
add_library(hhalign_library OBJECT ${hhalign_sources})

set(hhalign_headers
    general.h
    hhfunc.h)
    
install(FILES ${hhalign_headers} DESTINATION ${INSTALL_INC_DIR}/hhalign)
