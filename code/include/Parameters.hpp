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
*/

#ifndef PARAMETERS_HPP
#define PARAMETERS_HPP

#define PI 3.1415927

#define LINK_THETA_MAX PI/4
#define LINK_PHI_MAX PI/4
#define LINK_ZETA_MAX PI/360

#include <string>
#include <vector>
#include "LinearMath/btVector3.h"

class Parameters{
public:
	Parameters();
	~Parameters();

	int DEBUG;
	float TIME_STEP;
	int NUM_STEP_INT;
	float TIME_STOP;
	int PRINT;
	int SAVE;
	int SAVE_VIDEO;
	int OBJECT;
	
    std::vector<std::string> WHISKER_NAMES;
	std::vector<int> WHISKER_INDEX;
    float BLOW;
	int NO_CURVATURE;
	int NO_MASS;
	int NO_WHISKERS;
	int NUM_UNITS;
	int NUM_LINKS;
	float RHO_BASE;
	float RHO_TIP;
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

	btVector3 PEG_LOC;
	float PEG_SPEED;

	int EXPLORING;
	std::vector<std::vector<float>> HEAD_LOC_VEL;
	std::vector<std::vector<float>> WHISKER_LOC_VEL;
	
	std::string dir_out;
	std::string file_video;
	std::string file_env;
};

std::vector<float> get_vector(int N, float value);
std::vector<float> stringToFloatVect(std::vector<std::string> vect_string);

#endif //PARAMETERS_HPP