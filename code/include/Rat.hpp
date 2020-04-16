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

	// btScalar dtheta, angle_fwd, angle_bwd;

public:

	Rat(GUIHelperInterface* helper, btDiscreteDynamicsWorld* world, btAlignedObjectArray<btCollisionShape*>* shapes, Parameters* parameters);
	~Rat(){}

	Whisker* getWhisker(int index);

	void setLinearVelocity(btVector3 position);
	void setAngularVelocity(btVector3 rotation);
	void setTransform(btTransform tr);
	const btVector3 getPosition();
	const btTransform getTransform();
	const btVector3 getLinearVelocity();
	const btVector3 getAngularVelocity();

    btAlignedObjectArray<Whisker*> getArray();

	void dump_M(output* data);
	void dump_F(output* data);
	void dump_Q(output* data);

	void detect_collision(btDiscreteDynamicsWorld* world);
};




#endif //RAT_HPP