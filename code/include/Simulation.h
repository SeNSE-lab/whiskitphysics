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

#ifndef SIMULATION_H
#define SIMULATION_H

#include "Rat.h"
#include "Object.h"
#include "Simulation_utility.h"
#include "Simulation_IO.h"

#include <iostream>
#include <chrono> 
#include <iomanip>      // std::setprecision

#include "btBulletDynamicsCommon.h"
#include "LinearMath/btVector3.h"
#include "LinearMath/btAlignedObjectArray.h"
#include "LinearMath/btQuaternion.h"
#include "CommonInterfaces/CommonRigidBodyBase.h"
#include "CommonInterfaces/CommonGUIHelperInterface.h"
#include "CommonInterfaces/CommonParameterInterface.h"

class Simulation* SimulationCreateFunc(struct CommonExampleOptions& options);

class Simulation : public CommonRigidBodyBase
{

private: 
	
	btScalar m_time_elapsed;
	btScalar m_time;
	int m_step;

	btVector3 gravity = btVector3(0,0,-9.8*SCALE);
	btAlignedObjectArray<btVector3> m_objcenter; // store center position calculated from bounding box for all objs, before start trans
    btAlignedObjectArray<btVector3> m_objboundingbox; // store bounding box for all objs, before start trans

	btRigidBody* peg;
	btRigidBody* wall;
	btVector3 vec;
	Rat* scabbers;
	Object* object;
	Object* env;
	Object* curvWall;
	output* data_dump = new output();
	std::vector<float> this_loc_vel;


public:
	Simulation(struct GUIHelperInterface* helper):CommonRigidBodyBase(helper){}
	virtual ~Simulation(){}
	virtual void initPhysics();
	virtual void stepSimulation();
	
	output* get_results();
	
	
	btScalar camPos[3];
	btScalar camDist;
	btScalar camPitch;
	btScalar camYaw;
	void resetCamera();

	// other
	bool exitSim;
	Parameters* parameters;
	
};

#endif //SIMULATION_H