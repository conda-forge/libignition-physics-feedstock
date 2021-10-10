mkdir build
cd build

cmake ^
    -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DBUILD_TESTING=ON ^
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ^
    -DCMAKE_CXX_FLAGS="/permissive- /D_USE_MATH_DEFINES" ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
:: Only use one thread to avoid out of memory issues (https://github.com/conda-forge/libignition-physics-feedstock/pull/21#issuecomment-938662928)
cmake --build . --parallel 1 --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Test
ctest --output-on-failure -C Release -E "check_|INTEGRATION_ExamplesBuild_TEST|UNIT_Collisions_TEST|UNIT_EntityManagement_TEST"
if errorlevel 1 exit 1
