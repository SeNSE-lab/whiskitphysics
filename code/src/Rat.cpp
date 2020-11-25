
#include "Rat.h"

Rat::Rat(GUIHelperInterface* helper,btDiscreteDynamicsWorld* world, btAlignedObjectArray<btCollisionShape*>* shapes, Parameters* parameters){
	// set initial position and orientation of rat head
	btVector3 position = btVector3(parameters->RATHEAD_LOC[0],parameters->RATHEAD_LOC[1],parameters->RATHEAD_LOC[2]);
	btVector3 orientation = btVector3(parameters->RATHEAD_ORIENT[0],parameters->RATHEAD_ORIENT[1],parameters->RATHEAD_ORIENT[2]);
	
	// create transform for ratHead
	btTransform headTransform = createFrame(position, orientation);
	
	// define shape and body of head (mass=100)
	btVector4 color = btVector4(0.1,0.1,0.1,1);
	rathead = new Object(helper,world,shapes,headTransform,parameters->dir_rathead,color,SCALE/10,100.,COL_HEAD,headCollidesWith);
	
	// set rathead->body to active state
	rathead->body->setActivationState(DISABLE_DEACTIVATION);

	// create new Whiskers for this rat head
	// origin: mean possition of all beasepoints
	btTransform head2origin = createFrame(originOffset,originOrientation);
	// create Whiskers
	if(!parameters->NO_WHISKERS){
		for(int w=0;w<parameters->WHISKER_NAMES.size();w++){
			Whisker* whisker = new Whisker(world, helper, shapes, parameters->WHISKER_NAMES[w], parameters);
			whisker->buildWhisker(rathead->body, head2origin);
			m_whiskerArray.push_back(whisker);
		}
	}
			
}

btAlignedObjectArray<Whisker*> Rat::getArray(){
	return m_whiskerArray;
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

void Rat::setLinearVelocity(btVector3 shift){
	rathead->body->setLinearVelocity(shift);
}
void Rat::setAngularVelocity(btVector3 rotation){
	rathead->body->setAngularVelocity(rotation);
}
const btVector3 Rat::getLinearVelocity(){
	return rathead->body->getLinearVelocity();
}
const btVector3 Rat::getAngularVelocity(){
	return rathead->body->getAngularVelocity();
}

void Rat::whisk(int step, std::vector<std::vector<float>> whisker_vel){
	// total number of steps in one cycle of whisking phase
	int totalStep = whisker_vel[0].size()/3;
	
	// for every whisker, read its angular velocity at this step
	for (int i=0;i<m_whiskerArray.size();i++){
		int idx = m_whiskerArray[i]->idx;
		btScalar a_vel_0 = whisker_vel[idx][(step%totalStep)*3-3];
		btScalar a_vel_1 = whisker_vel[idx][(step%totalStep)*3-2];
		btScalar a_vel_2 = whisker_vel[idx][(step%totalStep)*3-1];
		m_whiskerArray[i]->whisk(a_vel_0, a_vel_1, a_vel_2, getAngularVelocity());
	}
}

void Rat::setVelocity(btVector3 linearVelocity, btVector3 angularVelocity, btScalar dtheta, int activeFlag){
	
	btTransform headTransform = getTransform();
	btTransform originTransform = createFrame(originOffset,originOrientation);
	setLinearVelocity(linearVelocity);
	setAngularVelocity(angularVelocity);
	
	for (int i=0;i<m_whiskerArray.size();i++){
		m_whiskerArray[i]->updateVelocity(linearVelocity, angularVelocity, headTransform, originTransform, dtheta, activeFlag);
	}
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
			
			
			if (ptdist < 0.5){
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
