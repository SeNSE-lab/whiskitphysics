#ifndef SIMULATION_UTILITY_HPP
#define SIMULATION_UTILITY_HPP


#define SCALE 1000. // set to mm scale
#define PI 3.1415927

#include <iostream>
#include <vector>

#include "btBulletDynamicsCommon.h"
#include "btBulletCollisionCommon.h"
#include "LinearMath/btVector3.h"
#include "LinearMath/btAlignedObjectArray.h"
#include "CommonInterfaces/CommonRigidBodyBase.h"
#include "CommonInterfaces/CommonGUIHelperInterface.h"
#include "CommonInterfaces/CommonParameterInterface.h"
#include "BulletCollision/CollisionShapes/btConvexHullShape.h"
#include "BulletDynamics/MLCPSolvers/btDantzigSolver.h"
#include "BulletDynamics/MLCPSolvers/btSolveProjectedGaussSeidel.h"
#include "BulletDynamics/MLCPSolvers/btMLCPSolver.h"
#include "BulletDynamics/ConstraintSolver/btNNCGConstraintSolver.h"
#include "Importers/ImportObjDemo/LoadMeshFromObj.h"
#include "BulletCollision/Gimpact/btGImpactShape.h"
#include "BulletCollision/Gimpact/btGImpactCollisionAlgorithm.h"
#include "BulletCollision/NarrowPhaseCollision/btRaycastCallback.h"
#include <BulletCollision/CollisionShapes/btConvexHullShape.h>
#include <OpenGLWindow/GLInstanceGraphicsShape.h>
#include <LoadObj.h>

#define BIT(x) (1<<(x))

enum collisiontypes {
		COL_NOTHING = 0, //Collide with nothing
		COL_HEAD = BIT(0), //Collide with head
		COL_FOLLICLE = BIT(1), //Collide with follicles
		COL_BASE = BIT(2),		// Collide with base
		COL_ARRAY_R = BIT(3), //Collide with array r
		COL_ARRAY_L = BIT(4), //Collide with array l
		COL_ENV = BIT(5)	//Collide with environment
	};

static int headCollidesWith = COL_NOTHING;
static int arrayRCollidesWith = COL_ENV;
static int arrayLCollidesWith = COL_ENV;
static int envCollidesWith = COL_ARRAY_L | COL_ARRAY_R;
static int baseCollidesWith = COL_NOTHING;
static int follicleCollidesWith = COL_NOTHING;

btCollisionShape* createSphereShape(btScalar radius);
btRigidBody* createDynamicBody(float mass, const btTransform& startTransform, btCollisionShape* shape, GUIHelperInterface* m_guiHelper,  btVector4 color=btVector4(1,1,1,1));

void translateFrame(btTransform& transform, btVector3 origin=btVector3(0.,0.,0.));
void rotateFrame(btTransform& transform, btVector3 rotation=btVector3(0.,0.,0.));

btTransform rotX(float angle);
btTransform rotY(float angle);
btTransform rotZ(float angle);
btTransform createFrame(btVector3 origin=btVector3(0.,0.,0.), btVector3 rotation=btVector3(0.,0.,0.));

#endif