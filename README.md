# WHISKiT Physics

![whiskit logo](docs/whiskit_physics_logo_bg_white.png)


In this repository, we're building a 3D dynamical model of the full rat whisker array based on the open source physics engine Bullet Physics and OpenGL.

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
 
