# Building MPC on Windows

This guide outlines the steps to build MPC on Windows using MSVC and `conda build`. It also provides instructions for
updating the build process for future versions of MPC.

---

## Overview

Portions of this CMake project, such as the library and test definitions, were modelled after GMP and MPFR projects
found [here](https://github.com/gx); however, the majority of this build system was created from scratch specifically
for this feedstock.

---

## Updating for Future Versions

When new versions of MPC are released:

1. Check a diff between the last version we built and the latest release.
2. Update the CMake configuration:
   - Source file lists in the CMake are named LIB\<libname\>_SOURCES and are typically identical to the lists found in
   each Makefile.in. For instance, `libmpc` is comprised of sources from the `LIBMPC_SOURCES` list and that list was
   populated from the `libmpc_la_SOURCES` list found in `src/Makefile.in`.
3. Update the `src/config.h.in`:
   - Check for new tests that need to be run. This project supplies a `config.h.in` which mirrors the one generated by
   an autotools build. A diff between the `config.h` generated by a `./configure` run and the one output by cmake can
   highlight header, library, and function call checks that need to be added or removed between versions. These checks
   can be found in the top-level `CMakeLists.txt`.

---

## Troubleshooting

- Missing Source Files: If the build fails due to missing files, ensure all new source files are included in
CMakeLists.txt.
- Test Failures: Check the test outputs against the updated source and adjust the CMake configuration as needed.
- Build Errors: Verify that all dependencies are correctly specified in meta.yaml and that the environment is properly
set up.
