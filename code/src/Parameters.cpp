
#include "Parameters.hpp"

// set default parameter values
void set_default(Parameters* param){

	// input arguments for simulator
	param->DEBUG = 0;			// enable debug mode
	param->TIME_STEP = 0.001;	// set time step
	param->NUM_STEP_INT = 100;	// set internal time step
	param->TIME_STOP = 1.;		// set simulation time
    param->PRINT = 0;			// set to PRINT=1 to kinematics/dynamics realtime, set to PRINT = 2 to print simulation time
	param->SAVE = 0;			// save results to csv file
	param->SAVE_VIDEO = 0;		// save video when running main_opengl.cpp

	// collision object type
	param->OBJECT = 0;			// 0: no object; 1: 

	// whisker configuration parameters
	param->WHISKER_NAMES = {"LA0", "RA0", "LC1", "RC1"}; // select whiskers to simulate
    param->BLOW = 1;				// increase whisker diameter for better visualization (will affect dynamics!!)
	param->NO_CURVATURE = 0;		// disable curvature
	param->NO_MASS = 0;				// disable mass of bodies
	param->NO_WHISKERS = 0;			// disable whiskers
	param->NUM_LINKS = 20;			// set number of links
	param->ROH_BASE = 1260.0;		// set densidy at whisker base
	param->ROH_TIP = 1690.0;		// set density at whisker tip
	param->E = 5.0;					// set young's modulus at whisker base
	param->ZETA = 0.32;				// set damping coefficient zeta at whisker base

	// whisking parameters
	param->ACTIVE = 0;				// enable active whisking mode
	param->AMP_BWD = 20;			// set whisking retraction in degrees
	param->AMP_FWD = 40;			// set whisking protraction in degrees
	param->WHISK_FREQ = 8.;			// set whisking frequency (Hz)

	// speed for moving object
	param->SPEED = 10;	

	// rat position/orientation parameters
	param->POSITION = {0,0,0}; 		// set position of rathead
	param->ORIENTATION = {0,1,0}; 	// set initial heading of rathead
	param->PITCH=0;					// set pitch of rathead (degrees)
	param->YAW=0; 					// set yaw of rathead (degrees)
	param->ROLL=0;					// set roll of rathead (degrees)

	// visualization parameters
	param->DIST=0.05;				// set camera distance
	param->CPITCH=-89;				// set camera pitch
	param->CYAW=0;					// set camera yaw

	// input/output file paths
	param->dir_out = "../output/test";
	param->file_video = "../output/video_test.mp4";
	param->file_env = "../data/3D_data/rat_habitat/drain_pipe.obj";


}

// create a vector with same value
std::vector<float> get_vector(int N, float value){
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

