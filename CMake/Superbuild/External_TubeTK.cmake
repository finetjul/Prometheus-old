#============================================================================
#
# Copyright (c) Kitware Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#============================================================================

#
# TubeTK
#
set(proj TubeTK)

# Make sure this file is included only once
get_filename_component(proj_filename ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
if(${proj_filename}_proj)
  return()
endif()
set(${proj_filename}_proj ${proj})

# Sanity checks
if(DEFINED ${proj}_DIR AND NOT EXISTS ${${proj}_DIR})
  message(FATAL_ERROR "${proj}_DIR variable is defined but corresponds to non-existing directory")
endif()

# Set dependency list
# TubeTK depends on all of these so we are sure it's built after them
set(${proj}_DEPENDENCIES ITKv4 VTK CTK SlicerExecutionModel)

# Include dependent projects if any
SlicerMacroCheckExternalProjectDependency(${proj})

# Restore the proj variable
get_filename_component(proj_filename ${CMAKE_CURRENT_LIST_FILE} NAME_WE)
set(proj ${${proj_filename}_proj})

if(NOT DEFINED ${proj}_DIR)
  message(STATUS "${__indent}Adding project ${proj}")

  set(${proj}_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
  ExternalProject_Add(${proj}
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BINARY_DIR ${${proj}_DIR}
    PREFIX ${proj}-prefix
    GIT_REPOSITORY "git://github.com/vovythevov/TubeTK.git"
    GIT_TAG "393df122e4a8eb6d609a7a5ffcfe7843b8966a0f"
    INSTALL_COMMAND ""
    CMAKE_ARGS
      ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
      -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DCMAKE_INSTALL_PREFIX:PATH=${ep_install_dir}
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DBUILD_TESTING:BOOL=${BUILD_TESTING}
      #-DTubeTK_BUILD_SLICER_EXTENSION:BOOL=${TubeTK_BUILD_SLICER_EXTENSION}
      -DTubeTK_BUILD_SLICER_EXTENSION:BOOL=OFF
      -DTubeTK_REQUIRED_QT_VERSION:STRING=${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}
      -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
      -DTubeTK_USE_BOOST:BOOL=OFF
      -DTubeTK_USE_CTK:BOOL=ON
      -DTubeTK_USE_QT:BOOL=ON
      -DTubeTK_USE_VTK:BOOL=ON
      #-DTubeTK_USE_SUPERBUILD:BOOL=${TubeTK_USE_SUPERBUILD}
      -DTubeTK_USE_SUPERBUILD:BOOL=ON
      #-DSlicer_DIR:STRING=${Slicer_DIR}
      -DSlicer_DIR:PATH=${CMAKE_BINARY_DIR}/Slicer-build
      -DUSE_SYSTEM_ITK:BOOL=ON
      -DITK_DIR:PATH=${CMAKE_BINARY_DIR}/ITKv4-build
      -DUSE_SYSTEM_VTK:BOOL=ON
      -DVTK_DIR:PATH=${CMAKE_BINARY_DIR}/VTK-build
      -DUSE_SYSTEM_CTK:BOOL=ON
      -DCTK_DIR:PATH=${CMAKE_BINARY_DIR}/CTK-build
      -DUSE_SYSTEM_SlicerExecutionModel:BOOL=ON
      -DSlicerExecutionModel_DIR:PATH=${CMAKE_BINARY_DIR}/SlicerExecutionModel-build
      -DTubeTK_BUILD_ALL_MODULES:BOOL=OFF
    DEPENDS
      ${${proj}_DEPENDENCIES}
    )

else()
  # The project is provided using ${proj}_DIR, nevertheless since other project may depend on ${proj},
  # let's add an 'empty' one
  #empty_external_project(${proj} "${${proj}_DEPENDENCIES}")
endif()

#list(APPEND ${APPLICATION_NAME}_SUPERBUILD_EP_ARGS -${proj}_DIR:PATH=${${proj}_DIR})

