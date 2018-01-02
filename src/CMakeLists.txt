set(CMAKE_INCLUDE_CURRENT_DIR ON)

configure_file(${CMAKE_SOURCE_DIR}/cmake/src/config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/config.h DESTINATION ${INSTALL_INC_DIR})
add_definitions(-DHAVE_CONFIG_H)
include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_subdirectory(clustal)
add_subdirectory(hhalign)
add_subdirectory(kmpp)
add_subdirectory(squid)
    
add_library(clustalo_library
            STATIC 
            clustal-omega.c 
            $<TARGET_OBJECTS:clustal_library> 
            $<TARGET_OBJECTS:hhalign_library> 
            $<TARGET_OBJECTS:kmpp_library> 
            $<TARGET_OBJECTS:squid_library>)
set_target_properties(clustalo_library PROPERTIES OUTPUT_NAME clustalo)
  
add_executable(clustalo_executable
               main.cpp 
               mymain.c)               
set_target_properties(clustalo_executable PROPERTIES OUTPUT_NAME clustalo)

target_link_libraries(clustalo_executable clustalo_library)
if("ARGTABLE_LIBRARY" STREQUAL "")
  target_link_libraries(clustalo_executable argtable2)  
else()
  target_link_libraries(clustalo_executable "${ARGTABLE_LIBRARY}")
endif()

if(NOT WIN32)
  target_link_libraries(clustalo_executable m)
endif()

install(TARGETS clustalo_executable RUNTIME DESTINATION bin)
install(TARGETS clustalo_library    ARCHIVE DESTINATION lib)
install(FILES clustal-omega.h DESTINATION ${INSTALL_INC_DIR})
