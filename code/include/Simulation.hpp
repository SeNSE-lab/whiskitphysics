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

#ifndef SIMULATION_HPP
#define SIMULATION_HPP

#include "Rat.hpp"
#include "Object.hpp"
#include "Simulation_utility.hpp"
#include "Simulation_IO.hpp"

#include <iostream>
#include <chrono> 

#include "btBulletDynamicsCommon.h"
#include "LinearMath/btVector3.h"
#include "LinearMath/btAlignedObjectArray.h"
#include "LinearMath/btQuaternion.h"



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
	output* data_dump = new output();
	std::vector<float> this_loc_vel;



	
	

public:
	// Declare constructor and deconstructor
	Simulation(struct GUIHelperInterface* helper):CommonRigidBodyBase(helper){}
	virtual ~Simulation(){delete data_dump;}
	void initParameter(Parameters* para);
	virtual void initPhysics();
	virtual void stepSimulation();
	
	output* get_results();
	
	// cam parameter
	float camDist;
	float camPitch;
	float camYaw;
	float camPos[3];

	void resetCamera()
	{		
		m_guiHelper->resetCamera(camDist,camYaw,camPitch,camPos[0],camPos[1],camPos[2]);
	}
	// xz plane
	// btScalar dist = 0.06*SCALE;
	// btScalar pitch = 0;
	// btScalar yaw = 0;

	// yz plane
	// btScalar dist = 0.06*SCALE;
	// btScalar pitch = 0;
	// btScalar yaw = 90;

	// xy plane
	// btScalar dist = 0.05*SCALE;
	// btScalar pitch = -89;
	// btScalar yaw = 180;

	// other
	bool exitSim;
	Parameters* parameters;
	
};

#endif //SIMULATION_HPP
