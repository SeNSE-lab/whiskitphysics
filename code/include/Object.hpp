
#ifndef OBJECT_HPP
#define OBJECT_HPP


#include "Whisker.hpp"
#include "Simulation_utility.hpp"
#include "Simulation_IO.hpp"
#include <vector>
#include <string>

class Object

{
private:

	btVector3 principle_axis = btVector3(0,1,0).normalize();
	btVector3 init_pos = btVector3(0,0,0);
	btQuaternion init_quat = btQuaternion(btVector3(0,0,1),0);
    
	btDiscreteDynamicsWorld* dynamicsWorld;
	GUIHelperInterface* guiHelper;

	bool noShape = false;

public:

	Object(GUIHelperInterface* helper, btDiscreteDynamicsWorld* world, btAlignedObjectArray<btCollisionShape*>* shapes, std::string filename,
		btVector4 color, float scaling, float mass, int collisionGroup, int collisionMask);
	~Object(){}

	btRigidBody* body;
    btCollisionShape* shape;
	btConvexHullShape* hull;

	int collisionGroup;
	int collisionMask;

	btVector3 xyz_min;
	btVector3 xyz_max;

	void calcExtremes();
	void setPosition(btVector3 pos);
	void setOrientation(btVector3 axis, btScalar angle);

	btRigidBody* obj2DynamicBody(std::string fileName,btVector4 color, btVector3 position, btQuaternion orientation, btScalar mass, float scaling_factor, 
    	GUIHelperInterface* m_guiHelper,btAlignedObjectArray<btCollisionShape*>* m_collisionShapes,btDiscreteDynamicsWorld* m_dynamicsWorld);
	btRigidBody* obj2StaticBody(std::string fileName,btVector4 color, btVector3 position, btQuaternion orientation, btScalar mass, float scaling_factor, 
		GUIHelperInterface* m_guiHelper,btAlignedObjectArray<btCollisionShape*>* m_collisionShapes,btDiscreteDynamicsWorld* m_dynamicsWorld);


};




#endif //OBJECT_HPP