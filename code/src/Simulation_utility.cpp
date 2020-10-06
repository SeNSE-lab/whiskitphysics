
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

This code is based on code published by
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2015 Google Inc. http://bulletphysics.org

*/

#include "Simulation_utility.h"

// Helper Functions for simulation
// ================================

btCollisionShape* createSphereShape(btScalar radius){
	btCollisionShape* colShape = new btSphereShape(radius);
	// std::cout << "-> sphere shape created (scaled): " << SCALE*radius << std::endl;
	return colShape;

}

// function to create dynamic body
btRigidBody* createDynamicBody(float mass,float friction,  const btTransform& bodyTransform, btCollisionShape* shape,GUIHelperInterface* m_guiHelper,  btVector4 color, btScalar restitution)
{
	btAssert((!shape || shape->getShapeType() != INVALID_SHAPE_PROXYTYPE));

	//rigidbody is dynamic if and only if mass is non zero, otherwise static
	bool isDynamic = (mass != 0.f);

	btVector3 localInertia(0, 0, 0);
	if (isDynamic){
		shape->calculateLocalInertia(mass, localInertia);
	}
	else{
		// std::cout << "Warning: body mass is zero!" << std::endl;
	}

	//using motionstate is recommended, it provides interpolation capabilities, and only synchronizes 'active' objects
	btDefaultMotionState* myMotionState = new btDefaultMotionState(bodyTransform);

	btRigidBody::btRigidBodyConstructionInfo cInfo(mass, myMotionState, shape, localInertia);
	cInfo.m_restitution = restitution;
	cInfo.m_friction = friction;
	btRigidBody* body = new btRigidBody(cInfo);
	body->setUserIndex(-1);
		
	return body;
}


// function to create frame
btTransform createFrame(btVector3 origin, btVector3 rotation){
	btTransform frame;
	frame = btTransform::getIdentity();
	frame.setOrigin(origin);
	frame.getBasis().setEulerZYX(rotation[0],rotation[1],rotation[2]);
	return frame;
}

// function to translate frame
void translateFrame(btTransform& transform, btVector3 origin){

	transform.setOrigin(origin);
}

// function to rotate frame with eular angles
void rotateFrame(btTransform& transform, btVector3 rotation){

	btScalar rx = rotation[0];	// roll
	btScalar ry = rotation[1];	// pitch
	btScalar rz = rotation[2];	// yaw

	transform.getBasis().setEulerZYX(rx,ry,rz);
}

btTransform rotX(float angle){

	btTransform transform = createFrame();
	btQuaternion rot = btQuaternion(btVector3(1,0,0),angle);	// roll
	transform.setRotation(rot);
	return transform;
}

btTransform rotY(float angle){

	btTransform transform = createFrame();
	btQuaternion rot = btQuaternion(btVector3(0,1,0),angle);	// pitch
	transform.setRotation(rot);
	return transform;
}

btTransform rotZ(float angle){

	btTransform transform = createFrame();
	btQuaternion rot = btQuaternion(btVector3(0,0,1),angle);	// yaw
	transform.setRotation(rot);
	return transform;
}


