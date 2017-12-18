set(CMAKE_INCLUDE_CURRENT_DIR ON)
add_definitions(-DCLUSTALO)
set(kmpp_sources 
    KMeans.cpp
    KmTree.cpp
    KmUtils.cpp)
add_library(kmpp_library OBJECT ${kmpp_sources})