#ifndef WHISKER_UTILITY_HPP
#define WHISKER_UTILITY_HPP

#include "Simulation_utility.hpp"

#include "btBulletDynamicsCommon.h"
#include "BulletWorldImporter/btWorldImporter.h"

#include "LinearMath/btVector3.h"
#include "LinearMath/btAlignedObjectArray.h"
#include <iostream>

// #include "CommonRigidBodyBase.h"
// #include "CommonParameterInterface.h"

#include <vector>
#include <numeric>
#include <algorithm>
#include <map>
#include <string>
#include "math.h"

float calc_base_radius(int row, int col, float L);
std::vector<float> calc_unit_radius(int numUnits, float L, float rbase, int row, int col);
std::vector<float> calc_mass(int numUnits, std::vector<float> unit_length, std::vector<float> radius, std::vector<float> rho);
std::vector<float> calc_unit_length(int numUnits, float length);
std::vector<float> calc_inertia(int numUnits, std::vector<float> radius);
std::vector<float> calc_density(int numUnits, float roh_base, float roh_tip);
std::vector<float> calc_young_modulus(int numUnits, float E_base, float E_tip);
std::vector<float> calc_com(int numUnits, std::vector<float> unit_length, std::vector<float> radius);
std::vector<float> calc_volume(int numUnits, std::vector<float> unit_length, std::vector<float> radius);
std::vector<float> calc_zeta(int numUnits, float zeta_base, float zeta_tip);
std::vector<float> calc_damping(int numLinks, std::vector<float> k, std::vector<float> mass, std::vector<float> CoM, std::vector<float> zeta, float dt);
std::vector<float> calc_stiffness(int numLinks, std::vector<float> E, std::vector<float> I, std::vector<float> unit_length);


#endif //WHISKER_UTILITY_HPP
