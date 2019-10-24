#include "Whisker.hpp"

btVector4 color = btVector4(0,1,0,1);

Whisker::Whisker(btDiscreteDynamicsWorld* world, GUIHelperInterface* helper,btAlignedObjectArray<btCollisionShape*>* shapes, Parameters* params, btRigidBody* refbody, std::string w_name){
	// save parameters and global variables to whisker object
	m_collisionShapes = shapes;	// shape vector pointer
	m_dynamicsWorld = world;	// simulation world pointer
	m_guiHelper = helper;		// gui helper pointer
	parameters = params;			// whisker parameters
	origin = refbody; 				// reference body for base point position

    btScalar dt =parameters->TIME_STEP;
	config = load_config(w_name,parameters); // get parameters for whisker configuration
    

	int NUM_LINKS = parameters->NUM_LINKS;	// set number of links
	std::vector<int> all_zeros(NUM_LINKS, 0);
	collide = all_zeros;

	// calculate whisker geometry
    btScalar length = config.L*SCALE;
    btScalar link_length = length / btScalar(NUM_LINKS);
	btScalar radius_base = calc_base_radius(config.row,config.col,length); // base radius
	btScalar slope = calc_slope(length, radius_base, config.row, config.col);
    btScalar radius_tip = radius_base - length*slope;

	std::vector<btScalar> link_angles = config.link_angles;

    btScalar rho = parameters->ROH_BASE/pow(SCALE,3);
    btScalar rho_slope = ((parameters->ROH_TIP-parameters->ROH_BASE)/pow(SCALE,3)) / length;
    btScalar zeta = parameters->ZETA;
    btScalar E = parameters->E*1e9/SCALE;

	/// CREATE BASE POINT
	/// ====================================
	btTransform originTransform = origin->getCenterOfMassTransform();	

	btTransform basepointTransform = createFrame(config.base_pos);
	btCollisionShape* basepointShape = new btBoxShape(4*btVector3(radius_base,radius_base,radius_base));
	m_collisionShapes->push_back(basepointShape);
	
	basepoint = createDynamicBody(btScalar(100),originTransform*basepointTransform,basepointShape,m_guiHelper,color);
	m_dynamicsWorld->addRigidBody(basepoint,COL_BASE,baseCollidesWith);
	basepoint->setActivationState(DISABLE_DEACTIVATION);

	btTransform originFrame = createFrame();
    btTransform basepointFrame = createFrame();
	basePointConstraint = new btGeneric6DofConstraint(*origin, *basepoint, originFrame, basepointFrame,true);

	basePointConstraint->setLinearLowerLimit(config.base_pos);
	basePointConstraint->setLinearUpperLimit(config.base_pos);
	basePointConstraint->setAngularLowerLimit(btVector3(0,0,0));
	basePointConstraint->setAngularUpperLimit(btVector3(0,0,0));

	m_dynamicsWorld->addConstraint(basePointConstraint,true);
	basePointConstraint->setDbgDrawSize(btScalar(0.5f));

    // WHISKER BASE
	// =========================================================== 
	basepointTransform = basepoint->getCenterOfMassTransform();
	btCollisionShape* baseShape = createSphereShape(radius_base*5);
	m_collisionShapes->push_back(baseShape);
	
	base = createDynamicBody(btScalar(10),basepointTransform,baseShape,m_guiHelper,color);
	m_dynamicsWorld->addRigidBody(base,COL_BASE,baseCollidesWith);
	base->setActivationState(DISABLE_DEACTIVATION);

	basepointFrame = createFrame();
    btTransform baseFrame = createFrame();
	motorConstraint = new btGeneric6DofConstraint(*basepoint, *base, basepointFrame, baseFrame,true);

	btVector3 lowerLimit;
	btVector3 upperLimit;
	if(!config.side){ 
		lowerLimit = btVector3(-PI/6,-PI/6,-PI/6);
		upperLimit = btVector3(PI/3,PI/3,PI/3);
	}
	else{
		lowerLimit = btVector3(-PI/3,-PI/3,-PI/3);
		upperLimit = btVector3(PI/6,PI/6,PI/6);
	}
	
	motorConstraint->setLinearLowerLimit(btVector3(0,0,0));
	motorConstraint->setLinearUpperLimit(btVector3(0,0,0));
	motorConstraint->setAngularLowerLimit(lowerLimit);
	motorConstraint->setAngularUpperLimit(upperLimit);

	m_dynamicsWorld->addConstraint(motorConstraint,true);
	motorConstraint->setDbgDrawSize(btScalar(0.5f));

	// BUILD WHISKER
	// ===========================================================
	btScalar radius;
    btScalar radius_next = radius_base;
    btRigidBody* link_prev = base; 
    for(int i=0;i< NUM_LINKS;++i) {

        radius = radius_next;
        radius_next = radius - link_length * slope;
        btScalar angle = link_angles[i];

        // calculate parameters of the whisker
        rho = rho + rho_slope*link_length;
        btScalar mass = calc_mass(link_length, radius, radius_next, rho); // in kg
        if (parameters->NO_MASS){
            mass = 0.;
        }
        btScalar com = calc_com(link_length, radius, radius_next); // in cm
        btScalar vol = calc_volume(link_length, radius, radius_next); // in cm
        btScalar inertia = calc_inertia(radius); // in cm4
        btScalar stiffness = calc_stiffness(E,inertia,length);

        btScalar com_distal = calc_com((NUM_LINKS-i)*link_length, radius, radius_tip); // in cm
        btScalar mass_distal = calc_mass((NUM_LINKS-i), radius, radius_tip, rho); // in kg
        btScalar damping = calc_damping(stiffness, mass_distal, com_distal, zeta, dt);

        // generate shape for unit
        btTruncatedConeShape* linkShape = new btTruncatedConeShape(radius*parameters->BLOW, radius_next*parameters->BLOW, link_length,0);
        linkShape->setMargin(0.0001);
        m_collisionShapes->push_back(linkShape);

        // set position and rotation of current unit
        btTransform prevTransform = link_prev->getCenterOfMassTransform();
        
        btTransform totalTransform;
        if(i==0){
            btTransform rotTransform = rotZ(config.base_rot[0])*rotY(config.base_rot[1])*rotX(config.base_rot[2]);
            btTransform transTransform = createFrame(btVector3(link_length/2.f,0,0));
            totalTransform = prevTransform*rotTransform*transTransform;
        }
        else{
            btTransform linkTransform1 = createFrame(btVector3(link_length/2.f,0,0));
            btTransform linkTransform2 = createFrame(btVector3(0,0,0),btVector3(0,0,angle));
            btTransform linkTransform3 = createFrame(btVector3(link_length/2.f,0,0));
            totalTransform = prevTransform*linkTransform1*linkTransform2*linkTransform3;
        }

        // add unit to whisker and world
        btRigidBody* link = createDynamicBody(mass,totalTransform,linkShape,m_guiHelper,color);
        whisker.push_back(link);	
        
        if(config.side){ 
            m_dynamicsWorld->addRigidBody(link,COL_ARRAY_R,arrayRCollidesWith); 
        }
        else{
            m_dynamicsWorld->addRigidBody(link,COL_ARRAY_L,arrayLCollidesWith);
        }
        link->setUserPointer(&collide[i]);
        link->setActivationState(DISABLE_DEACTIVATION);

		
        if(i==0){
             // initialize transforms and set frames at end of frostum
            btTransform frameInCurr = createFrame(btVector3(-(link_length/2.f),0,0));
            btTransform frameInPrev = rotZ(config.base_rot[0])*rotY(config.base_rot[1])*rotX(config.base_rot[2]);
            baseConstraint = new btGeneric6DofConstraint(*link_prev, *link, frameInPrev, frameInCurr,true);
			
            baseConstraint->setLinearLowerLimit(btVector3(0,0,0));
            baseConstraint->setLinearUpperLimit(btVector3(0,0,0));
            baseConstraint->setAngularLowerLimit(btVector3(0,0,0));
            baseConstraint->setAngularUpperLimit(btVector3(0,0,0));
            
            m_dynamicsWorld->addConstraint(baseConstraint,true);
            baseConstraint->setDbgDrawSize(btScalar(0.5f));
        
            // enable feedback (mechanical response)
            baseConstraint->setJointFeedback(&baseFeedback);
        }
        else{
            btTransform frameInPrev = createFrame(btVector3(link_length/2.f,0,0),btVector3(0,0,0));
		    btTransform frameInCurr = createFrame(btVector3(-link_length/2.f,0,0),btVector3(0,0,0));
        
            // create link (between links) constraint
            btGeneric6DofSpringConstraint* spring = new btGeneric6DofSpringConstraint(*link_prev, *link, frameInPrev,frameInCurr,true);

            // set spring parameters of node
            // ----------------------------------------------------------		
            spring->setLinearLowerLimit(btVector3(0,0,0)); // lock the links
            spring->setLinearUpperLimit(btVector3(0,0,0));
            spring->setAngularLowerLimit(btVector3(0.,1.,1.)); // lock angles between links at x axis but free around y and z axis
            spring->setAngularUpperLimit(btVector3(0.,0.,0.));

            // add constraint to world
            m_dynamicsWorld->addConstraint(spring, true); // true -> collision between linked bodies disabled
            spring->setDbgDrawSize(btScalar(0.5f));

            spring->enableSpring(4,true);
            spring->setStiffness(4,stiffness);
            spring->setDamping(4,damping);
            spring->setEquilibriumPoint(4,0.);

            spring->enableSpring(5,true);
            spring->setStiffness(5,stiffness);
            spring->setDamping(5,damping);
            spring->setEquilibriumPoint(5,-angle);
        }
		
        link_prev = link;

	} 
	
}

void Whisker::whisk(btScalar dtheta){

	btScalar dphi = -dtheta * get_dphi(config.row-1);
	btScalar dzeta = dtheta * get_dzeta(config.row-1);
	
	if(config.side){ // right side
		dtheta = -dtheta;
		dphi = -dphi;
		dzeta = -dzeta;
	}

	btVector3 worldProtraction = (basepoint->getWorldTransform().getBasis()*btVector3(0,0,dtheta));
	btVector3 worldElevation = (basepoint->getWorldTransform().getBasis()*btVector3(0,dphi,0));
	btVector3 worldTorsion = (whisker[0]->getWorldTransform().getBasis()*btVector3(dzeta,0,0));
	btVector3 headvelocity = origin->getAngularVelocity();
	btVector3 totalVelocity = worldProtraction+worldElevation+worldTorsion + headvelocity;

	base->setAngularVelocity(totalVelocity);
	
}

std::vector<int> Whisker::getCollision(){
	std::vector<int> flags;

	for (int i=0; i<whisker.size(); i++){
		int f = collide[i];
		if(parameters->PRINT==1){
			std::cout << "c " << i << ": " << f << std::endl;
		}
		flags.push_back(f);
		collide[i]=0;
	}
	return flags;
}



// function to get torque at whisker base
btVector3 Whisker::getTorques(){

	btVector3 torques = baseConstraint->getJointFeedback()->m_appliedTorqueBodyA;
	if(parameters->PRINT==1){
		std::cout << "Mx : " << torques[0] << std::endl;
		std::cout << "My : " << torques[1] << std::endl;
		std::cout << "Mz : " << torques[2] << std::endl;
	}
	return torques;
}

// function to get forces at whisker base
btVector3 Whisker::getForces(){

	btVector3 forces = baseConstraint->getJointFeedback()->m_appliedForceBodyA;
	if(parameters->PRINT==1){
		std::cout << "Fx : " << forces[0] << std::endl;
		std::cout << "Fy : " << forces[1] << std::endl;
		std::cout << "Fz : " << forces[2] << std::endl;
	}
	return forces;
}


// function to obtain the world coordinates of each whisker unit
std::vector<btScalar> Whisker::getX(){

	std::vector<btScalar> trajectories;
	trajectories.push_back(base->getCenterOfMassTransform().getOrigin()[0]);

	// loop through links and get world coordinates of each
	for (int i=0; i<whisker.size(); i++){
		btScalar x = whisker[i]->getCenterOfMassTransform().getOrigin()[0];
		if(parameters->PRINT==1){
			std::cout << "x " << i << ": " << x << std::endl;
		}
		trajectories.push_back(x);
	}
	return trajectories;
}

// function to obtain the world coordinates of each whisker unit
std::vector<btScalar> Whisker::getY(){

	std::vector<btScalar> trajectories;
	trajectories.push_back(base->getCenterOfMassTransform().getOrigin()[1]);

	// loop through links and get world coordinates of each
	for (int i=0; i<whisker.size(); i++){
		btScalar y = whisker[i]->getCenterOfMassTransform().getOrigin()[1];
		if(parameters->PRINT==1){
			std::cout << "y " << i << ": " << y << std::endl;
		}
		trajectories.push_back(y);
	}
	return trajectories;
}

// function to obtain the world coordinates of each whisker unit
std::vector<btScalar> Whisker::getZ(){

	std::vector<btScalar> trajectories;
	trajectories.push_back(base->getCenterOfMassTransform().getOrigin()[2]);

	// loop through links and get world coordinates of each
	for (int i=0; i<whisker.size(); i++){
		btScalar z = whisker[i]->getCenterOfMassTransform().getOrigin()[2];
		if(parameters->PRINT==1){
			std::cout << "z " << i << ": " << z << std::endl;
		}
		trajectories.push_back(z);
	}
	return trajectories;
}


