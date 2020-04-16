/*

This code is based on code published by
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2015 Google Inc. http://bulletphysics.org

*/


#include "Simulation.hpp"

btVector4 BLUE = btVector4(0.,0.,1.0,1);
btVector4 RED = btVector4(1.,0.,0.0,1);
btVector4 GREEN = btVector4(0.,1.,0.0,1);
btVector4 GREY = btVector4(0.,0.,0.0,0.5);
btVector4 YELLOW = btVector4(1.,1.,0.0,1);
btVector4 ORANGE = btVector4(1.,0.647,0.0,1);

void Simulation::stepSimulation(){
	auto start = std::chrono::high_resolution_clock::now(); 
	m_time += parameters->TIME_STEP; // increase time
	
	// run simulation as long as stop time not exceeded
	if(parameters->TIME_STOP==0 || m_time < parameters->TIME_STOP){
		

		// define headtransform
		btTransform headTrans = createFrame();

		// define head velocity (linear, angular)
		btVector3 headLinearVelocity = btVector3(0,0,0);
		btVector3 headAngularVelocity = btVector3(0,0,0);

		// moving object 1
		if(parameters->OBJECT==1){
			peg->setLinearVelocity(vec*parameters->PEG_SPEED);
		}

		btScalar dtheta = 0;
		// move array if in ACTIVE mode
		if(parameters->ACTIVE && !parameters->NO_WHISKERS){

			btScalar angle_fwd = parameters->AMP_FWD*PI/180;
			btScalar angle_bwd = parameters->AMP_BWD*PI/180;
			btScalar w = 2*PI*parameters->WHISK_FREQ;
			btScalar t = m_time;
			btScalar dt = parameters->TIME_STEP;

			btScalar amp = (angle_fwd + angle_bwd)/2;
			btScalar shift = (angle_fwd - angle_bwd)/2;
			btScalar phase = asin(shift/amp);
			btScalar prevtheta = (amp*sin(w*(t-dt) + phase)-sin(phase));
			btScalar theta = (amp*sin(w*t + phase)-sin(phase));

			dtheta = (theta-prevtheta)/dt;
		}
		
		scabbers->setVelocity(headLinearVelocity,headAngularVelocity,dtheta,parameters->ACTIVE); // set active flag = 1 for velocity

		// step simulation
		m_dynamicsWorld->stepSimulation(parameters->TIME_STEP,parameters->NUM_STEP_INT,parameters->TIME_STEP/parameters->NUM_STEP_INT);

		// register collisions
		scabbers->detect_collision(m_dynamicsWorld);

		// save simulation output
		if(!parameters->NO_WHISKERS && parameters->SAVE){
			scabbers->dump_M(data_dump);
			scabbers->dump_F(data_dump);
			scabbers->dump_Q(data_dump);
		}
		// draw debug if enabled
	    if(parameters->DEBUG){
	    	m_dynamicsWorld->debugDrawWorld();
	    }

	    // set exit flag to zero
	    exitSim = 0;
	}
	else{
		// timeout -> set exit flg
		exitSim = 1;
	}
	
	auto stop = std::chrono::high_resolution_clock::now(); 
	auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start);
	m_time_elapsed += duration.count()/1000.f;
	auto factor = m_time_elapsed / m_time;
	auto time_remaining = (int)((parameters->TIME_STOP - m_time) * (factor));
	if(parameters->PRINT==2){
		std::cout << "\rCompleted: " << std::setprecision(2) << m_time/parameters->TIME_STOP*100 << " %\tTime remaining: " << std::setprecision(4) << time_remaining/60 << " min " << std::setprecision(4) << (time_remaining % 60) << " s\n" << std::flush;
	}
    
}

void Simulation::initPhysics()
{	
	data_dump->init(parameters->WHISKER_NAMES);

	// set visual axis
	m_guiHelper->setUpAxis(2);

	// create empty dynamics world[0]
	m_collisionConfiguration = new btDefaultCollisionConfiguration(); 
    m_dispatcher = new	btCollisionDispatcher(m_collisionConfiguration); 

    // broadphase algorithm
    m_broadphase = new btDbvtBroadphase();

	// select solver
	std::cout << "Using btSequentialImpulseConstraintSolver..." << std::endl;
	m_solver = new btSequentialImpulseConstraintSolver();

	m_dynamicsWorld = new btDiscreteDynamicsWorld(m_dispatcher,m_broadphase,m_solver,m_collisionConfiguration);			

	// set number of iterations
	m_dynamicsWorld->getSolverInfo().m_numIterations = 20;
	m_dynamicsWorld->getSolverInfo().m_solverMode = SOLVER_SIMD |
                        SOLVER_USE_WARMSTARTING |
                        SOLVER_RANDMIZE_ORDER |
                        0;
	m_dynamicsWorld->getSolverInfo().m_splitImpulse = true;
	m_dynamicsWorld->getSolverInfo().m_erp = 0.8f;

	
	// set gravity
	m_dynamicsWorld->setGravity(btVector3(0,0,0));

    // create debug drawer
	m_guiHelper->createPhysicsDebugDrawer(m_dynamicsWorld);

	if (m_dynamicsWorld->getDebugDrawer()){
		if(parameters->DEBUG==1){
			std::cout << "DEBUG option 1: wireframes." << std::endl;
			m_dynamicsWorld->getDebugDrawer()->setDebugMode(btIDebugDraw::DBG_DrawWireframe);
		}
		else if(parameters->DEBUG==2){
			std::cout << "DEBUG option 2: constraints." << std::endl;
			m_dynamicsWorld->getDebugDrawer()->setDebugMode(btIDebugDraw::DBG_DrawConstraints);
		}
		else if(parameters->DEBUG==3){
			std::cout << "DEBUG option 3: wireframes & constraints." << std::endl;
			m_dynamicsWorld->getDebugDrawer()->setDebugMode(btIDebugDraw::DBG_DrawWireframe+btIDebugDraw::DBG_DrawConstraintLimits);
		}
		else if(parameters->DEBUG==4){
			std::cout << "DEBUG option 4: AAbb." << std::endl;
			m_dynamicsWorld->getDebugDrawer()->setDebugMode(btIDebugDraw::DBG_DrawAabb);
		}
		else if(parameters->DEBUG==5){
			std::cout << "DEBUG option 5: Frammes." << std::endl;
			m_dynamicsWorld->getDebugDrawer()->setDebugMode(btIDebugDraw::DBG_DrawFrames);
		}
		else if(parameters->DEBUG==6){
			std::cout << "DEBUG option 6: Only collision" << std::endl;
			// m_dynamicsWorld->getDebugDrawer()->setDebugMode(btIDebugDraw::DBG_DrawFrames);
		}
		else{
			std::cout << "No DEBUG." << std::endl;
			m_dynamicsWorld->getDebugDrawer()->setDebugMode(btIDebugDraw::DBG_NoDebug);
		}
	}

	if(parameters->OBJECT==3){
		// set rat initial position
		parameters->POSITION = {-70,-30,0};
		parameters->ORIENTATION = {1.,1,1};
	}

	// add rat to world
	scabbers = new Rat(m_guiHelper,m_dynamicsWorld, &m_collisionShapes, parameters);
	btVector3 pos = scabbers->get_position();
	
	// create object to collide with
	// peg
	if(parameters->OBJECT==1){
		btVector3 nose = btVector3(0.,30,0);
		vec = btVector3(15,-30,-30);
		vec = vec.normalized();
		btVector3 peg_init = btVector3(nose[0]+7,nose[1]+20,nose[2]); // placing peg rostral from array
		btCollisionShape* pegShape = new btCylinderShapeZ(btVector3(0.5,0.5,80));
		pegShape->setMargin(0.0001);
		m_collisionShapes.push_back(pegShape);
		btTransform trans = createFrame(peg_init,btVector3(PI/4,0,PI/12));
		peg = createDynamicBody(1,trans, pegShape, m_guiHelper,  BLUE);
		m_dynamicsWorld->addRigidBody(peg,COL_ENV,envCollidesWith);
		peg->setActivationState(DISABLE_DEACTIVATION);
		
	}
	// create object to collide with wall
	else if(parameters->OBJECT==2){
		btCollisionShape* wallShape = new btBoxShape(btVector3(5,200,60));
		wallShape->setMargin(0.0001);
		m_collisionShapes.push_back(wallShape);
		btTransform trans = createFrame(btVector3(45,0,0),btVector3(0,0,0));
		wall = createDynamicBody(0, trans, wallShape, m_guiHelper,  BLUE);
		m_dynamicsWorld->addRigidBody(wall,COL_ENV,envCollidesWith);
	}
	// create object from 3D scan
	else if(parameters->OBJECT==3){

		// add environment to world
		btVector4 envColor = btVector4(0.6,0.6,0.6,1);
		env = new Object(m_guiHelper,m_dynamicsWorld, &m_collisionShapes,parameters->file_env,envColor,btScalar(SCALE),btScalar(0),COL_ENV,envCollidesWith);

	}
	
	// generate graphics
	m_guiHelper->autogenerateGraphicsObjects(m_dynamicsWorld);

	// set camera position to rat head
	targetPos[0] = pos[0];
	targetPos[1] = pos[1]+3.;
	targetPos[2] = pos[2];
	dist = parameters->DIST*SCALE;
	pitch = parameters->CPITCH;
	yaw = parameters->CYAW;
	resetCamera();

	// initialize time/step tracker
	m_time_elapsed = 0;
	m_time = 0;
	
	std::cout << "\n\nStart simulation..." << std::endl;
	std::cout << "\n====================================================\n" << std::endl;
}

output* Simulation::get_results(){
	return data_dump;
}
