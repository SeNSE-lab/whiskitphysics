

#include "Simulation_utility.hpp"

// Helper Functions for simulation
// ================================

btCollisionShape* createSphereShape(btScalar radius){
	btCollisionShape* colShape = new btSphereShape(radius);
	// std::cout << "-> sphere shape created (scaled): " << SCALE*radius << std::endl;
	return colShape;

}

// function to create dynamic body
btRigidBody* createDynamicBody(float mass, const btTransform& bodyTransform, btCollisionShape* shape,GUIHelperInterface* m_guiHelper,  btVector4 color)
{
	btAssert((!shape || shape->getShapeType() != INVALID_SHAPE_PROXYTYPE));

	//rigidbody is dynamic if and only if mass is non zero, otherwise static
	bool isDynamic = (mass != 0.f);

	btVector3 localInertia(0, 0, 0);
	if (isDynamic){
		shape->calculateLocalInertia(mass, localInertia);
	}
	else{
		// std::cout << "Warning: body mass is zero!" << std::endl;
	}

	//using motionstate is recommended, it provides interpolation capabilities, and only synchronizes 'active' objects
	btDefaultMotionState* myMotionState = new btDefaultMotionState(bodyTransform);

	btRigidBody::btRigidBodyConstructionInfo cInfo(mass, myMotionState, shape, localInertia);

	btRigidBody* body = new btRigidBody(cInfo);
	body->setUserIndex(-1);
		
	return body;
}


// function to create frame
btTransform createFrame(btVector3 origin, btVector3 rotation){
	btTransform frame;
	frame = btTransform::getIdentity();
	frame.setOrigin(origin);
	frame.getBasis().setEulerZYX(rotation[0],rotation[1],rotation[2]);
	return frame;
}

// function to translate frame
void translateFrame(btTransform& transform, btVector3 origin){

	transform.setOrigin(origin);
}

// function to rotate frame with eular angles
void rotateFrame(btTransform& transform, btVector3 rotation){

	btScalar rx = rotation[0];	// roll
	btScalar ry = rotation[1];	// pitch
	btScalar rz = rotation[2];	// yaw

	transform.getBasis().setEulerZYX(rx,ry,rz);
}

btTransform rotX(float angle){

	btTransform transform = createFrame();
	btQuaternion rot = btQuaternion(btVector3(1,0,0),angle);	// roll
	transform.setRotation(rot);
	return transform;
}

btTransform rotY(float angle){

	btTransform transform = createFrame();
	btQuaternion rot = btQuaternion(btVector3(0,1,0),angle);	// pitch
	transform.setRotation(rot);
	return transform;
}

btTransform rotZ(float angle){

	btTransform transform = createFrame();
	btQuaternion rot = btQuaternion(btVector3(0,0,1),angle);	// yaw
	transform.setRotation(rot);
	return transform;
}


