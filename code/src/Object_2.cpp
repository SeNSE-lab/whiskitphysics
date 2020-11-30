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

This code is based on code published by
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2015 Google Inc. http://bulletphysics.org

*/

#include "Object.h"

Object::Object(GUIHelperInterface* helper,btDiscreteDynamicsWorld* world, btAlignedObjectArray<btCollisionShape*>* shapes, btTransform trans,
	std::string filename, btVector4 color, float scaling, float mass, int colGroup, int colMask){

	dynamicsWorld = world;
	guiHelper = helper;
	collisionGroup = colGroup;
	collisionMask = colMask;

    // add object to world
	btVector3 obj_trans = trans.getOrigin();
	btQuaternion obj_orient = trans.getRotation();
	if(filename.compare("")!=0){
		body = createLargeMeshBody(filename,color,obj_trans,obj_orient,mass,scaling,helper,shapes,world);
		shape = body->getCollisionShape();
	}
	else{
		std::cout << "No shape defined..." << std::endl;
		noShape = true;
		btTransform someTransform = createFrame();
		btSphereShape* sphere = new btSphereShape(0.5);
		shapes->push_back(sphere);
		body = createDynamicBody(0,0.5,someTransform,sphere,helper,color);
		shape = body->getCollisionShape();
		
	}
	
	world->addRigidBody(body,collisionGroup,collisionMask);

}
	
void Object::setPosition(btVector3 pos){
	btTransform objTransform = body->getCenterOfMassTransform();
	objTransform.setOrigin(pos);
	body->setCenterOfMassTransform(objTransform);
	btVector3 CoM = body->getCenterOfMassPosition();
	std::cout << "CoM: " << CoM[0] << ", " << CoM[1] << ", " << CoM[2] << std::endl;
}

void Object::setOrientation(btVector3 axis, btScalar angle){
	btQuaternion obj_orient = btQuaternion(axis,angle);
	btTransform objTransform = body->getCenterOfMassTransform();
	objTransform.setRotation(obj_orient);
	body->setCenterOfMassTransform(objTransform);
}

btRigidBody* Object::createLargeMeshBody(std::string fileName,btVector4 color,
	btVector3 position, btQuaternion orientation, btScalar mass, float scaling_factor, GUIHelperInterface* m_guiHelper,
	btAlignedObjectArray<btCollisionShape*>* m_collisionShapes,btDiscreteDynamicsWorld* m_dynamicsWorld)
{

	b3BulletDefaultFileIO fileIO;
	GLInstanceGraphicsShape* glmesh = LoadMeshFromObj(fileName.c_str(), "", &fileIO);
	printf("[INFO] Obj loaded: Extracted %d verticed from obj file [%s]\n", glmesh->m_numvertices, fileName.c_str());

	const GLInstanceVertex& v = glmesh->m_vertices->at(0);
	btConvexHullShape* shape = new btConvexHullShape((const btScalar*)(&(v.xyzw[0])), glmesh->m_numvertices, sizeof(GLInstanceVertex));

	float scaling[4] = {1,1,1,1};

	btVector3 localScaling(scaling[0], scaling[1], scaling[2]);
	shape->setLocalScaling(localScaling);
	shape->optimizeConvexHull();
	// shape->initializePolyhedralFeatures();

	bool isDynamic = (mass != 0.f);
	btVector3 localInertia(0, 0, 0);
	if (isDynamic)
		shape->calculateLocalInertia(mass, localInertia);

	btTransform trans = createFrame(position);
	trans.setRotation(orientation);

	btRigidBody* body = createDynamicBody(mass,0.5,trans,shape,m_guiHelper,color);
	
	int shapeId = m_guiHelper->registerGraphicsShape(&glmesh->m_vertices->at(0).xyzw[0], 
                                                                    glmesh->m_numvertices, 
                                                                    &glmesh->m_indices->at(0), 
                                                                    glmesh->m_numIndices,
																	B3_GL_TRIANGLES, -1);

	btTransform bodyTransform = body->getCenterOfMassTransform();

    int renderInstance = m_guiHelper->registerGraphicsInstance(shapeId,bodyTransform.getOrigin(),bodyTransform.getRotation(),color,scaling);
	
	body->setUserIndex(renderInstance);
	
	
	return body;

}