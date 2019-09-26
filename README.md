# virtual-rat

In this repository, we're building a 3D dynamical model of the full rat whisker array based on the open source physics engin Bullet Physics and OpenGL. This repository uses code extracted from Bullet Physics Library (bulletlib) which has to be compiled beforehand.

## Installation Instructions:
1. Install OpenGL/Glut with `sudo apt-get install freeglut3-dev`

2. Install Boost 1.62 library with `sudo apt-get install libboost1.62-all-dev`

3. Clone this repository including submodule:

```
	git clone https://github.com/SeNSE-lab/whisketphysics.git
```

4. First, compile Bullet Physics Library with (may take a while):
```
	cd your/path/to/bulletlib
	mkdir build
	cd build
	cmake ..
	make
```
5. Compile whisketphysics with:
```
	cd your/path/to/whisketphysics
	mkdir build
	cd build
	cmake ..
	make

```

   If boost library is not found by cmake try:

```
	cd your/path/to/whisketphysics
	mkdir build
	cd build
	sudo cmake --check-system-vars ..
	sudo make

```
6. Run `App_Whisker` (no graphics) or `AppWhiskerGui` (with graphics). Use --help or -h for information about command line arguments. Bash scripts for simulation presets are available in "script" folder.
 
