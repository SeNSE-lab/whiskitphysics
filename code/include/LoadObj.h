#ifndef LOAD_OBJ_H
#define LOAD_OBJ_H


struct GLInstanceGraphicsShape;

#include <Wavefront/tiny_obj_loader.h>
#include <btBulletDynamicsCommon.h>
#include <btBulletCollisionCommon.h>
// #include "LinearMath/btVector3.h"
// #include "LinearMath/btAlignedObjectArray.h"
// #include "CommonInterfaces/CommonRigidBodyBase.h"
// #include "CommonInterfaces/CommonParameterInterface.h"
#include <ImportURDFDemo/BulletUrdfImporter.h>
#include <BulletCollision/CollisionShapes/btConvexHullShape.h>


btCollisionShape* createConvexHullFromShapes(std::vector<tinyobj::shape_t>& shapes, const btVector3& geomScale);
btCollisionShape* LoadShapeFromObj(const char* relativeFileName, const char* materialPrefixPath, const btVector3& geomScale);

#endif //LOAD_MESH_FROM_OBJ_H

