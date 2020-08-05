#include "Whisker.h"

Whisker::Whisker(btDiscreteDynamicsWorld* world, GUIHelperInterface* helper,btAlignedObjectArray<btCollisionShape*>* shapes, std::string w_name, Parameters* parameters){
	color = btVector4(0.1, 0.1, 0.1, 1);
	// save parameters and global variables to whisker object
	m_collisionShapes = shapes;	// shape vector pointer
	m_dynamicsWorld = world;	// simulation world pointer
	m_guiHelper = helper;		// gui helper pointer

	friction = 0.5;
	m_angle = 0.;		// initialize protraction angle
	m_time = 0;			// initialize time
	ACTIVE = parameters->ACTIVE;
	NO_MASS = parameters->NO_MASS;
	BLOW = parameters->BLOW;
	PRINT = parameters->PRINT;
	dt = parameters->TIME_STEP;
	NUM_LINKS = parameters->NUM_LINKS;
	NUM_JOINTS = NUM_LINKS - 1;

	// initialize collide array
	std::vector<int> all_zeros(NUM_LINKS, 0);
	collide = all_zeros;
	dphi = {0.398f,0.591f,0.578f,0.393f,0.217f};
	dzeta = {-0.9f,-0.284f,0.243f,0.449f, 0.744f};

	//Whisker specific configuration parameters					// unit:
	whisker_config config = get_config(w_name, parameters);
	idx = config.index;
	side = config.side;											// -
	row = config.row;											// -
	col = config.col;											// -
	length = config.L;											// mm
	link_length = length/btScalar(NUM_LINKS);					// mm
	radius_base = calc_base_radius(row, col, length); 			// mm
	radius_slope = calc_slope(length, radius_base, row, col);	// -
	radius_tip = radius_base - length*radius_slope;				// mm
	link_angles = config.link_angles;							// -
	base_pos = config.base_pos;									// mm
	base_rot = config.base_rot;									// -

	//Whisker universal configuration parameters
	rho = parameters->RHO_BASE/pow(SCALE,3);	// rho: density, SCALE: convert kg/m3 to kg/mm3
	rho_slope = ((parameters->RHO_TIP-parameters->RHO_BASE)/length /pow(SCALE,3)) ;
	zeta = parameters->ZETA;				// zeta: damping ratio
	E = parameters->E/SCALE;			// E: Young's modulus, SCALE: convert kg/m/s2 to kg/mm/s2 
}


void Whisker::buildWhisker(btRigidBody* head, btTransform head2origin){
	/// CREATE BASE POINT
	/// This is a box shape that is only translated from origin to basepoint location.
	/// It's body frame is global axis-aligned.

	// originTransform is the mean location of the whisker array
	btTransform originTransform = head->getCenterOfMassTransform()*head2origin;
	// basepointTransform is the location of the basepoints
	btTransform basepointTransform = originTransform*createFrame(base_pos);

	// create shape for base point
	btCollisionShape* basepointShape = new btBoxShape(4*btVector3(radius_base, radius_base, radius_base));
	m_collisionShapes->push_back(basepointShape);
	basepoint = createDynamicBody(btScalar(100), friction, basepointTransform, basepointShape, m_guiHelper, color);
	// add basepoint rigid body to the world
	m_dynamicsWorld->addRigidBody(basepoint,COL_BASE,baseCollidesWith);
	basepoint->setActivationState(DISABLE_DEACTIVATION);

	btVector3 head2basepoint = head2origin.getOrigin() + base_pos;
	btTransform inFrameA = createFrame();
    btTransform inFrameB = createFrame();
	basePointConstraint = new btGeneric6DofConstraint(*head, *basepoint, inFrameA, inFrameB, true);
	basePointConstraint->setLinearLowerLimit(head2basepoint);
	basePointConstraint->setLinearUpperLimit(head2basepoint);
	basePointConstraint->setAngularLowerLimit(btVector3(0,0,0));
	basePointConstraint->setAngularUpperLimit(btVector3(0,0,0));

	m_dynamicsWorld->addConstraint(basePointConstraint,true);
	basePointConstraint->setDbgDrawSize(btScalar(0.5f));

    /// WHISKER BASE
	/// This is a sphere shape that has exactly the same transform as the basepoint (box).
	/// In non-whisking mode, it's body frame is axis-aligned. In whisking mode, this node
	/// serves as a moving node that receives angular velocity parameter from Knutsen.

	// Now, basepointTransform become the absolute transform of the basepoint
	btTransform baseTransform = basepoint->getCenterOfMassTransform();

	// create shape for whisker base
	btCollisionShape* baseShape = new btSphereShape(radius_base*5.f);
	m_collisionShapes->push_back(baseShape);
	base = createDynamicBody(btScalar(10),friction,baseTransform,baseShape,m_guiHelper,color);
	// add whisker base rigid body to the world
	m_dynamicsWorld->addRigidBody(base,COL_BASE,baseCollidesWith);
	base->setActivationState(DISABLE_DEACTIVATION);

	// add constraint between basepoint and whisker base. (motor constraint)
	motorConstraint = new btGeneric6DofConstraint(*basepoint, *base, inFrameA, inFrameB, true);

	// set angular limit of this motor constraint, and add it to the world
	// this constraint is relative to the basepoint
	btVector3 lowerLimit;
	btVector3 upperLimit;
	// if in ACTIVE mode, use dynamic range
	if (ACTIVE) {	
		if(!side){ 
			lowerLimit = btVector3(-PI/6.f,-PI/6.f,-PI/6.f);
			upperLimit = btVector3(PI/3.f,PI/3.f,PI/3.f);
		}
		else{
			lowerLimit = btVector3(-PI/3.f,-PI/3.f,-PI/3.f);
			upperLimit = btVector3(PI/6.f,PI/6.f,PI/6.f);
		}
	// if not in ACTIVE mode, use static range
	} else {
		if(!side){ // dynamic range
			lowerLimit = btVector3(0, 0, 0);
			upperLimit = btVector3(0, 0, 0);
		}
		else{
			lowerLimit = btVector3(0, 0, 0);
			upperLimit = btVector3(0, 0, 0);
		}
	}
	motorConstraint->setLinearLowerLimit(btVector3(0,0,0));
	motorConstraint->setLinearUpperLimit(btVector3(0,0,0));
	motorConstraint->setAngularLowerLimit(lowerLimit);
	motorConstraint->setAngularUpperLimit(upperLimit);

	m_dynamicsWorld->addConstraint(motorConstraint,true);
	motorConstraint->setDbgDrawSize(btScalar(0.5f));


	// BUILD WHISKER
	btScalar radius;
    btScalar radius_next = radius_base;
    btRigidBody* link_prev = base; 
    for(int i=0;i< NUM_LINKS;++i) {

        radius = radius_next;
        radius_next = radius - link_length * radius_slope;
        btScalar angle = link_angles[i];

        // calculate parameters of the whisker
        rho = rho + rho_slope*link_length;
        btScalar mass = calc_mass(link_length, radius, radius_next, rho); // in kg
        if (NO_MASS){
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
        btTruncatedConeShape* linkShape = new btTruncatedConeShape(radius*BLOW, radius_next*BLOW, link_length, 0);
        linkShape->setMargin(0.0001);
        m_collisionShapes->push_back(linkShape);

        // set position and rotation of current unit
        btTransform prevTransform = link_prev->getCenterOfMassTransform();
        
        btTransform totalTransform;
        if(i==0){
            btTransform rotTransform = rotZ(base_rot[0])*rotY(base_rot[1])*rotX(base_rot[2]);
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
        btRigidBody* link = createDynamicBody(mass,friction,totalTransform,linkShape,m_guiHelper,color,0);
        whisker.push_back(link);	
        
        if(side){ 
            m_dynamicsWorld->addRigidBody(link,COL_ARRAY_R,arrayRCollidesWith); 
        }
        else{
            m_dynamicsWorld->addRigidBody(link,COL_ARRAY_L,arrayLCollidesWith);
        }
        link->setUserPointer(&collide[i]);
        link->setActivationState(DISABLE_DEACTIVATION);

		
        if(i==0){
             // initialize transforms and set frames at end of frustum
            btTransform frameInCurr = createFrame(btVector3(-(link_length/2.f),0,0));
			btTransform  frameInPrev = rotZ(base_rot[0])*rotY(base_rot[1])*rotX(base_rot[2]);
            baseConstraint = new btGeneric6DofSpringConstraint(*link_prev, *link, frameInPrev, frameInCurr,true);
			
            baseConstraint->setLinearLowerLimit(btVector3(0,0,0));
            baseConstraint->setLinearUpperLimit(btVector3(0,0,0));
            baseConstraint->setAngularLowerLimit(btVector3(0,0,0));
            baseConstraint->setAngularUpperLimit(btVector3(0,0,0));
            
            m_dynamicsWorld->addConstraint(baseConstraint,true);
            baseConstraint->setDbgDrawSize(btScalar(0.5f));
			
			baseConstraint->enableSpring(4,true);
			baseConstraint->setStiffness(4,1.25);
			baseConstraint->setDamping(4,0.2);
			baseConstraint->setEquilibriumPoint(4,0);

			baseConstraint->enableSpring(5,true);
			baseConstraint->setStiffness(5,1.25);
			baseConstraint->setDamping(5,0.2);
			baseConstraint->setEquilibriumPoint(5,0);

			// enable feedback of base constraint to read out mechanics
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

void Whisker::whisk(btScalar a_vel_0, btScalar a_vel_1, btScalar a_vel_2, btVector3 headAngularVelocity){
	// localAngularVelocity is the velocity relative to the rat head
	btVector3 localAngularVelocity = btVector3(a_vel_0, a_vel_1, a_vel_2);
	btVector3 globalAngularVelocity = localAngularVelocity + headAngularVelocity;
	base->setAngularVelocity(globalAngularVelocity);	
}

btRigidBody* Whisker::get_unit(int idx) const{
	return whisker[idx];
}

btRigidBody* Whisker::get_base() const{
	return base;
}

std::vector<int> Whisker::getCollision(){
	std::vector<int> flags;

	for (int i=0; i<whisker.size(); i++){
		int f = collide[i];
		if(PRINT==1){
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
	if(PRINT==1){
		std::cout << "Mx : " << torques[0] << std::endl;
		std::cout << "My : " << torques[1] << std::endl;
		std::cout << "Mz : " << torques[2] << std::endl;
	}
	return torques;
}

// function to get forces at whisker base
btVector3 Whisker::getForces(){

	btVector3 forces = baseConstraint->getJointFeedback()->m_appliedForceBodyA;
	if(PRINT==1){
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
		if(PRINT==1){
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
		if(PRINT==1){
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
		if(PRINT==1){
			std::cout << "z " << i << ": " << z << std::endl;
		}
		trajectories.push_back(z);
	}
	return trajectories;
}

btVector3 Whisker::getPosition(int linknr){
	return whisker[linknr]->getCenterOfMassPosition();
}

// function to get zeta angle of whisker motion (depends on row)
float Whisker::get_dzeta(int index) const{

	return dzeta[index];
}

// function to get phi angle of whisker motion (depends on row)
float Whisker::get_dphi(int index) const{

	return dphi[index];
}


btScalar Whisker::calc_base_radius(int row, int col, btScalar S) const{  
	// unit: mm
    btScalar dBase = 0.041 + 0.002*S + 0.011*row - 0.0039*col;
    return dBase/2;
}

btScalar Whisker::calc_slope(btScalar S, btScalar rbase, int row, int col) const{
	// unit: -
    btScalar slope = 0.0012 + 0.00017*row - 0.000066*col + 0.00011*col*col;
    btScalar rtip = (rbase - slope*S)/2.;
	// btScalar rtip = (rbase - slope*S);

    if(rtip <= 0.0015){
        rtip = 0.0015;
    }

    slope = (rbase-rtip)/S;
    return slope;
}


btScalar Whisker::calc_mass(btScalar length, btScalar R, btScalar r, btScalar rho) const{
        
    btScalar m = rho*(PI*length/3)*(pow(R,2) + R*r + pow(r,2));    
    return m;
}

btScalar Whisker::calc_inertia(btScalar radius) const{
	
	btScalar I = 0.25*PI*pow(radius,4);		
    return I;
}

btScalar Whisker::calc_com(btScalar length, btScalar R, btScalar r) const{
    btScalar com = length/4*(pow(R,2) + 2*R*r + 3*pow(r,2))/(pow(R,2) + R*r + pow(r,2));
    return com;
}

btScalar Whisker::calc_volume(btScalar length, btScalar R, btScalar r) const{
    btScalar vol = PI*length/3*(pow(R,2) + R*r + pow(r,2));
    return vol;
}

btScalar Whisker::calc_stiffness(btScalar E, btScalar I, btScalar length) const{

    btScalar k = E*I/length;
    return k;
}


btScalar Whisker::calc_damping(btScalar k, btScalar M, btScalar CoM, btScalar zeta, btScalar dt) const{
    
    btScalar actual_damp = zeta * 2 * CoM * sqrt(k * M);
    btScalar offset = CoM*CoM*M/dt;
    btScalar c = dt/(offset+actual_damp);   
    return c;
}

// function to obtain parameters for specific whisker
whisker_config Whisker::get_config(std::string wname,Parameters* parameters){
    
    boost::filesystem::path full_path(boost::filesystem::current_path());
    // read in parameter file
    std::vector<std::string> whisker_names;
    std::vector<std::vector<int>> whisker_pos;
    std::vector<std::vector<float>> whisker_geom;
    std::vector<std::vector<float>> whisker_angles;
    std::vector<std::vector<float>> whisker_bp_coor;
    std::vector<std::vector<float>> whisker_bp_angles;
	
    read_csv_string("../data/param_name.csv",whisker_names);
    read_csv_int("../data/param_side_row_col.csv",whisker_pos);
    read_csv_float("../data/param_s_a.csv",whisker_geom);
    read_csv_float("../data/param_angles.csv",whisker_angles);
    read_csv_float("../data/param_bp_pos.csv",whisker_bp_coor);
    read_csv_float(parameters->dir_whisking_init_angle,whisker_bp_angles);
    
	// find parameters for specific whiskers from "data"
	whisker_config wc;
	int wfound = 0;
    for(int i=0;i<whisker_names.size();i++){
		
        if(!wname.compare(whisker_names[i])){
			wc.index = i;
            wc.id = wname;
            wc.side = whisker_pos[i][0];
            wc.row = whisker_pos[i][1];
            wc.col = whisker_pos[i][2];
			wc.L = whisker_geom[i][0]; 			// unit: mm
            wc.link_angles = whisker_angles[i];
            wc.base_pos = btVector3(whisker_bp_coor[i][0],whisker_bp_coor[i][1],whisker_bp_coor[i][2]);		// unit: mm
            wc.base_rot = btVector3(whisker_bp_angles[i][0]-PI/2,-whisker_bp_angles[i][1],whisker_bp_angles[i][2]+PI/2);
			wfound = 1;
            break;
        }
		
    }
	if (!wfound){
		std::cout << "\n======== ABORT SIMULATION ========" << std::endl;
		std::cout << "--> " << wname << " is an invalid whisker ID.\n" << std::endl;
		exit (EXIT_FAILURE);
	}
    return wc;
    
}