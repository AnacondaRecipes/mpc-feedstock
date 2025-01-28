set(LIBMPC_SOURCES
        mpc-impl.h abs.c acos.c acosh.c add.c add_fr.c
        add_si.c add_ui.c agm.c arg.c asin.c asinh.c atan.c atanh.c clear.c
        cmp.c cmp_abs.c cmp_si_si.c conj.c cos.c cosh.c
        div_2si.c div_2ui.c div.c div_fr.c div_ui.c
        dot.c eta.c exp.c fma.c fr_div.c fr_sub.c get_prec2.c get_prec.c
        get_version.c get_x.c imag.c init2.c init3.c inp_str.c log.c log10.c
        mem.c mul_2si.c mul_2ui.c mul.c mul_fr.c mul_i.c mul_si.c mul_ui.c
        neg.c norm.c out_str.c pow.c pow_fr.c
        pow_ld.c pow_d.c pow_si.c pow_ui.c pow_z.c proj.c real.c rootofunity.c
        urandom.c set.c
        set_prec.c set_str.c set_x.c set_x_x.c sin.c sin_cos.c sinh.c sqr.c
        sqrt.c strtoc.c sub.c sub_fr.c sub_ui.c sum.c swap.c tan.c tanh.c
        uceil_log2.c ui_div.c ui_ui_sub.c
        radius.c balls.c
)

add_library(libmpc SHARED ${LIBMPC_SOURCES})
target_link_libraries(libmpc MPFR::libmpfr GMP::libgmp)
set_target_properties(libmpc
  PROPERTIES
  OUTPUT_NAME libmpc$<$<CONFIG:Debug>:d>-${MPC_LT_CURRENT}
  VERSION ${MPC_VERSION}
  SOVERSION ${MPC_LT_CURRENT})

include(GNUInstallDirs)

# Install libgmp package config file.
install(
        FILES ${CMAKE_BINARY_DIR}/mpc.pc
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
        COMPONENT Development)

# Install libmpc.
install(
  TARGETS libmpc EXPORT libmpc-export
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install libmpc header file.
install(
  FILES mpc.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  COMPONENT Development)

# Install libmpc PDB files.
if(MSVC)
  install(
    FILES $<TARGET_PDB_FILE:libmpc>
    DESTINATION ${CMAKE_INSTALL_BINDIR}
    COMPONENT Development
    OPTIONAL)
endif()

include(CMakePackageConfigHelpers)

# Generate the config files of MPC.
write_basic_package_version_file(
  "${CMAKE_BINARY_DIR}/cmake/MPCConfigVersion.cmake"
  VERSION ${MPC_VERSION}
  COMPATIBILITY SameMajorVersion)
export(
  EXPORT libmpc-export
  NAMESPACE MPC::
  FILE "${CMAKE_BINARY_DIR}/cmake/libmpc.cmake")

# Install the config files of MPC.
install(
  FILES
    ${CMAKE_SOURCE_DIR}/cmake/MPCConfig.cmake
    ${CMAKE_BINARY_DIR}/cmake/MPCConfigVersion.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/mpc
  COMPONENT Development)
install(EXPORT libmpc-export
  FILE libmpc.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/mpc
  NAMESPACE MPC::
  COMPONENT Development)
