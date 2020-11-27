cmake_minimum_required(VERSION 3.10.2)
set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS true)
cmake_policy(SET CMP0017 NEW)

SET(MSVC_INCREMENTAL_DEFAULT ON)
PROJECT(WHISKIT_PHYSICS C CXX)

IF(COMMAND cmake_policy)
   cmake_policy(SET CMP0003 NEW)
   if(POLICY CMP0042)
      # Enable MACOSX_RPATH by default.
      cmake_policy(SET CMP0042 NEW)
   endif(POLICY CMP0042)
ENDIF(COMMAND cmake_policy)

# SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D_DEBUG")
#MESSAGE("CMAKE_CXX_FLAGS_DEBUG="+${CMAKE_CXX_FLAGS_DEBUG})

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread")
IF (NOT CMAKE_BUILD_TYPE)
 SET(CMAKE_BUILD_TYPE "Release")
ENDIF (NOT CMAKE_BUILD_TYPE)
SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D_DEBUG")


IF(APPLE)
    SET(DYLIB_SUFFIX dylib)
ELSEIF(UNIX)
    SET(DYLIB_SUFFIX so)
ENDIF()

IF(NOT WIN32)
	SET(DL ${CMAKE_DL_LIBS})
	IF(CMAKE_SYSTEM_NAME MATCHES "Linux")
		MESSAGE("Linux")
		SET(OSDEF -D_LINUX)
	ELSE(CMAKE_SYSTEM_NAME MATCHES "Linux")
		IF(APPLE)
			MESSAGE("Apple")
			SET(OSDEF -D_DARWIN)
		ELSE(APPLE)
			MESSAGE("BSD?")
			SET(OSDEF -D_BSD)
		ENDIF(APPLE)
	ENDIF(CMAKE_SYSTEM_NAME MATCHES "Linux")
ENDIF(NOT WIN32)

OPTION(USE_MSVC_INCREMENTAL_LINKING "Use MSVC Incremental Linking" OFF)
OPTION(USE_CUSTOM_VECTOR_MATH "Use custom vectormath library" OFF)

IF (WIN32)
OPTION(USE_GLUT "Use Glut"	ON)
ADD_DEFINITIONS( -D_CRT_SECURE_NO_WARNINGS )
ADD_DEFINITIONS( -D_CRT_SECURE_NO_DEPRECATE )
ADD_DEFINITIONS( -D_SCL_SECURE_NO_WARNINGS )

IF (USE_GLUT AND MSVC)
	string (REPLACE "/D_WINDOWS" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
	remove_definitions(-D_WINDOWS )
ENDIF()

ELSE(WIN32)
	OPTION(USE_GLUT "Use Glut"	ON)
ENDIF(WIN32)


# This is the shortcut to finding GLU, GLUT and OpenGL if they are properly installed on your system
# This should be the case.

FIND_PACKAGE(OpenGL)
IF (OPENGL_FOUND)
	MESSAGE("OPENGL FOUND")
	MESSAGE(${OPENGL_LIBRARIES})
ELSE (OPENGL_FOUND)
	MESSAGE("OPENGL NOT FOUND")
	SET(OPENGL_gl_LIBRARY opengl32)
	SET(OPENGL_glu_LIBRARY glu32)
ENDIF (OPENGL_FOUND)

IF (APPLE)
  FIND_LIBRARY(COCOA_LIBRARY Cocoa)
ENDIF()

FIND_PACKAGE(Boost COMPONENTS program_options filesystem REQUIRED)
IF (Boost_FOUND)
    INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIRS})
    ADD_DEFINITIONS( "-DHAS_BOOST" )
ENDIF()

# SET(BULLETLIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bullet3/lib)
# ADD_SUBDIRECTORY(${CMAKE_CURRENT_SOURCE_DIR}/bullet3)

# SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${BULLETLIB_DIR})
# SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${BULLETLIB_DIR})
# SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BULLETLIB_DIR})

# FIND_LIBRARY(BULLET_LIB NAMES Bullet3Common BulletDynamics BulletCollision LinearMath OpenGLWindow BulletExampleBrowserLib BulletExampleLib HINTS bullet3/lib)

INCLUDE_DIRECTORIES(
	include
	bullet3/
    bullet3/src
    bullet3/examples
    bullet3/Extras
    bullet3/examples/CommonInterfaces
    bullet3/examples/OpenGLWindow
    bullet3/examples/ExampleBrowser
    bullet3/examples/ThirdPartyLibs
    bullet3/examples/ThirdPartyLibs/Glew
    bullet3/examples/ThirdPartyLibs/glad
    bullet3/examples/Importers
    bullet3/Extras/Serialize
    ${OPENGL_INCLUDE_DIRS}
	${GLUT_INCLUDE_DIRS}
	)


SET(SOURCES
    src/Parameters.cpp
    src/Simulation_utility.cpp
    src/Simulation_IO.cpp
    src/Whisker.cpp
    src/Rat.cpp
    src/Simulation.cpp
    # src/LoadObj.cpp
    src/Object.cpp

)

SET(EXT_SOURCES
    bullet3/build3/bullet.rc
    bullet3/examples/ExampleBrowser/OpenGLGuiHelper.cpp
    bullet3/examples/ExampleBrowser/GL_ShapeDrawer.cpp
    bullet3/examples/ExampleBrowser/CollisionShape2TriangleMesh.cpp
    bullet3/examples/Utils/b3Clock.cpp
    bullet3/examples/Importers/ImportObjDemo/Wavefront2GLInstanceGraphicsShape.cpp
    bullet3/examples/Importers/ImportURDFDemo/BulletUrdfImporter.cpp
    bullet3/examples/ThirdPartyLibs/Wavefront/tiny_obj_loader.cpp
    bullet3/examples/Importers/ImportObjDemo/LoadMeshFromObj.cpp
    bullet3/examples/OpenGLWindow/SimpleOpenGL3App.cpp
    bullet3/examples/Importers/ImportURDFDemo/UrdfParser.cpp
    bullet3/examples/Utils/b3ResourcePath.cpp
    bullet3/examples/ThirdPartyLibs/tinyxml2/tinyxml2.cpp
    bullet3/examples/Importers/ImportURDFDemo/urdfStringSplit.cpp
    bullet3/examples/Importers/ImportURDFDemo/BulletUrdfImporter.cpp
    bullet3/examples/Importers/ImportMeshUtility/b3ImportMeshUtility.cpp
    bullet3/examples/Importers/ImportColladaDemo/LoadMeshFromCollada.cpp
    bullet3/examples/ThirdPartyLibs/stb_image/stb_image.cpp

)


IF(COMMAND cmake_policy)
	cmake_policy(SET CMP0003 NEW)
ENDIF(COMMAND cmake_policy)

LINK_DIRECTORIES(${CMAKE_SOURCE_DIR}/bullet3/lib)

LINK_LIBRARIES(
	libOpenGLWindow.a
    libBullet3Common.a 
    libBulletDynamics.a 
    libBulletCollision.a  
    libLinearMath.a 
    
)

ADD_EXECUTABLE(
	whiskit 
	${SOURCES} 
	${EXT_SOURCES} 
	${CMAKE_SOURCE_DIR}/src/main.cpp
	)

    
TARGET_LINK_LIBRARIES(whiskit
	${CMAKE_DL_LIBS}
	${Boost_LIBRARIES} 	
	${OPENGL_gl_LIBRARY} 
    ${OPENGL_glu_LIBRARY}
    
 )



IF (INTERNAL_ADD_POSTFIX_EXECUTABLE_NAMES)
			SET_TARGET_PROPERTIES(whiskit PROPERTIES  DEBUG_POSTFIX "_Debug")
			SET_TARGET_PROPERTIES(whiskit PROPERTIES  MINSIZEREL_POSTFIX "_MinsizeRel")
			SET_TARGET_PROPERTIES(whiskit PROPERTIES  RELWITHDEBINFO_POSTFIX "_RelWithDebugInfo")
ENDIF(INTERNAL_ADD_POSTFIX_EXECUTABLE_NAMES)



#################
# Standalone SimulationGui using OpenGL (but not the example browser)


#some code to support OpenGL and Glew cross platform
IF (WIN32)
        INCLUDE_DIRECTORIES(
             ${BULLET_SOURCE_DIR}/btgui/OpenGLWindow/GlewWindows
             #${BULLET_SOURCE_DIR}/examples/OpenGLWindow/SimpleOpenGL3App.cpp
        )
        ADD_DEFINITIONS(-DGLEW_STATIC)
	LINK_LIBRARIES( ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY} )
ELSE(WIN32)
        IF(APPLE)
                find_library(COCOA NAMES Cocoa)
                MESSAGE(${COCOA})
                link_libraries(${COCOA} ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY})

        ELSE(APPLE)
                INCLUDE_DIRECTORIES(
                        ${BULLET_SOURCE_DIR}/btgui/OpenGLWindow/GlewWindows
                        ${BULLET_SOURCE_DIR}/examples/OpenGLWindow
                )
                ADD_DEFINITIONS("-DGLEW_INIT_OPENGL11_FUNCTIONS=1")
                ADD_DEFINITIONS("-DGLEW_STATIC")
                ADD_DEFINITIONS("-DGLEW_DYNAMIC_LOAD_ALL_GLX_FUNCTIONS=1")

                LINK_LIBRARIES(  pthread ${DL} )
        ENDIF(APPLE)
ENDIF(WIN32)


ADD_EXECUTABLE(whiskit_gui
    ${SOURCES}
	${EXT_SOURCES}
    ${CMAKE_SOURCE_DIR}/src/main_opengl.cpp
)

TARGET_LINK_LIBRARIES(whiskit_gui 
	${CMAKE_DL_LIBS}
	${Boost_LIBRARIES} 	
	${OPENGL_gl_LIBRARY} 
    ${OPENGL_glu_LIBRARY}
    
 )


IF (INTERNAL_ADD_POSTFIX_EXECUTABLE_NAMES)
                        SET_TARGET_PROPERTIES(whiskit_gui PROPERTIES  DEBUG_POSTFIX "_Debug")
                        SET_TARGET_PROPERTIES(whiskit_gui PROPERTIES  MINSIZEREL_POSTFIX "_MinsizeRel")
                        SET_TARGET_PROPERTIES(whiskit_gui PROPERTIES  RELWITHDEBINFO_POSTFIX "_RelWithDebugInfo")
ENDIF(INTERNAL_ADD_POSTFIX_EXECUTABLE_NAMES)
