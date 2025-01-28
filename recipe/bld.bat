xcopy /s %RECIPE_DIR%\win_build\* .

mkdir build
cd build

cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=%PREFIX%/Library -DRUN_TESTS=ON ..
cmake --build . -j1
cmake --install .

:: All just import libs under different names for backwards compatibility.
copy %LIBRARY_BIN%\libmpc-%LIB_MAJOR_VERSION%.dll %LIBRARY_BIN%\libmpc.dll
copy %LIBRARY_BIN%\libmpc-%LIB_MAJOR_VERSION%.dll %LIBRARY_BIN%\mpc.dll
copy %LIBRARY_LIB%\libmpc-%LIB_MAJOR_VERSION%.lib %LIBRARY_LIB%\mpc.lib
copy %LIBRARY_LIB%\libmpc-%LIB_MAJOR_VERSION%.lib %LIBRARY_LIB%\libmpc.lib
copy %LIBRARY_LIB%\libmpc-%LIB_MAJOR_VERSION%.lib %LIBRARY_LIB%\libmpc.dll.a
