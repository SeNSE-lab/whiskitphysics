IF(BUILD_BULLET3)
	SUBDIRS(ExampleBrowser ThirdPartyLibs/Gwen ThirdPartyLibs/BussIK ThirdPartyLibs/clsocket OpenGLWindow)
	# SUBDIRS(ExampleBrowser ThirdPartyLibs/Gwen ThirdPartyLibs/BussIK OpenGLWindow TwoJoint)

ENDIF()

INCLUDE_DIRECTORIES(
	../src
	./ThirdPartyLibs
	./Utils
	./Importers

)

SET(BULLET_EXAMPLE_SOURCES
	Utils/b3Clock.cpp
	Utils/b3ResourcePath.cpp
    Importers/ImportObjDemo/Wavefront2GLInstanceGraphicsShape.cpp
    Importers/ImportURDFDemo/BulletUrdfImporter.cpp
    
    Importers/ImportObjDemo/LoadMeshFromObj.cpp
    Importers/ImportURDFDemo/UrdfParser.cpp
    Importers/ImportURDFDemo/urdfStringSplit.cpp
    Importers/ImportURDFDemo/BulletUrdfImporter.cpp
    Importers/ImportMeshUtility/b3ImportMeshUtility.cpp
    Importers/ImportColladaDemo/LoadMeshFromCollada.cpp

	ThirdPartyLibs/stb_image/stb_image.cpp
    ThirdPartyLibs/Wavefront/tiny_obj_loader.cpp
    ThirdPartyLibs/tinyxml/tinystr.cpp
    ThirdPartyLibs/tinyxml/tinyxml.cpp
    ThirdPartyLibs/tinyxml/tinyxmlerror.cpp
    ThirdPartyLibs/tinyxml/tinyxmlparser.cpp
    

)

ADD_LIBRARY(BulletExampleLib
	${BULLET_EXAMPLE_SOURCES}
)

TARGET_LINK_LIBRARIES(BulletExampleLib Bullet3Common)

IF(BUILD_PYBULLET)
	SUBDIRS(pybullet)
ENDIF(BUILD_PYBULLET)
