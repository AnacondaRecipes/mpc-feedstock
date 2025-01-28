include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/../src
  ${CMAKE_CURRENT_BINARY_DIR}/../src)

add_library(
  libmpctests
        mpc-tests.h check_data.c clear_parameters.c
        close_datafile.c comparisons.c copy_parameter.c double_rounding.c
        init_parameters.c mpfr_flags.c open_datafile.c print_parameter.c
        random.c read_data.c read_description.c read_line.c rounding.c
        setprec_parameters.c tpl_gmp.c tpl_mpc.c tpl_mpfr.c tpl_native.c)
target_link_libraries(libmpctests libmpc)

if (NOT "${CMAKE_CURRENT_BINARY_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
  file(COPY
          abs.dat acos.dat acosh.dat add.dat add_fr.dat agm.dat
          arg.dat asin.dat asinh.dat atan.dat atanh.dat
          cmp_abs.dat conj.dat cos.dat cosh.dat
          div.dat div_fr.dat exp.dat fma.dat fr_div.dat fr_sub.dat inp_str.dat
          log.dat log10.dat mul.dat mul_fr.dat neg.dat norm.dat pow.dat
          pow_fr.dat pow_si.dat pow_ui.dat pow_z.dat proj.dat rootofunity.dat
          sin.dat sinh.dat
          sqr.dat sqrt.dat strtoc.dat sub.dat sub_fr.dat tan.dat tanh.dat
    DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
endif()

set(tests
        tradius tballs teta
        tabs tacos tacosh tadd
        tadd_fr tadd_si tadd_ui
        tagm targ tasin tasinh
        tatan tatanh tcmp_abs
        tconj tcos tcosh tdiv
        tdiv_2si tdiv_2ui tdiv_fr
        tdiv_ui tdot texp tfma
        tfr_div tfr_sub timag
        tio_str tlog tlog10 tmul
        tmul_2si tmul_2ui tmul_fr
        tmul_i tmul_si tmul_ui
        tneg tnorm tpow tpow_d
        tpow_fr tpow_ld tpow_si
        tpow_ui tpow_z tprec tproj
        treal treimref trootofunity
        tset tsin tsin_cos tsinh
        tsqr tsqrt tstrtoc tsub
        tsub_fr tsub_ui tsum tswap
        ttan ttanh tui_div
        tui_ui_sub tget_version texceptions
)

foreach(t ${tests})
  add_executable(${t} ${t}.c)
  target_link_libraries(${t} libmpc libmpctests)
  add_test(${t} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${t})
  set_target_properties(${t} PROPERTIES FOLDER Tests)
endforeach()

if(HAVE_STDINT_H)
  set_source_files_properties(tstdint.c PROPERTIES COMPILE_DEFINITIONS HAVE_STDINT_H)
endif()

if(HAVE_STDARG)
  set_source_files_properties(tvalist.c PROPERTIES COMPILE_DEFINITIONS HAVE_STDARG)
endif()
