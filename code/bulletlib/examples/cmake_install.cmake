# Install script for directory: /home/nadina/Github/whisker-bulllet/examples

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/nadina/Github/whisker-bulllet/examples/HelloWorld/cmake_install.cmake")
  include("/home/nadina/Github/whisker-bulllet/examples/BasicDemo/cmake_install.cmake")
  include("/home/nadina/Github/whisker-bulllet/examples/ExampleBrowser/cmake_install.cmake")
  include("/home/nadina/Github/whisker-bulllet/examples/RobotSimulator/cmake_install.cmake")
  include("/home/nadina/Github/whisker-bulllet/examples/SharedMemory/cmake_install.cmake")
  include("/home/nadina/Github/whisker-bulllet/examples/ThirdPartyLibs/Gwen/cmake_install.cmake")
  include("/home/nadina/Github/whisker-bulllet/examples/ThirdPartyLibs/BussIK/cmake_install.cmake")
  include("/home/nadina/Github/whisker-bulllet/examples/ThirdPartyLibs/clsocket/cmake_install.cmake")
  include("/home/nadina/Github/whisker-bulllet/examples/OpenGLWindow/cmake_install.cmake")
  include("/home/nadina/Github/whisker-bulllet/examples/TwoJoint/cmake_install.cmake")

endif()

