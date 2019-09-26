
#ifndef PARAMETERS_HPP
#define PARAMETERS_HPP

#define PI 3.1415927

#define LINK_THETA_MAX PI/4
#define LINK_PHI_MAX PI/4
#define LINK_ZETA_MAX PI/360

#include <string>
#include <vector>
#include "LinearMath/btVector3.h"

struct Parameters{
	
	int DEBUG;
	float TIME_STEP;
	int NUM_STEP_INT;
	float TIME_STOP;
	int PRINT;
	int SAVE;
	int SAVE_VIDEO;
	int OBJECT;
	
    std::vector<std::string> WHISKER_NAMES;
    float BLOW;
	int NO_CURVATURE;
	int NO_MASS;
	int NO_WHISKERS;
	int NUM_UNITS;
	int NUM_LINKS;
	float ROH_BASE;
	float ROH_TIP;
	float E_BASE;
	float E_TIP;
	float ZETA_BASE;
	float ZETA_TIP;
	std::vector<float> POSITION;
	std::vector<float> ORIENTATION;
	float PITCH;
	float YAW;
	float ROLL;

	float DIST;
	float CPITCH;
	float CYAW;

	int ACTIVE;
	float AMP_BWD;
	float AMP_FWD;
	float WHISK_FREQ;
	float SPEED;
	
	std::string dir_out;
	std::string file_video;
	std::string file_env;
};

void set_default(Parameters* param);
std::vector<float> get_vector(int N, float value);
std::vector<float> stringToFloatVect(std::vector<std::string> vect_string);

#endif