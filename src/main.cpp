/*

This code is based on code published by
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2015 Google Inc. http://bulletphysics.org

*/

#include "Simulation.hpp"
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
	set_default(param);

  	try 
  	{ /** Define and parse the program options  */ 
	    namespace po = boost::program_options; 
	    po::options_description desc("Options"); 
	    desc.add_options() 
		("help,h", "Help screen")
		("DEBUG", po::value<int>(&param->DEBUG), "debug on/off")
		("ACTIVE", po::value<int>(&param->ACTIVE), "active on/off")
		("TIME_STOP", po::value<float>(&param->TIME_STOP), "time stop")
		("PRINT", po::value<int>(&param->PRINT), "print simulation output")
		("SAVE", po::value<int>(&param->SAVE), "saving on/off")
		("SAVE_VIDEO", po::value<int>(&param->SAVE_VIDEO), "video on/off")
		("OBJECT", po::value<int>(&param->OBJECT), "collision object ID (0: none, 1: stationary peg, 2: moving peg, 3: wall")
		
		("WHISKER_NAMES", po::value<std::vector<std::string> >(&param->WHISKER_NAMES)->multitoken(), "whisker names to simulate")
		("BLOW,b", po::value<float>(&param->BLOW), "whisker curvature on/off")
		("NO_MASS", po::value<int>(&param->NO_MASS), "whisker mass on/off")
		("NO_WHISKERS", po::value<int>(&param->NO_WHISKERS), "whisker on/off")

		("AMP_BWD", po::value<float>(&param->AMP_BWD), "whisk amplitude retraction angle")
		("AMP_FWD", po::value<float>(&param->AMP_FWD), "whisk amplitude protraction angle")
		("WHISK_FREQ", po::value<float>(&param->WHISK_FREQ), "whisk frequency")
		("POSITION", po::value<std::vector<float> >()->multitoken(), "initial positioin of rat")
		("PITCH", po::value<std::string>(), "head pitch")
		("YAW", po::value<std::string>(), "head yaw")
		("ROLL", po::value<std::string>(), "head roll")
		
		("DIST", po::value<float>(&param->DIST), "distance of camera")
		("CPITCH", po::value<std::string>(), "head pitch")
		("CYAW", po::value<std::string>(), "head yaw")
		
		("SPEED", po::value<float>(&param->SPEED), "peg speed")

		("dir_out", po::value<std::string>(&param->dir_out), "foldername for output file")
		("file_video", po::value<std::string>(&param->file_video), "filename of video")
		("file_env", po::value<std::string>(&param->file_env), "filename for environment");

	    po::variables_map vm; 


	    try { 
		    po::store(po::parse_command_line(argc, argv, desc), vm); // can throw 
		 	po::notify(vm);

		 	if ( vm.count("help")  ) { 
		        std::cout << "Bullet Whisker Simulation" << std::endl 
		                  << desc << std::endl; 
		        return 0; 
			} 
			
		    else if (vm.count("NUM_UNITS")){
		    	param->NUM_UNITS = vm["NUM_UNITS"].as<int>();
		    	param->NUM_LINKS = param->NUM_UNITS - 1;
		      	// std::cout << "Solver: " << vm["solver"].as<int>() << '\n';
		    }
		    
			if (!vm["POSITION"].empty() && (param->POSITION = vm["POSITION"].as<std::vector<float> >()).size() == 3) {
			// good to go
			}

			std::string pitch;
			if (vm.count("PITCH")){
				pitch = vm["PITCH"].as<std::string>();
				param->PITCH = lexical_cast<float>(pitch);
			}

			std::string yaw;
			if (vm.count("YAW")){
				yaw = vm["YAW"].as<std::string>();
				param->YAW = lexical_cast<float>(yaw);
			}

			std::string roll;
		    if (vm.count("ROLL")){
				roll = vm["ROLL"].as<std::string>();
				param->ROLL = lexical_cast<float>(roll);
			}

			std::string cpitch;
			if (vm.count("CPITCH")){
				cpitch = vm["CPITCH"].as<std::string>();
				param->CPITCH = lexical_cast<float>(cpitch);
			}

			std::string cyaw;
			if (vm.count("CYAW")){
				cyaw = vm["CYAW"].as<std::string>();
				param->CYAW = lexical_cast<float>(cyaw);
			}

	    	if (param->WHISKER_NAMES[0] == "ALL"){
	    		param->WHISKER_NAMES = {
	    			"LA0","LA1","LA2","LA3","LA4",
	    			"LB0","LB1","LB2","LB3","LB4","LB5",
	    			"LC0","LC1","LC2","LC3","LC4","LC5",
	    			"LD0","LD1","LD2","LD3","LD4","LD5",
	    			"LE1","LE2","LE3","LE4","LE5",
	    			"RA0","RA1","RA2","RA3","RA4",
	    			"RB0","RB1","RB2","RB3","RB4","RB5",
	    			"RC0","RC1","RC2","RC3","RC4","RC5",
	    			"RD0","RD1","RD2","RD3","RD4","RD5",
	    			"RE1","RE2","RE3","RE4","RE5"};
	    	}
			else if (param->WHISKER_NAMES[0] == "R"){
	    		param->WHISKER_NAMES = {
	    			
	    			"RA0","RA1","RA2","RA3","RA4",
	    			"RB0","RB1","RB2","RB3","RB4","RB5",
	    			"RC0","RC1","RC2","RC3","RC4","RC5",
	    			"RD0","RD1","RD2","RD3","RD4","RD5",
	    			"RE1","RE2","RE3","RE4","RE5"};
	    	}
			else if (param->WHISKER_NAMES[0] == "L"){
	    		param->WHISKER_NAMES = {
	    			"LA0","LA1","LA2","LA3","LA4",
	    			"LB0","LB1","LB2","LB3","LB4","LB5",
	    			"LC0","LC1","LC2","LC3","LC4","LC5",
	    			"LD0","LD1","LD2","LD3","LD4","LD5",
	    			"LE1","LE2","LE3","LE4","LE5"};
	    	}

			
		  	DummyGUIHelper noGfx;

			CommonExampleOptions options(&noGfx);
			Simulation* simulation = SimulationCreateFunc(options);

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
