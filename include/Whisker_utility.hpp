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

btScalar calc_base_radius(int row, int col, btScalar L);
btScalar calc_slope(btScalar L, btScalar rbase, int row, int col);
btScalar calc_mass(btScalar length, btScalar R, btScalar r, btScalar rho);
btScalar calc_inertia(btScalar radius);
btScalar calc_com(btScalar length, btScalar R, btScalar r);
btScalar calc_volume(btScalar length, btScalar R, btScalar r);
btScalar calc_damping(btScalar k, btScalar mass, btScalar CoM, btScalar zeta, btScalar dt);
btScalar calc_stiffness(btScalar E, btScalar I, btScalar length);


#endif //WHISKER_UTILITY_HPP
