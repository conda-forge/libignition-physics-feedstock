:: clang-cl is used for template problems. 
:: Perhaps this can be changed once vs2019 is used
set "CC=clang-cl.exe"
set "CXX=clang-cl.exe"
set "CL=/MP"

mkdir build
cd build

cmake ^
    -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DBUILD_TESTING=ON ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Test
ctest --output-on-failure -C Release
if errorlevel 1 exit 1
