
<img src="docs/whiskit_physics_logo_bg_white.png" height="203px" width="444px" >

WHISKiT is a 3D dynamical model of the full rat vibrissal array using the open-source physics engine Bullet Physics and OpenGL (https://github.com/bulletphysics/bullet3), developed by the SeNSE (Hartmann) Lab at Northwestern University. This tool allows researchers to simulate the sensory input of the vibrissal system, i.e. the mechanical signals (moment and force) generated at the base of each whisker in the array. The model includes 56 whiskers of an average whisker array (Belli et al. 2017, Belli et al. 2018) which are actuated according to the equations of motion by Knutsen et al. 2008. Each whisker is modeled as a chain of 20 rigid conical links connected with torsional springs of two degrees of freedom. The parameters of the springs were optimized and validated using data of real whiskers. A detailed description of the model is currently in preparation. When using this tool, be aware that it is still under development. 

<p align="center">
	<img src="docs/whiskit_peg_active.gif">
</p>

For more information: nzweifel@u.northwestern.edu

## Installation Instructions:
1. Install OpenGL/Glut with `sudo apt-get install freeglut3-dev`

2. Install Boost 1.62 library with `sudo apt-get install libboost1.62-all-dev`

3. Clone this repository:

```
	git clone https://github.com/SeNSE-lab/whiskitphysics.git
```

4. First, compile Bullet Physics Library (may take a while):
```
	cd your/path/to/bulletlib
	mkdir build
	cd build
	cmake ..
	make
```
5. Compile whisketphysics:
```
	cd your/path/to/whiskitphysics
	mkdir build
	cd build
	cmake ..
	make

```

   If boost library is not found by cmake try:

```
	cd your/path/to/whiskitphysics
	mkdir build
	cd build
	sudo cmake --check-system-vars ..
	sudo make

```
6. Run `App_Whisker` (no graphics) or `AppWhiskerGui` (with graphics). Use --help or -h for information about command line arguments. Bash scripts for simulation presets are available in "script" folder.
 
