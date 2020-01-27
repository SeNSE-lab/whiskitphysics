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

#ifndef RAT_HPP
#define RAT_HPP


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
	btGeneric6DofConstraint* controlConstraint;
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
	
	btTransform originTransform;
	btVector3 originOffset = btVector3(0,0.027,0.004);
	btVector3 originOrientation = btVector3(0,0,0);

	btScalar dtheta, angle_fwd, angle_bwd;

public:

	Rat(GUIHelperInterface* helper, btDiscreteDynamicsWorld* world, btAlignedObjectArray<btCollisionShape*>* shapes, Parameters* parameters);
	~Rat(){}

	Whisker* get_whisker(int index);
	btVector3 get_position();

	void setVelocity(btVector3 linearVelocity, btVector3 angularVelocity, btScalar activeFlag=0);
	void setWorldTransform(btTransform trans, btScalar activeFlag=0);

	void moveArray(float time, float step, float freq, float angle_fwd, float angle_bwd);
	void calc_offset(float protraction, float freq, float angle_fwd, float angle_bwd);
    btAlignedObjectArray<Whisker*> getArray();

	void dump_M(output* data);
	void dump_F(output* data);
	void dump_Q(output* data);

	void detect_collision(btDiscreteDynamicsWorld* world);
};




#endif //RAT_HPP