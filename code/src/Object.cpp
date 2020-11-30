
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
		if(mass==0.){
			body = obj2StaticBody(filename,color,obj_trans,obj_orient,mass,scaling,helper,shapes,world);
			
		}
		else{
			body = obj2DynamicBody(filename,color,obj_trans,obj_orient,mass,scaling,helper,shapes,world);
		}
		shape = body->getCollisionShape();
		
	}
	else{
		std::cout << "No shape defined..." << std::endl;
		noShape = true;
		btTransform someTransform = createFrame();
		btSphereShape* sphere = new btSphereShape(0.5);
		shapes->push_back(sphere);
		body = createDynamicBody(0,someTransform,sphere,color);
		shape = body->getCollisionShape();
		
	}
	
	world->addRigidBody(body,collisionGroup,collisionMask);
		
	calcExtremes();

}
	
void Object::setPosition(btVector3 pos){
	btTransform objTransform = body->getCenterOfMassTransform();
	objTransform.setOrigin(pos);
	body->setCenterOfMassTransform(objTransform);
	btVector3 CoM = body->getCenterOfMassPosition();
	std::cout << "CoM: " << CoM[0] << ", " << CoM[1] << ", " << CoM[2] << std::endl;
	calcExtremes();
}

void Object::setOrientation(btVector3 axis, btScalar angle){
	btQuaternion obj_orient = btQuaternion(axis,angle);
	btTransform objTransform = body->getCenterOfMassTransform();
	objTransform.setRotation(obj_orient);
	body->setCenterOfMassTransform(objTransform);
	calcExtremes();
}

void Object::calcExtremes(){
	btVector3 maxs;
	btVector3 mins;
	btTransform transform = body->getCenterOfMassTransform();
	if(noShape){
		maxs = transform*btVector3(0.25,0.25,0.25);
		mins = transform*-maxs;
	}
	else{
		int num_point = hull->getNumPoints();
		
		float x = 0;
		float y = 0;
		float z = 0;

		for (int i=0;i<num_point;i++){
			btVector3 curr_point = transform*hull->getScaledPoint(i);

			for (int j=0;j<3;j++){
				if ((i==0) || ((curr_point[j]) > maxs[j]))
					maxs[j] = (curr_point[j]);
				if ((i==0) || ((curr_point[j]) < mins[j]))
					mins[j] = (curr_point[j]);
			}

		}
	}
	
	btVector3 CoM = body->getCenterOfMassPosition();
	xyz_max = maxs;
	xyz_min = mins;
}




// function to add objects (point clouds) as rigid bodies
btRigidBody* Object::obj2DynamicBody(std::string fileName,btVector4 color,
	btVector3 position, btQuaternion orientation, btScalar mass, float scaling_factor, GUIHelperInterface* m_guiHelper,
	btAlignedObjectArray<btCollisionShape*>* m_collisionShapes,btDiscreteDynamicsWorld* m_dynamicsWorld){

	
    GLInstanceGraphicsShape* glmesh = LoadMeshFromObj(fileName.c_str(), "");
    printf("[INFO] Dynamic Obj loaded: Extracted %d verticed from obj file [%s]\n", glmesh->m_numvertices, fileName.c_str());

    const GLInstanceVertex& v = glmesh->m_vertices->at(0);
    hull = new btConvexHullShape((const btScalar*)(&(v.xyzw[0])), glmesh->m_numvertices, sizeof(GLInstanceVertex));
	hull->setMargin(1);
	// m_collisionShapes->push_back(hull);
	
	// hull->optimizeConvexHull();
    int num_point = hull->getNumPoints();
	float s;
	if (scaling_factor != 0.){
		btVector3* all_point_list = hull->getUnscaledPoints();
		btVector3 min_vec, max_vec;
		for (int i=0;i<num_point;i++){
			btVector3 curr_point = all_point_list[i];
			for (int j=0;j<3;j++){
				if ((i==0) || (curr_point[j] < min_vec[j]))
					min_vec[j] = curr_point[j];
				if ((i==0) || (curr_point[j] > max_vec[j]))
					max_vec[j] = curr_point[j];
			}
		}
		float scale_new = scaling_factor/(max_vec - min_vec).norm();
		s = scale_new;
	} else {
		s = 1;
	}

	float scaling[4] = {s, s, s, 1};
    btVector3 localScaling(scaling[0],scaling[1],scaling[2]);
    hull->setLocalScaling(localScaling);

    btTransform trans = createFrame(position);
	trans.setRotation(orientation);


	btCollisionShape* shape_compound = LoadShapeFromObj(fileName.c_str(), "", btVector3(scaling[0], scaling[1],scaling[2]));
	shape_compound->setMargin(1);
	m_collisionShapes->push_back(shape_compound);
	btRigidBody* body = createDynamicBody(mass,trans, shape_compound,color);
	
    int shapeId = m_guiHelper->registerGraphicsShape(&glmesh->m_vertices->at(0).xyzw[0], 
                                                                    glmesh->m_numvertices, 
                                                                    &glmesh->m_indices->at(0), 
                                                                    glmesh->m_numIndices,
																	B3_GL_TRIANGLES, -1);
	// shape_compound->setUserIndex(shapeId);
	btTransform bodyTransform = body->getCenterOfMassTransform();
	
    int renderInstance = m_guiHelper->registerGraphicsInstance(shapeId,bodyTransform.getOrigin(),bodyTransform.getRotation(),color,scaling);
	body->setUserIndex(renderInstance);

	
    return body;
}


// function to add objects (point clouds) as rigid bodies
btRigidBody* Object::obj2StaticBody(std::string fileName,btVector4 color,
	btVector3 position, btQuaternion orientation, btScalar mass, float scaling_factor, GUIHelperInterface* m_guiHelper,
	btAlignedObjectArray<btCollisionShape*>* m_collisionShapes,btDiscreteDynamicsWorld* m_dynamicsWorld){

	
    GLInstanceGraphicsShape* glmesh = LoadMeshFromObj(fileName.c_str(), "");
    printf("[INFO] Static Obj loaded: Extracted %d verticed from obj file [%s]\n", glmesh->m_numvertices, fileName.c_str());

    const GLInstanceVertex& v = glmesh->m_vertices->at(0);
    hull = new btConvexHullShape((const btScalar*)(&(v.xyzw[0])), glmesh->m_numvertices, sizeof(GLInstanceVertex));
	hull->setMargin(1);
	// m_collisionShapes->push_back(hull);
	
    //shape->optimizeConvexHull();

    int num_point = hull->getNumPoints();

	float s;
	if (scaling_factor != 0.){
		btVector3* all_point_list = hull->getUnscaledPoints();
		btVector3 min_vec, max_vec;
		for (int i=0;i<num_point;i++){
			btVector3 curr_point = all_point_list[i];
			for (int j=0;j<3;j++){
				if ((i==0) || (curr_point[j] < min_vec[j]))
					min_vec[j] = curr_point[j];
				if ((i==0) || (curr_point[j] > max_vec[j]))
					max_vec[j] = curr_point[j];
			}
		}
		float scale_new = scaling_factor/(max_vec - min_vec).norm();
		s = scale_new;
	} else {
		s = 1;
	}

	float scaling[4] = {s, s, s, 1};
    btVector3 localScaling(scaling[0],scaling[1],scaling[2]);
    hull->setLocalScaling(localScaling);

    btTransform trans = createFrame(position);
	trans.setRotation(orientation);

	btTriangleMesh* meshInterface = new btTriangleMesh();
    for (int i=0;i<num_point/3;i++)
       meshInterface->addTriangle(hull->getScaledPoint(i*3), hull->getScaledPoint(i*3+1), hull->getScaledPoint(i*3+2));
    
	btBvhTriangleMeshShape* trimesh = new btBvhTriangleMeshShape(meshInterface,true,true);
	trimesh->setMargin(1);
	m_collisionShapes->push_back(trimesh);

	// btCollisionShape* trimesh = new btConvexTriangleMeshShape(meshInterface);
	// trimesh->setMargin(1);
	// m_collisionShapes->push_back(trimesh);
	
	btRigidBody* body = createDynamicBody(0,trans,trimesh,color);

    int shapeId = m_guiHelper->registerGraphicsShape(&glmesh->m_vertices->at(0).xyzw[0], 
                                                                    glmesh->m_numvertices, 
                                                                    &glmesh->m_indices->at(0), 
                                                                    glmesh->m_numIndices,
																	B3_GL_TRIANGLES, -1);
	// shape->setUserIndex(shapeId);

	btTransform bodyTransform = body->getCenterOfMassTransform();

	
    // int renderInstance = m_guiHelper->registerGraphicsInstance(shapeId,bodyTransform.getOrigin(),bodyTransform.getRotation(),color,scaling);
	
	// body->setUserIndex(renderInstance);

	
    return body;
}



