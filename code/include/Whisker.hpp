#ifndef WHISKER_HPP
#define WHISKER_HPP
// This header file declares
//		A "link_data" struct
//		A "whisker" class:
//			constructor
//			createWhisker()
//			moveWhisker()
//			get_unit/follicle/base()
//			getX/Y/Z()
//			getCollision()

#include "Simulation_IO.hpp"
#include "Simulation_utility.hpp"
#include "Parameters.hpp"

#include "btBulletDynamicsCommon.h"
#include "BulletWorldImporter/btWorldImporter.h"
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

	btRigidBody* base;
	btRigidBody* basepoint;
	btAlignedObjectArray<btRigidBody*> whisker;
	
	btGeneric6DofConstraint* basePointConstraint;
	btGeneric6DofConstraint* motorConstraint;
	btGeneric6DofConstraint* baseConstraint;
	btJointFeedback baseFeedback;

	float m_time;
	float m_angle;
	int ACTIVE;
	int NO_MASS;
	int BLOW; //for visual clearity
	int PRINT;

	std::vector<int> collide;	// collide array: size of # of links
								// Whisker::createWhisker: 
								//		initialized all zeros
								// 		points every element to a link
								// (at every simulation step)
								// Rat::detect_collision: 
								// 		set collided link's element to 1
								// Whisker::getCollision:
								//		return all elements as in "flags"
								//		reset all elements back to 0
	
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

	Whisker(btDiscreteDynamicsWorld* world, GUIHelperInterface* m_guiHelper,btAlignedObjectArray<btCollisionShape*>* shapes, std::string w_name, int w_index, Parameters* parameters);
	~Whisker(){}
	int m_index;

	void buildWhisker(btRigidBody* refBody, btTransform offset);
	// void moveWhisker(btScalar dps, btVector3 headAngularVelocity);
	void whisk(btScalar a_vel_0, btScalar a_vel_1, btScalar a_vel_2, btVector3 headAngularVelocity);
	
	btRigidBody* get_unit(int idx) const;
	btRigidBody* get_base() const;

	btVector3 getTorques() const;
	btVector3 getForces() const;

	std::vector<float> getX() const;
	std::vector<float> getY() const;
	std::vector<float> getZ() const;
	std::vector<int> getCollision(); // update the vector<int> collide array
};


#endif //BASIC_DEMO_PHYSICS_SETUP_H
