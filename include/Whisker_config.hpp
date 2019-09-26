
#ifndef WHISKER_CONFIG_HPP
#define WHISKER_CONFIG_HPP

#include "Simulation_utility.hpp"
#include "Simulation_IO.hpp"
#include "Parameters.hpp"

#include "LinearMath/btVector3.h"

#include <vector>
#include <string>
#include <iostream>

struct whisker_config{
	std::string id;
	int side;
	int row;
	int col;
	float L;
	float a;
	std::vector<float> link_angles;
	btVector3 base_pos;
	btVector3 base_rot;
};


whisker_config get_parameters(std::string wname,Parameters* parameters);
float get_dzeta(int index);
float get_dphi(int index);


#endif // 