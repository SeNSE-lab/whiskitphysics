
<img src="docs/whiskit_physics_logo_bg_white.png" height="203px" width="444px" >

WHISKiT Physics, developed by the SeNSE (Hartmann) Lab at Northwestern University, is a 3D dynamical model of the full rat vibrissal array using the open-source physics engine Bullet Physics and OpenGL (https://github.com/bulletphysics). This tool allows researchers to simulate the sensory input of the vibrissal system, i.e. the mechanical signals (moment and force) generated at the base of each whisker in the array. The model includes 56 whiskers of an average whisker array (Belli et al. 2017, Belli et al. 2018) which are actuated according to the equations of motion by Knutsen et al. 2008. Each whisker is modeled as a chain of 20 rigid conical links connected by torsional springs with two degrees of freedom. The parameters of the springs were optimized and validated using data of real whiskers. A detailed description of the model is available [here](https://www.pnas.org/doi/10.1073/pnas.2011905118).

<p align="center">
	<img src="docs/whiskit_active_peg.gif">
</p>

For more information or feedback contact nzweifel@u.northwestern.edu

## Installation Instructions:
1. Install OpenGL/Glut with `sudo apt-get install freeglut3-dev`

2. Install Boost 1.62 library with `sudo apt-get install libboost-all-dev`

3. Clone this repository:

```
	git clone https://github.com/SeNSE-lab/whiskitphysics.git
```

4. Compile whisketphysics:
```
	cd your/path/to/whiskitphysics/code
	mkdir build
	cd build
	cmake ..
	make

```

   If boost library is not found by cmake try:

```
	cd your/path/to/whiskitphysics/code
	mkdir build
	cd build
	sudo cmake --check-system-vars ..
	sudo make

```
5. Run `whiskit` (no graphics) or `whiskit_gui` (with graphics). Use --help or -h for information about command line arguments. Bash scripts for simulation presets are available in "script" folder.
 
## Generate a custom whisking trajectory:
To generate the active whisking motion, the model uses two CSV files located in ```code/data/```. The files describe a sinusoidal whisking trajectory with a whisking frequency of 8Hz, 35 degrees protraction, and 10 degrees retraction in respect to the resting position for a duration of 1 second. To generate a custom whisking trajectory (e.g. protraction = 40 degrees, retraction = 30 degrees, frequency = 6Hz, duration = 2 seconds) use the matlab function ```generate_whisk_model_rat(40,40,6,2)``` in the directory ```scripts/generate_whisk```. This function generates the CSV files that are needed to actuate the whiskers of the WHISKiT model. The generated whisking motion uses the model morphology from Belli et al. 2018.

