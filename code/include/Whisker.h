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

#ifndef WHISKER_H
#define WHISKER_H

#include "Simulation_IO.h"
#include "Simulation_utility.h"
#include "Parameters.h"

#include "btBulletDynamicsCommon.h"
#include "Serialize/BulletWorldImporter/btWorldImporter.h"
#include "LinearMath/btVector3.h"
#include "LinearMath/btAlignedObjectArray.h"

#include <iostream>
#include <vector>
#include <string>
#include <numeric>
#include <algorithm>
#include <map>
#include "math.h"

struct whisker_config{
	int index;
	std::string id;
	int side;
	int row;
	int col;
	float L;
	float a;
	std::vector<float> link_angles;
	btVector3 base_pos;
	btVector3 base_rot;
};

struct link_data
{
	int nr;
	btCollisionShape* shape;
	btScalar halfextent;
	btVector3 pt1;
	btVector3 pt2;
	btScalar radius1;
	btScalar radius2;
};

class Whisker
{
private:
	std::vector<float> dphi;
	std::vector<float> dzeta;
	btVector4 color;
	btDiscreteDynamicsWorld* m_dynamicsWorld;
	btAlignedObjectArray<btCollisionShape*>* m_collisionShapes;
	GUIHelperInterface* m_guiHelper;

	// btRigidBody* origin;
	btRigidBody* base;
	btRigidBody* basepoint;
	btAlignedObjectArray<btRigidBody*> whisker;

	// btTransform basepointTransform;
	btTransform baseTransform;
	
	btGeneric6DofConstraint* basePointConstraint;
	btGeneric6DofConstraint* motorConstraint;
	btGeneric6DofSpringConstraint* baseConstraint;
	btJointFeedback baseFeedback;

	float m_time;
	float m_angle;
	int ACTIVE;
	int NO_MASS;
	int BLOW; //for visual clearity
	int PRINT;

	whisker_config config;
	Parameters* parameters;
	std::vector<int> collide;
	
	// Whisker general configuration parameters
	float friction;
	btScalar mass;
	btScalar dt;
	int NUM_LINKS;
	int NUM_JOINTS;
	btScalar rho;
	btScalar rho_slope;
	btScalar E;
	btScalar zeta;

	// Whisker specific configuration parameters
	whisker_config get_config(std::string wname,Parameters* parameters);
	btScalar length;
	btScalar link_length;
	int row;
	int col;
	int side;
	btScalar radius_base;
	btScalar radius_slope;
	btScalar radius_tip;
	std::vector<btScalar> link_angles;
	btVector3 base_pos;
	btVector3 base_rot;
	
	btScalar calc_base_radius(int row, int col, btScalar S) const;
	btScalar calc_slope(btScalar L, btScalar rbase, int row, int col) const;
	btScalar calc_mass(btScalar length, btScalar R, btScalar r, btScalar rho) const;
	btScalar calc_inertia(btScalar radius) const;
	btScalar calc_com(btScalar length, btScalar R, btScalar r) const;
	btScalar calc_volume(btScalar length, btScalar R, btScalar r) const;
	btScalar calc_damping(btScalar k, btScalar mass, btScalar CoM, btScalar zeta, btScalar dt) const;
	btScalar calc_stiffness(btScalar E, btScalar I, btScalar length) const;
	float get_dzeta(int index) const;
	float get_dphi(int index) const;

public:

	Whisker(btDiscreteDynamicsWorld* world, GUIHelperInterface* m_guiHelper,btAlignedObjectArray<btCollisionShape*>* shapes, std::string w_name, Parameters* parameters);
	~Whisker(){}

	int idx;	
	void buildWhisker(btRigidBody* refBody, btTransform offset);
	// void updateVelocity(btScalar dtheta, int activeFlag);
	// void updateTransform();
	void whisk(btScalar a_vel_0, btScalar a_vel_1, btScalar a_vel_2, btVector3 headAngularVelocity);

	void updateVelocity(btVector3 linearVelocity, btVector3 angularVelocity, btTransform headTransform, btTransform head2origin, btScalar dtheta, int activeFlag);

	btRigidBody* get_unit(int idx) const;
	btRigidBody* get_base() const;

	btVector3 getTorques();
	btVector3 getForces();
	btVector3 getPosition(int linknr);
	
	std::vector<float> getX();
	std::vector<float> getY();
	std::vector<float> getZ();
	std::vector<int> getCollision();

};


#endif //WHISKER_H
