/*
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2015 Google Inc. http://bulletphysics.org

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.
Permission is granted to anyone to use this software for any purpose, 
including commercial applications, and to alter it and redistribute it freely, 
subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

#ifndef WHISKER_HPP
#define WHISKER_HPP

#include "Whisker_utility.hpp"
#include "Simulation_utility.hpp"
#include "Parameters.hpp"
#include <vector>
#include <string>

class Whisker
{
private:


	btDiscreteDynamicsWorld* m_dynamicsWorld;
	btAlignedObjectArray<btCollisionShape*>* m_collisionShapes;
	GUIHelperInterface* m_guiHelper;

	btRigidBody* origin;
	btRigidBody* base;
	btRigidBody* basepoint;
	btAlignedObjectArray<btRigidBody*> whisker;

	btTransform basepointTransform;
	
	btGeneric6DofConstraint* basePointConstraint;
	btGeneric6DofConstraint* motorConstraint;
	btGeneric6DofSpringConstraint* baseConstraint;
	btJointFeedback baseFeedback;

	whisker_config config;
	Parameters* parameters;
	std::vector<int> collide;
	
	

public:

	Whisker(btDiscreteDynamicsWorld* world, GUIHelperInterface* m_guiHelper,btAlignedObjectArray<btCollisionShape*>* shapes, Parameters* parameters, btRigidBody* refBody, std::string w_name);
	~Whisker(){}
	
	void updateVelocity(btScalar dtheta, int activeFlag);
	void updateTransform(btScalar activeFlag);

	btVector3 getTorques();
	btVector3 getForces();
	btVector3 getPosition(int linknr);
	
	std::vector<float> getX();
	std::vector<float> getY();
	std::vector<float> getZ();
	std::vector<int> getCollision();

};


#endif //WHISKER_HPP
