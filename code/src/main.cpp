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

This code is based on code published by
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2015 Google Inc. http://bulletphysics.org

*/

#include "Simulation.h"
#include "CommonInterfaces/CommonExampleInterface.h"
#include "CommonInterfaces/CommonGUIHelperInterface.h"
#include "BulletCollision/CollisionDispatch/btCollisionObject.h"
#include "BulletCollision/CollisionShapes/btCollisionShape.h"
#include "BulletDynamics/Dynamics/btDiscreteDynamicsWorld.h"
#include "OpenGLWindow/SimpleOpenGL3App.h"
#include "Bullet3Common/b3Quaternion.h"

#include "LinearMath/btTransform.h"
#include "LinearMath/btHashMap.h"

#include <iostream>
#include <boost/program_options.hpp>

#include <signal.h>
#include <stdlib.h>
#include <string>

#include <boost/lexical_cast.hpp>
using boost::lexical_cast;

volatile sig_atomic_t exitFlag = 0;

void exit_function(int sigint)
{
	exitFlag = 1;
}

int main(int argc, char* argv[])
{
	signal(SIGINT, exit_function);
	Parameters* param = new Parameters();

  	try 
  	{ /** Define and parse the program options  */ 
	    namespace po = boost::program_options; 
	    po::options_description desc("Options");
	    desc.add_options() 
		("help,h", "Help screen")
		("DEBUG", po::value<int>(&param->DEBUG), "debug on/off")
		
		("TIME_STOP", po::value<float>(&param->TIME_STOP), "duration of simulation")

		("PRINT", po::value<int>(&param->PRINT), "print simulation output")
		("SAVE", po::value<int>(&param->SAVE), "saving on/off")
		("SAVE_VIDEO", po::value<int>(&param->SAVE_VIDEO), "video on/off")

		("OBJECT", po::value<int>(&param->OBJECT), "collision object ID (0: none, 1: stationary peg, 2: moving peg, 3: wall")
		
		("MODEL_TYPE", po::value<int>(&param->MODEL_TYPE), "model type: 0: average rat, 1: model Belli et al. 2018")
		("WHISKER_NAMES", po::value<std::vector<std::string> >(&param->WHISKER_NAMES)->multitoken(), "whisker names to simulate")
		("BLOW,b", po::value<float>(&param->BLOW), "whisker curvature on/off")
		("NO_MASS", po::value<int>(&param->NO_MASS), "whisker mass on/off")
		("NO_WHISKERS", po::value<int>(&param->NO_WHISKERS), "whisker on/off")

		("ACTIVE", po::value<int>(&param->ACTIVE), "active on/off")
		
		("POSITION", po::value<std::vector<std::string> >()->multitoken(), "initial position of rat")
		("ORIENTATION", po::value<std::vector<std::string> >()->multitoken(), "initial orientation of rat (euler angles)")
		
		("CDIST", po::value<float>(&param->CDIST), "distance of camera")
		("CPITCH", po::value<std::string>(), "head pitch")
		("CYAW", po::value<std::string>(), "head yaw")
		
		("SPEED", po::value<float>(&param->PEG_SPEED), "peg speed")

		("dir_out", po::value<std::string>(&param->dir_out), "foldername for output file")
		("file_video", po::value<std::string>(&param->file_video), "filename of video")
		("file_env", po::value<std::string>(&param->file_env), "filename for environment");


	    po::variables_map vm; 


	    try { 
		    po::store(po::parse_command_line(argc, argv, desc,po::command_line_style::unix_style ^ po::command_line_style::allow_short), vm); // can throw 
		 	po::notify(vm);

		 	if ( vm.count("help")  ) { 
		        std::cout << "Bullet Whisker Simulation" << std::endl 
		                  << desc << std::endl; 
		        return 0; 
		    } 
			
			if (param->WHISKER_NAMES[0] == "ALL"){
	    		param->WHISKER_NAMES = {
	    			"LA0","LA1","LA2","LA3","LA4",
	    			"LB0","LB1","LB2","LB3","LB4",
	    			"LC0","LC1","LC2","LC3","LC4","LC5",
	    			"LD0","LD1","LD2","LD3","LD4","LD5",
	    			"LE1","LE2","LE3","LE4","LE5",
	    			"RA0","RA1","RA2","RA3","RA4",
	    			"RB0","RB1","RB2","RB3","RB4",
	    			"RC0","RC1","RC2","RC3","RC4","RC5",
	    			"RD0","RD1","RD2","RD3","RD4","RD5",
	    			"RE1","RE2","RE3","RE4","RE5"};
	    	}

	    	else if (param->WHISKER_NAMES[0] == "R"){
	    		param->WHISKER_NAMES = {
	    			
	    			"RA0","RA1","RA2","RA3","RA4",
	    			"RB0","RB1","RB2","RB3","RB4",
	    			"RC0","RC1","RC2","RC3","RC4","RC5",
	    			"RD0","RD1","RD2","RD3","RD4","RD5",
	    			"RE1","RE2","RE3","RE4","RE5"};
	    	}
			else if (param->WHISKER_NAMES[0] == "L"){
	    		param->WHISKER_NAMES = {
	    			"LA0","LA1","LA2","LA3","LA4",
	    			"LB0","LB1","LB2","LB3","LB4",
	    			"LC0","LC1","LC2","LC3","LC4","LC5",
	    			"LD0","LD1","LD2","LD3","LD4","LD5",
	    			"LE1","LE2","LE3","LE4","LE5"};
	    	}

			std::vector<std::string> coordinates;
			if (!vm["POSITION"].empty() && (coordinates = vm["POSITION"].as<std::vector<std::string> >()).size() == 3) {
				param->RATHEAD_LOC[0] = lexical_cast<float>(coordinates[0]);
				param->RATHEAD_LOC[1] = lexical_cast<float>(coordinates[1]);
				param->RATHEAD_LOC[2] = lexical_cast<float>(coordinates[2]);
			}	

			std::vector<std::string> angles;
			if (!vm["ORIENTATION"].empty() && (angles = vm["ORIENTATION"].as<std::vector<std::string> >()).size() == 3) {
				param->RATHEAD_ORIENT[0] = lexical_cast<float>(angles[0]);
				param->RATHEAD_ORIENT[1] = lexical_cast<float>(angles[1]);
				param->RATHEAD_ORIENT[2] = lexical_cast<float>(angles[2]);
			}		

			
		  	DummyGUIHelper noGfx;

			CommonExampleOptions options(&noGfx);
			Simulation* simulation = new Simulation(options.m_guiHelper);

			// save parameters in simulation object
			simulation->parameters = param;
			simulation->initPhysics();
			std::cout.precision(17);
			
			// run simulation
			do{
				simulation->stepSimulation();
			}while(!(exitFlag || simulation->exitSim) );

			std::cout << "Saving data..." << std::endl;
			if(simulation->parameters->SAVE){
				std::cout << "Simualtion terminated." << std::endl;
				output* results = simulation->get_results();
				save_data(results,simulation->parameters->dir_out);
			}
			

			std::cout << "Exit simulation..." << std::endl;
			simulation->exitPhysics();

			delete simulation;
			std::cout << "Done." << std::endl;
			
	    } 
	    catch(po::error& e) 
	    { 
	      std::cerr << "ERROR: " << e.what() << std::endl << std::endl; 
	      std::cerr << desc << std::endl; 
	      return 1; 
	    } 
 
  	} 
  	catch(std::exception& e) 
  	{ 	std::cerr << "Unhandled Exception reached the top of main: "           << e.what() << ", application will now exit" << std::endl; 	return 2; 
 
  	} 

	
	return 0;
}
