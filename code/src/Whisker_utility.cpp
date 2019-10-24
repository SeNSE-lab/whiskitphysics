
#include "Whisker_utility.hpp"

// these are constants for whisker rotation
std::vector<float> dphi = {0.398f,0.591f,0.578f,0.393f,0.217f};
std::vector<float> dzeta = {-0.9f,-0.284f,0.243f,0.449f, 0.744f};

// function to obtain parameters for specific whisker
whisker_config load_config(std::string wname,Parameters* parameters){
    
    boost::filesystem::path full_path(boost::filesystem::current_path());
    // read in parameter file
    std::vector<std::string> whisker_names;
    std::vector<std::vector<int>> whisker_pos;
    std::vector<std::vector<float>> whisker_geom;
    std::vector<std::vector<float>> whisker_angles;
    std::vector<std::vector<float>> whisker_bp_coor;
    std::vector<std::vector<float>> whisker_bp_angles;

    std::string file_angles = "../data/param_angles.csv";
    read_csv_string("../data/param_name.csv",whisker_names);
    read_csv_int("../data/param_side_row_col.csv",whisker_pos);
    read_csv_float("../data/param_s_a.csv",whisker_geom);
    read_csv_float(file_angles,whisker_angles);
    read_csv_float("../data/param_bp_pos.csv",whisker_bp_coor);
    read_csv_float("../data/param_bp_angles.csv",whisker_bp_angles);
    whisker_config wc;
    for(int i=0;i<whisker_names.size();i++){
        if(!wname.compare(whisker_names[i])){
            
            wc.id = wname;
            wc.side = whisker_pos[i][0];
            wc.row = whisker_pos[i][1];
            wc.col = whisker_pos[i][2];
            wc.L = whisker_geom[i][0]/1000.;
            wc.a = whisker_geom[i][1]*1000.;
            wc.link_angles = whisker_angles[i];
            wc.base_pos = btVector3(whisker_bp_coor[i][0],whisker_bp_coor[i][1],whisker_bp_coor[i][2])/1000.*SCALE;
            wc.base_rot = btVector3(whisker_bp_angles[i][0]-PI/2,-whisker_bp_angles[i][1],whisker_bp_angles[i][2]+PI/2);
            break;
        }
    }

    return wc;
    
}

// function to get zeta angle of whisker motion (depends on row)
float get_dzeta(int index){

	return dzeta[index];
}

// function to get phi angle of whisker motion (depends on row)
float get_dphi(int index){

	return dphi[index];
}


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



