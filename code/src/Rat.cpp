
#include "Rat.hpp"

// constructor
Rat::Rat(GUIHelperInterface* helper,btDiscreteDynamicsWorld* world, btAlignedObjectArray<btCollisionShape*>* shapes, Parameters* parameters){
	btVector4 color = btVector4(0.5,0.5,0.5,1);
	/* Remark:
	The reason why some of these rigid bodies has mass, where they're really supposed
	to be a kinematic object, is that setting mass to zero will make them static. 
	This could potentially be a bug in Bullet engine, or misuse of code that can be
	implemented correctly. It is worth looking back at this problem only if the current
	solution (use large mass) will result in non-negligible error.
	*/

	// START TO CREATE RAT HEAD OBJECT//////////////////////////////////////////
	// supposed to be kinematic object following scripted path ///////////////// 
	// set initial position and orientation of rat head
	btVector3 position = btVector3(parameters->POSITION[0],parameters->POSITION[1],parameters->POSITION[2]);
	btVector3 orientation = btVector3(parameters->ORIENTATION[0],parameters->ORIENTATION[1],parameters->ORIENTATION[2]);
	// init_quat.setEulerZYX(parameters->YAW*PI/180.,parameters->ROLL*PI/180.,parameters->PITCH*PI/180.);
	// create transform for ratHead
	btTransform headTransform = createFrame(position, orientation);
	// define shape and body of head (mass=100)
	// rathead->body is added to the world in Object.cpp, also pushed back into shapes
	rathead = new Object(helper,world,shapes,headTransform,"../data/NewRatHead.obj",color,SCALE/10,100.,COL_HEAD,headCollidesWith);
	// END OF CREATING RAT HEAD OBJECT /////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////

	// set rathead->body to active state
	rathead->body->setActivationState(DISABLE_DEACTIVATION);

	// create new Whiskers for this rat head
	btTransform head2origin = createFrame(originOffset*SCALE,originOrientation);
	if(!parameters->NO_WHISKERS){
		for(int w=0;w<parameters->WHISKER_NAMES.size();w++){
			// construct whisker prototype
			Whisker* whisker = new Whisker(world, helper, shapes, parameters->WHISKER_NAMES[w], parameters->WHISKER_INDEX[w], parameters);
			// specify whisker by name
			whisker->buildWhisker(rathead->body, head2origin);
			// Rat::m_whiskerArray
			m_whiskerArray.push_back(whisker);
		}
	}
}


Whisker* Rat::getWhisker(int index){
	return m_whiskerArray[index];
}


const btVector3 Rat::getPosition(){
	return rathead->body->getCenterOfMassPosition();
}

const btTransform Rat::getTransform(){
	return rathead->body->getCenterOfMassTransform();
}

void Rat::setTransform(btTransform tr){
	rathead->body->setCenterOfMassTransform(tr);
}

// set/get the linear/angular velocity
void Rat::setLinearVelocity(btVector3 shift){
	rathead->body->setLinearVelocity(shift);
}
void Rat::setAngularVelocity(btVector3 rotation){
	rathead->body->setAngularVelocity(rotation);
}
btVector3 Rat::getLinearVelocity(){
	return rathead->body->getLinearVelocity();
}
btVector3 Rat::getAngularVelocity(){
	return rathead->body->getAngularVelocity();
}

/*
void Rat::moveArray(btScalar t, btScalar dt, btScalar freq, btScalar angle_fwd, btScalar angle_bwd){
	
	//calculate target velocity
	btScalar amp = (angle_fwd + angle_bwd)/2*PI/180;
	btScalar w = 2*PI*freq;
	btScalar shift = (angle_fwd - angle_bwd)/2*PI/180;
	btScalar phase = asin(shift/amp);
	btScalar prevtheta = (amp*sin(w*(t-dt) + phase)-sin(phase));
	btScalar theta = (amp*sin(w*t + phase)-sin(phase));
	btScalar dtheta = (theta-prevtheta)/dt;

	for (int i=0;i<m_whiskerArray.size();i++){
		m_whiskerArray[i]->moveWhisker(dtheta, getAngularVelocity());
	}
}
*/

void Rat::whisk(int step, std::vector<std::vector<float>> whisker_loc_vel){
	// total number of steps in one cycle of whisking phase
	int totalStep = whisker_loc_vel[0].size()/3;
	// for every whisker, read its angular velocity at this step
	for (int i=0;i<m_whiskerArray.size();i++){
		int idx = m_whiskerArray[i]->m_index;
		btScalar a_vel_0 = whisker_loc_vel[idx][(step%totalStep)*3];
		btScalar a_vel_1 = whisker_loc_vel[idx][(step%totalStep)*3+1];
		btScalar a_vel_2 = whisker_loc_vel[idx][(step%totalStep)*3+2];
		m_whiskerArray[i]->whisk(a_vel_0, a_vel_1, a_vel_2, getAngularVelocity());
	}
}


	
void Rat::calc_offset(btScalar protraction,btScalar freq, btScalar angle_fwd, btScalar angle_bwd){

	btScalar amp = (angle_fwd + angle_bwd)/2 * PI / 180;
	btScalar shift = (angle_fwd - angle_bwd)/2 * PI / 180;
	btScalar phase = asin(shift/amp);
	btScalar t_offset = (asin((protraction*PI/180-sin(phase)/amp))+phase)/(2*PI*freq);

}

btAlignedObjectArray<Whisker*> Rat::getArray(){
	return m_whiskerArray;
}


// function to retrieve torques at base points
void Rat::dump_M(output* data){

	std::vector<btScalar> mx;
	std::vector<btScalar> my;
	std::vector<btScalar> mz;

	for(int w=0; w < m_whiskerArray.size(); w++){
		btVector3 moments = m_whiskerArray[w]->getTorques();
		mx.push_back(moments[0]);
		my.push_back(moments[1]);
		mz.push_back(moments[2]);
	}
	data->Mx.push_back(mx);
	data->My.push_back(my);
	data->Mz.push_back(mz);
}

// function to retrieve forces at base points
void Rat::dump_F(output* data){
	
	std::vector<btScalar> fx;
	std::vector<btScalar> fy;
	std::vector<btScalar> fz;

	for(int w=0; w < m_whiskerArray.size(); w++){
		btVector3 forces = m_whiskerArray[w]->getForces();
		fx.push_back(forces[0]);
		fy.push_back(forces[1]);
		fz.push_back(forces[2]);
	}
	data->Fx.push_back(fx);
	data->Fy.push_back(fy);
	data->Fz.push_back(fz);
}

// function to obtain x coordinates of all whisker units
void Rat::dump_Q(output* data){

	for(int w=0; w < m_whiskerArray.size(); w++){
		data->Q[w].X.push_back(m_whiskerArray[w]->getX());
		data->Q[w].Y.push_back(m_whiskerArray[w]->getY());
		data->Q[w].Z.push_back(m_whiskerArray[w]->getZ());
		data->Q[w].C.push_back(m_whiskerArray[w]->getCollision());
	}
}

// detect collisions between whiskers and objects
void Rat::detect_collision(btDiscreteDynamicsWorld* world){

	world->performDiscreteCollisionDetection();

	int numManifolds = world->getDispatcher()->getNumManifolds();
	//For each contact manifold
	for (int i = 0; i < numManifolds; i++) {
		btPersistentManifold* contactManifold = world->getDispatcher()->getManifoldByIndexInternal(i);
		btCollisionObject* obA = const_cast<btCollisionObject*>(contactManifold->getBody0());
		btCollisionObject* obB = const_cast<btCollisionObject*>(contactManifold->getBody1());
		contactManifold->refreshContactPoints(obA->getWorldTransform(), obB->getWorldTransform());
		int numContacts = contactManifold->getNumContacts();
		
		//For each contact point in that manifold
		for (int j = 0; j < numContacts; j++) {
			//Get the contact information
			btManifoldPoint& pt = contactManifold->getContactPoint(j);
			btVector3 ptA = pt.getPositionWorldOnA();
			btVector3 ptB = pt.getPositionWorldOnB();
			double ptdist = pt.getDistance();
			
			
			if (ptdist < 0.0001){
				int* coll0 = (int*) obA->getUserPointer();
				if(coll0!=nullptr){
					*coll0 = 1;
				}
				int* coll1 = (int*) obB->getUserPointer();
				if(coll1!=nullptr){
					*coll1 = 1;
				}
			}
		
		}
	}
}
