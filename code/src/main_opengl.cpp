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

#include "Simulation.hpp"

#include "CommonInterfaces/CommonExampleInterface.h"
#include "CommonInterfaces/CommonGUIHelperInterface.h"
#include "BulletCollision/CollisionDispatch/btCollisionObject.h"
#include "BulletCollision/CollisionShapes/btCollisionShape.h"
#include "BulletDynamics/Dynamics/btDiscreteDynamicsWorld.h"
#include "OpenGLWindow/SimpleOpenGL3App.h"
#include "Bullet3Common/b3Quaternion.h"

#include "Utils/b3Clock.h"

#include <stdio.h>
#include "ExampleBrowser/OpenGLGuiHelper.h"

#include <iostream>
// #include <vector>
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

char* gVideoFileName = 0;
char* gPngFileName = 0;

static b3WheelCallback sOldWheelCB = 0;
static b3ResizeCallback sOldResizeCB = 0;
static b3MouseMoveCallback sOldMouseMoveCB = 0;
static b3MouseButtonCallback sOldMouseButtonCB = 0;
static b3KeyboardCallback sOldKeyboardCB = 0;
//static b3RenderCallback sOldRenderCB = 0;

float gWidth = 1024;
float gHeight = 768;

Simulation*    simulation;
int gSharedMemoryKey=-1;

b3MouseMoveCallback prevMouseMoveCallback = 0;
static void OnMouseMove( float x, float y)
{
	bool handled = false; 
	handled = simulation->mouseMoveCallback(x,y); 	 
	if (!handled)
	{
		if (prevMouseMoveCallback)
			prevMouseMoveCallback (x,y);
	}
}

b3MouseButtonCallback prevMouseButtonCallback  = 0;
static void OnMouseDown(int button, int state, float x, float y) {
	bool handled = false;

	handled = simulation->mouseButtonCallback(button, state, x,y); 
	if (!handled)
	{
		if (prevMouseButtonCallback )
			prevMouseButtonCallback (button,state,x,y);
	}
}

class LessDummyGuiHelper : public DummyGUIHelper
{
	CommonGraphicsApp* m_app;
public:
	virtual CommonGraphicsApp* getAppInterface()
	{
		return m_app;
	}

	LessDummyGuiHelper(CommonGraphicsApp* app)
		:m_app(app)
	{
	}
};

int main(int argc, char** argv) 
{ 
	signal(SIGINT, exit_function);
	Parameters* param = new Parameters();
	set_default(param);
	
	

  	try 
  	{ 
    /** Define and parse the program options 
     */ 
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
		
		("WHISKER_NAMES", po::value<std::vector<std::string> >(&param->WHISKER_NAMES)->multitoken(), "whisker names to simulate")
		("BLOW,b", po::value<float>(&param->BLOW), "whisker curvature on/off")
		("NO_MASS", po::value<int>(&param->NO_MASS), "whisker mass on/off")
		("NO_WHISKERS", po::value<int>(&param->NO_WHISKERS), "whisker on/off")

		("ACTIVE", po::value<int>(&param->ACTIVE), "active on/off")
		("AMP_BWD", po::value<float>(&param->AMP_BWD), "whisk amplitude retraction angle")
		("AMP_FWD", po::value<float>(&param->AMP_FWD), "whisk amplitude protraction angle")
		("WHISK_FREQ", po::value<float>(&param->WHISK_FREQ), "whisk frequency")
		
		("POSITION", po::value<std::vector<std::string> >()->multitoken(), "initial position of rat")
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

			std::vector<std::string> coordinates;
			if (!vm["POSITION"].empty() && (coordinates = vm["POSITION"].as<std::vector<std::string> >()).size() == 3) {
				param->POSITION[0] = lexical_cast<float>(coordinates[0]);
				param->POSITION[1] = lexical_cast<float>(coordinates[1]);
				param->POSITION[2] = lexical_cast<float>(coordinates[2]);
			}	
					
			if (vm.count("PITCH")){
				std::string pitch;
				pitch = vm["PITCH"].as<std::string>();
				param->PITCH = lexical_cast<float>(pitch);
			}
			if (vm.count("YAW")){
				std::string yaw;
				yaw = vm["YAW"].as<std::string>();
				param->YAW = lexical_cast<float>(yaw);
			}
			
		    if (vm.count("ROLL")){
				std::string roll;
				roll = vm["ROLL"].as<std::string>();
				param->ROLL = lexical_cast<float>(roll);
			}

			if (vm.count("CPITCH")){
				std::string cpitch;
				cpitch = vm["CPITCH"].as<std::string>();
				param->CPITCH = lexical_cast<float>(cpitch);
			}
			
			if (vm.count("CYAW")){
				std::string cyaw;
				cyaw = vm["CYAW"].as<std::string>();
				param->CYAW = lexical_cast<float>(cyaw);
			}

	    	

		    // update_parameters(param);

			SimpleOpenGL3App* app = new SimpleOpenGL3App("Bullet Whisker Simulation",1024,768,true);
			
			prevMouseButtonCallback = app->m_window->getMouseButtonCallback();
			prevMouseMoveCallback = app->m_window->getMouseMoveCallback();

			app->m_window->setMouseButtonCallback((b3MouseButtonCallback)OnMouseDown);
			app->m_window->setMouseMoveCallback((b3MouseMoveCallback)OnMouseMove);
			
			OpenGLGuiHelper gui(app,false);
			CommonExampleOptions options(&gui);
			

			simulation = SimulationCreateFunc(options);
			simulation->processCommandLineArgs(argc, argv);

			simulation->parameters = param; // save parameters in simulation object

			simulation->initPhysics();
			simulation->resetCamera();

			char fileName[1024];
			int textureWidth = 128;
			int textureHeight = 128;
	
			unsigned char*	image = new unsigned char[textureWidth*textureHeight * 4];
			int textureHandle = app->m_renderer->registerTexture(image, textureWidth, textureHeight);
			
			// int cubeIndex = app->registerCubeShape(1, 1, 1);
	
			// b3Vector3 pos = b3MakeVector3(0, 0, 0);
			// b3Quaternion orn(0, 0, 0, 1);
			// b3Vector3 color = b3MakeVector3(1, 0, 0);
			// b3Vector3 scaling = b3MakeVector3 (1, 1, 1);

			if(param->SAVE_VIDEO){
				std::string videoname = param->file_video;
				gVideoFileName = &videoname[0];
				
				if (gVideoFileName){
					std::cout << "Rendering video..." << std::endl;
					app->dumpFramesToVideo(gVideoFileName);
	
				}

				std::string pngname = "png_test";
				gPngFileName = &pngname[0];
				
				// app->m_renderer->registerGraphicsInstance(cubeIndex, pos, orn, color, scaling);
				app->m_renderer->writeTransforms();


			}
			
			

			do
			{
				if(param->SAVE_VIDEO){
					static int frameCount = 0;
					frameCount++;

					if (gPngFileName)
					{
						// printf("gPngFileName=%s\n", gPngFileName);
		
						sprintf(fileName, "%s%d.png", gPngFileName, frameCount++);
						app->dumpNextFrameToPng(fileName);
					}
		
		
		
					//update the texels of the texture using a simple pattern, animated using frame index
					for (int y = 0; y < textureHeight; ++y)
					{
						const int	t = (y + frameCount) >> 4;
						unsigned char*	pi = image + y*textureWidth * 3;
						for (int x = 0; x < textureWidth; ++x)
						{
							const int		s = x >> 4;
							const unsigned char	b = 180;
							unsigned char			c = b + ((s + (t & 1)) & 1)*(255 - b);
							pi[0] = pi[1] = pi[2] = pi[3] = c; pi += 3;
						}
					}
		
					app->m_renderer->activateTexture(textureHandle);
					app->m_renderer->updateTexture(textureHandle, image);
		
					float color[4] = { 255, 1, 1, 1 };
					app->m_primRenderer->drawTexturedRect(100, 200, gWidth / 2 - 50, gHeight / 2 - 50, color, 0, 0, 1, 1, true);
				}

				app->m_instancingRenderer->init();
		    	app->m_instancingRenderer->updateCamera(app->getUpAxis());
			
				simulation->stepSimulation();

				if(param->DEBUG!=1){
					simulation->renderScene();
					app->m_renderer->renderScene();
				}
				

				DrawGridData dg;
		        dg.upAxis = app->getUpAxis();
				app->setBackgroundColor(1,1,1);
				app->drawGrid(dg);
				// char bla[1024];
				// std::sprintf(bla, "Simple test frame %d", frameCount);
				// app->drawText(bla, 10, 10);
				app->swapBuffer();


			} while (!app->m_window->requestedExit() && !(exitFlag || simulation->exitSim));
			
			
			if(simulation->parameters->SAVE){
				std::cout << "Simualtion terminated." << std::endl;
				std::cout << "Saving data..." << std::endl;
				output* results = simulation->get_results();
				save_data(results,simulation->parameters->dir_out);
			}

			std::cout << "Exit simulation..." << std::endl;
			simulation->exitPhysics();
			delete simulation;
			delete app;
			delete[] image;
			std::cout << "Done." << std::endl;

	    } 
	    catch(po::error& e) 
	    { 
	      std::cerr << "ERROR: " << e.what() << std::endl << std::endl; 
	      std::cerr << desc << std::endl; 
	      return 1; 
	    } 
 
    // application code here // 
 
  	} 
  	catch(std::exception& e) 
  	{ 
    	std::cerr << "Unhandled Exception reached the top of main: " 
              << e.what() << ", application will now exit" << std::endl; 
    	return 2; 
 
  	} 
 
  	return 0; 
 
} // main 



