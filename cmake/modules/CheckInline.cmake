include(CheckCXXSourceCompiles)

macro(CheckInline)

foreach(KEYWORD "inline" "__inline__" "__inline")
    if(NOT DEFINED INLINE)
        check_cxx_source_compiles(
            "
            typedef int foo_t;
            static inline foo_t static_foo(){return 0;}
            foo_t foo(){return 0;}
            int main(int argc, char *argv[]){return 0;}
            "
            INLINE
        )
        if(INLINE)
            add_definitions("-Dinline=${KEYWORD}")
            break()
        endif(INLINE)
    endif(NOT DEFINED INLINE)
endforeach(KEYWORD)
if(NOT DEFINED INLINE)
    add_definitions("-Dinline=")
endif(NOT DEFINED INLINE)

endmacro(CheckInline)

