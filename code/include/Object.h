/*
WHISKiT Physics Simulator
Copyright (C) 2019 Nadina Zweifel (SeNSE Lab)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#ifndef OBJECT_H
#define OBJECT_H


#include "Whisker.h"
#include "Simulation_utility.h"
#include "Simulation_IO.h"
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

	Object(GUIHelperInterface* helper,btDiscreteDynamicsWorld* world, btAlignedObjectArray<btCollisionShape*>* shapes, btTransform trans,
	std::string filename, btVector4 color, float scaling, float mass, int colGroup, int colMask);
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




#endif //OBJECT_H