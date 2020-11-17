
#include "Parameters.h"

// set default parameter values
Parameters::Parameters(){
	// input arguments for simulator
	DEBUG = 0;			// enable debug mode
	TIME_STEP = 0.001;	// set time step, this is related to output video's FPS
	NUM_STEP_INT = 100;	// set internal time step
	TIME_STOP = 1.5;		// set overall simulation time
    PRINT = 2;			// set to PRINT=1 to kinematics/dynamics realtime, set to PRINT = 2 to print simulation time
	SAVE = 1;			// save results to csv file
	SAVE_VIDEO = 1;		// save video when running main_opengl.cpp

	// collision object type
	OBJECT = 0;			// 0: nothing
						// 1: peg
						// 2: wall
						// 3: create object from 3D scan

	SCALING = 1;				
	// parameters for peg (OBJECT = 1)
	PEG_LOC = btVector3(20, 25, 0); //8x passive stimulation
	// PEG_LOC = btVector3(10, 35, 0);
	PEG_SPEED = 10;	

	// specify whisker configuration parameters
	MODEL_TYPE = 0; // Selects model type: 0 => average rat whisker array; 1 => model rat whisker array from Belli et al. 2018
	WHISKER_NAMES = {"RC0", "RC1", "RB1", "RD1", "LC0", "LC1", "LB1", "LD1"}; // select whiskers to simulate
	// WHISKER_NAMES = {"RA0", "RA1", "RA2", "RA3", "RA4", "RB0", "RB1", "RB2", "RB3", "RB4",
	// 				 "RC0", "RC1", "RC2", "RC3", "RC4", "RC5", "RC6", 
	// 				 "RD0", "RD1", "RD2", "RD3", "RD4", "RD5", "RD6", 
	// 				 "RE1", "RE2", "RE3", "RE4", "RE5", "RE6"};
    	
	BLOW = 1;				// increase whisker diameter for better visualization (will affect dynamics!!)
	NO_CURVATURE = 0;		// disable curvature
	NO_MASS = 0;			// disable mass of bodies
	NO_WHISKERS = 0;		// disable whiskers
	NUM_LINKS = 20;			// set number of links
	RHO_BASE = 1260.0;		// set density at whisker base
	RHO_TIP = 1690.0;		// set density at whisker tip
	E = 5e9;				// set young's modulus (GPa) at whisker base
	ZETA = 0.32;			// set damping coefficient zeta at whisker base

	// enable/disable whisking mode for added whiskers
	// Note: the whisking trajectory is pre-specified by user.
	ACTIVE = 1;				
	dir_whisking_init_angle = ACTIVE?"../data/whisking_init_angle_sample.csv":"../data/param_bp_angles.csv";
	dir_whisking_angle = "../data/whisking_trajectory_sample.csv";

	// enable/disable exploring mode for rat head
	// Note: the head trajectory is 
	EXPLORING = 0;
	dir_rathead = "../data/object/NewRatHead.obj";
	dir_rathead_trajectory = "../data/rathead_trajectory_sample.csv";


	// rat position/orientation parameters
	RATHEAD_LOC = {0,0,0}; 			// set position of rathead
	RATHEAD_ORIENT = {0,0,0}; 		// set initial heading of rathead
	RATHEAD_ANGVEL = {0,0,0};		// set angular head velocity

	// camera parameters for visualization
	CPOS = btVector3(0, 26, 20);	// set camera pos relative to rathead
	CDIST=50;						// set camera distance
	CPITCH=-89;						// set camera pitch
	CYAW=0;							// set camera yaw

	// input/output file paths
	dir_out = "../output/test";
	file_video = "../output/video_test.mp4";
	file_env = "../data/environment/env_1.obj";	

}

// create a vector with same value
std::vector<float> get_vector(float value, int N){
	std::vector<float> vect;
	for(int i=0; i<N; i++){
		vect.push_back(value);
	}
	return vect;
}

// convert string to float vector - not used I think
std::vector<float> stringToFloatVect(std::vector<std::string> vect_string){
	std::string::size_type sz;
	std::vector<float> vect_float;
	for(int i=0; i<vect_string.size(); i++){
		vect_float.push_back(std::stof(vect_string[i],&sz));
	}
	return vect_float;
}

