
#include "Rat.hpp"

Rat::Rat(GUIHelperInterface* helper,btDiscreteDynamicsWorld* world, btAlignedObjectArray<btCollisionShape*>* shapes, Parameters* parameters){
	
	whisker_names = parameters->WHISKER_NAMES;
	btVector4 color = btVector4(0.5,0.5,0.5,1);

	// set initial position and orientation of rat head
	init_pos = btVector3(parameters->POSITION[0],parameters->POSITION[1],parameters->POSITION[2]);
	init_quat.setEulerZYX(parameters->YAW*PI/180.,parameters->ROLL*PI/180.,parameters->PITCH*PI/180.);
	
	// create reference body for rat (static): change mass to non-zero value if you want dynamic (but consider gravity!)
	btTransform ratTransform = createFrame(init_pos);
	ratTransform.setRotation(init_quat);
	btSphereShape* ratShape = new btSphereShape(0.0001*SCALE);
	shapes->push_back(ratShape);
	rat = createDynamicBody(1,ratTransform,ratShape,helper,color);
	world->addRigidBody(rat,COL_HEAD,headCollidesWith);
	ratTransform = rat->getCenterOfMassTransform();

	btTransform headTransform = createFrame();
	btQuaternion headRotation = btQuaternion(0,0,0);
	headTransform.setRotation(headRotation);

	// define shape and body of head
	rathead = new Object(helper,world,shapes,"../data/3D_data/NewRatHead.obj",color,SCALE/10,100.,COL_HEAD,headCollidesWith);
	btTransform trans = ratTransform*headTransform;
	rathead->body->setCenterOfMassTransform(trans);

	// define origin of the whisker array
	btTransform originTransform = createFrame(originOffset*SCALE,originOrientation);
	btSphereShape* originShape = new btSphereShape(0.0001*SCALE);
	shapes->push_back(originShape);
	origin = createDynamicBody(1000.0,ratTransform*headTransform*originTransform,originShape,helper,color);
	world->addRigidBody(origin,COL_HEAD,headCollidesWith);

	// activate bodies
	rathead->body->setActivationState(DISABLE_SIMULATION);
	origin->setActivationState(DISABLE_SIMULATION);
	rat->setActivationState(DISABLE_SIMULATION);

	// define constraints for neck
	btTransform headFrame = headTransform.inverse();
	btTransform neckFrame = createFrame();
	neckConstraint = new btGeneric6DofConstraint (*rat, *rathead->body, neckFrame, headFrame,true);

	neckConstraint->setLinearLowerLimit(btVector3(0.,0.,0));
	neckConstraint->setLinearUpperLimit(btVector3(0.,0.,0));
	neckConstraint->setAngularLowerLimit(btVector3(0,0.,0));
	neckConstraint->setAngularUpperLimit(btVector3(0,0,0));

	// add constraint to world
	world->addConstraint(neckConstraint,true);
	neckConstraint->setDbgDrawSize(btScalar(1.f));

	// define constraints for array origin
	headFrame = createFrame();
	btTransform originFrame = createFrame();
	originConstraint = new btGeneric6DofConstraint(*rathead->body, *origin, headFrame, originFrame,true);
	
	originConstraint->setLinearLowerLimit(originOffset*SCALE);
	originConstraint->setLinearUpperLimit(originOffset*SCALE);
	originConstraint->setAngularLowerLimit(btVector3(0.,0.,0.));
	originConstraint->setAngularUpperLimit(btVector3(0.,0.,0.));

	// // add constraint to world
	world->addConstraint(originConstraint,true);
	originConstraint->setDbgDrawSize(btScalar(1.f));

	// create Whiskers
	if(!parameters->NO_WHISKERS){
		for(int w=0;w<parameters->WHISKER_NAMES.size();w++){
			Whisker* whisker = new Whisker(world,helper, shapes,parameters, origin,parameters->WHISKER_NAMES[w]);
			m_whiskerArray.push_back(whisker);
	
		}
	}
			
}

Whisker* Rat::get_whisker(int index){
	return m_whiskerArray[index];
}


btVector3 Rat::get_position(){
	btVector3 position = rat->getCenterOfMassPosition();
	// std::cout << position[0] << ", " << position[1] << ", " << position[2] << std::endl;
	return position;
}

void Rat::translateHead(btVector3 new_position){
	
	btTransform trans;
	trans = rat->getCenterOfMassTransform();
	btMotionState* motionState = rat->getMotionState();

	btVector3 position = rat->getCenterOfMassPosition();
	trans.setOrigin(new_position);

	rat->setCenterOfMassTransform(trans);
	motionState->setWorldTransform(trans);

}

void Rat::rotateHead(btQuaternion rotation){
	
	btTransform trans;
	trans = rat->getCenterOfMassTransform();
	btMotionState* motionState = rat->getMotionState();

	btQuaternion orientation = trans.getRotation();
	trans.setRotation(orientation*rotation);

	rat->setCenterOfMassTransform(trans);
	motionState->setWorldTransform(trans);

}

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
		m_whiskerArray[i]->whisk(dtheta);
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
