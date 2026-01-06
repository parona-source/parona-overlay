# Lazy version of https://github.com/ogdf/ogdf/pull/292

find_package(PkgConfig)
pkg_check_modules(OsiClp REQUIRED IMPORTED_TARGET GLOBAL osi-clp clp osi coinutils)
add_library(COIN ALIAS PkgConfig::OsiClp)

set(COIN_SOLVER "CLP" CACHE STRING "Linear program solver to be used by COIN.")
set_property(CACHE COIN_SOLVER PROPERTY STRINGS CLP CPX GRB)

if(COIN_SOLVER STREQUAL "CLP")
    set(COIN_SOLVER_IS_EXTERNAL 0)
else()
    set(COIN_SOLVER_IS_EXTERNAL 1)
endif()
