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
	btVector4 color;
	btDiscreteDynamicsWorld* m_dynamicsWorld;
	btAlignedObjectArray<btCollisionShape*>* m_collisionShapes;
	GUIHelperInterface* m_guiHelper;

	// btRigidBody* origin;
	btRigidBody* base;
	btRigidBody* basepoint;
	btAlignedObjectArray<btRigidBody*> whisker;

	btTransform basepointTransform;
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

public:

	Whisker(btDiscreteDynamicsWorld* world, GUIHelperInterface* m_guiHelper,btAlignedObjectArray<btCollisionShape*>* shapes, std::string w_name, Parameters* parameters);
	~Whisker(){}

	int idx;
	void buildWhisker(btRigidBody* refBody, btTransform offset);
	void whisk(btScalar a_vel_0, btScalar a_vel_1, btScalar a_vel_2, btVector3 headAngularVelocity);

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
