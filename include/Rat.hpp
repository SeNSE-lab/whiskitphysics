
#ifndef WHISKERARRAY_HPP
#define WHISKERARRAY_HPP


#include "Whisker.hpp"
#include "Simulation_utility.hpp"
#include "Simulation_IO.hpp"
#include "Object.hpp"
#include <vector>
#include <string>

class Rat
{
private:

	btGeneric6DofConstraint* ratConstraint;
	btGeneric6DofConstraint* neckConstraint;
	btGeneric6DofConstraint* originConstraint;

	btAlignedObjectArray<Whisker*> m_whiskerArray;

	std::vector<std::string> whisker_names;

	Object* rathead;
	btRigidBody* origin;
	btRigidBody* rat;

	int collisionGroup;
	int collisionMask;

	btVector3 init_pos = btVector3(0,0,0);
	btQuaternion init_quat = btQuaternion(btVector3(0,0,1),0);
	
	btVector3 originOffset = btVector3(0,0.027,0.004);
	btVector3 originOrientation = btVector3(0,0,0);

public:

	Rat(GUIHelperInterface* helper, btDiscreteDynamicsWorld* world, btAlignedObjectArray<btCollisionShape*>* shapes, Parameters* parameters);
	~Rat(){}

	Whisker* get_whisker(int index);
	btVector3 get_position();

	void translateHead(btVector3 position);
	void rotateHead(btQuaternion rotation);

	void moveArray(float time, float step, float freq, float angle_fwd, float angle_bwd);
	void calc_offset(float protraction, float freq, float angle_fwd, float angle_bwd);
    btAlignedObjectArray<Whisker*> getArray();

	void dump_M(output* data);
	void dump_F(output* data);
	void dump_Q(output* data);

	void detect_collision(btDiscreteDynamicsWorld* world);
};




#endif //BASIC_DEMO_PHYSICS_SETUP_H