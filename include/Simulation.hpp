
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
	
	float m_time_elapsed;
	float m_time;
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



	
	

public:

	

	Simulation(struct GUIHelperInterface* helper):CommonRigidBodyBase(helper){}
	virtual ~Simulation(){}
	virtual void initPhysics();
	virtual void exitPhysics();
	virtual void stepSimulation();
	virtual void renderScene();
	
	output* get_results();
	
	float dist = 0.1*SCALE;
	float pitch = -30;
	float yaw = 50;
	float targetPos[3]={0,0,0};

	void resetCamera()
	{		
		m_guiHelper->resetCamera(dist,yaw,pitch,targetPos[0],targetPos[1],targetPos[2]);
	}
	// xz plane
	// float dist = 0.06*SCALE;
	// float pitch = 0;
	// float yaw = 0;

	// yz plane
	// float dist = 0.06*SCALE;
	// float pitch = 0;
	// float yaw = 90;

	// xy plane
	// float dist = 0.05*SCALE;
	// float pitch = -89;
	// float yaw = 180;

	// other
	bool exitSim;
	Parameters* parameters;
	
};

#endif //BASIC_DEMO_PHYSICS_SETUP_H
