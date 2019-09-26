
#include "Whisker_utility.hpp"

btScalar calc_base_radius(int row, int col, btScalar S){  

    btScalar dBase = 0.041 + 0.002*S + 0.011*row - 0.0039*col;
    return (dBase/2.*1e-3) * SCALE;
}

btScalar calc_slope(btScalar L, btScalar rbase, int row, int col){

    btScalar S = L/SCALE*1e3;
    btScalar rb = rbase/SCALE*1e3;
    btScalar slope = 0.0012 + 0.00017*row - 0.000066*col + 0.00011*pow(col,2);
    btScalar rtip = (rb - slope*S)/2.;

    if(rtip <= 0.0015){
        rtip = 0.0015;
    }

    slope = (rb-rtip)/S;    
    return slope;
}


btScalar calc_mass(btScalar length, btScalar R, btScalar r, btScalar rho){
        
    btScalar m = rho*(PI*length/3)*(pow(R,2) + R*r + pow(r,2));    
    return m;
}

btScalar calc_inertia(btScalar radius){
	
	btScalar I = 0.25*PI*pow(radius,4);		
    return I;
}

btScalar calc_com(btScalar length, btScalar R, btScalar r){
    btScalar com = length/4*(pow(R,2) + 2*R*r + 3*pow(r,2))/(pow(R,2) + R*r + pow(r,2));
    return com;
}

btScalar calc_volume(btScalar length, btScalar R, btScalar r){
    btScalar vol = PI*length/3*(pow(R,2) + R*r + pow(r,2));
    return vol;
}

btScalar calc_stiffness(btScalar E, btScalar I, btScalar length){

    btScalar k = E*I/length;
    return k;
}


btScalar calc_damping(btScalar k, btScalar M, btScalar CoM, btScalar zeta, btScalar dt){
    
    btScalar actual_damp = zeta * 2 * CoM * sqrt(k * M);
    btScalar offset = CoM*CoM*M/dt;
    btScalar c = dt/(offset+actual_damp);   
    return c;
}



