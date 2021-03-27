#!/bin/sh

mkdir build
cd build

if [ ${target_platform} == "linux-ppc64le" ]; then
  # Disable tests
  IGN_TEST_CMD=-DBUILD_TESTING:BOOL=OFF
  NUM_PARALLEL=-j1
else
  IGN_TEST_CMD=
  NUM_PARALLEL=
fi

cmake .. \
      -G "Ninja" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True \
      -DCMAKE_CXX_STANDARD=17 \
      ${IGN_TEST_CMD}

cmake --build . --config Release ${NUM_PARALLEL}
cmake --build . --config Release --target install ${NUM_PARALLEL}

if [ ${target_platform} != "linux-ppc64le" ]; then
  # Remove test that fail on arm64: https://github.com/ignitionrobotics/ign-physics/issues/70
  # Remove test that fail on macOS: https://github.com/conda-forge/libignition-physics-feedstock/issues/13
  ctest --output-on-failure -C Release -E "INTEGRATION_FrameSemantics2d|INTEGRATION_JointTypes2f|UNIT_Collisions_TEST|UNIT_EntityManagement_TEST|UNIT_JointFeatures_TEST|UNIT_LinkFeatures_TEST|UNIT_SDFFeatures_TEST|UNIT_SimulationFeatures_TEST"
fi
