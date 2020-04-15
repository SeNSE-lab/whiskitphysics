
#ifndef WHISKERARRAY_HPP
#define WHISKERARRAY_HPP
// This header file declares:
//		"Rat" class with:
//			Constraints
//			constructor
//			get_whisker()
//			get_position()
//			translateHead()
//			rotateHead()
//			moveArray()
//			calc_offset()
//			detect_collision()
//			dump_M/F/Q()


#include "Whisker.hpp"
#include "Simulation_utility.hpp"
#include "Simulation_IO.hpp"
#include "Object.hpp"
#include <vector>
#include <string>

class Rat
{
private:
	// Rigid Bodies
	Object* rathead;
	btRigidBody* origin;
	// Constraints
	btGeneric6DofConstraint* originConstraint; 
	// Whiskers
	btAlignedObjectArray<Whisker*> m_whiskerArray;
	std::vector<std::string> whisker_names;
	
	btVector3 originOffset = btVector3(0,0.027,0.004);
	btVector3 originOrientation = btVector3(0,0,0);
public:

	Rat(GUIHelperInterface* helper, btDiscreteDynamicsWorld* world, btAlignedObjectArray<btCollisionShape*>* shapes, Parameters* parameters);
	~Rat(){};

	Whisker* getWhisker(int index);

	const btVector3 getPosition();
	const btTransform getTransform();
	void setLinearVelocity(btVector3 position);
	void setAngularVelocity(btVector3 rotation);
	void setTransform(btTransform tr);
	btVector3 getLinearVelocity();
	btVector3 getAngularVelocity();

	// void moveArray(float time, float step, float freq, float angle_fwd, float angle_bwd);
	void whisk(int step, std::vector<std::vector<float>> whisker_loc_vel);
	void calc_offset(float protraction, float freq, float angle_fwd, float angle_bwd);
    btAlignedObjectArray<Whisker*> getArray();

	void dump_M(output* data);
	void dump_F(output* data);
	void dump_Q(output* data);

	void detect_collision(btDiscreteDynamicsWorld* world);
};

#endif