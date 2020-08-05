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
*/

#ifndef SIMULATION_IO_H
#define SIMULATION_IO_H

#include <typeinfo>
#include <iostream>
#include <fstream>
#include <vector>
#include <iterator>
#include <string>
#include <sys/stat.h>
#include <msgpack.h>
#include "LinearMath/btVector3.h"

#include <boost/lexical_cast.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/filesystem.hpp>


struct kinematic_data{
	std::string name;
	std::vector<std::vector<float>> X;
	std::vector<std::vector<float>> Y;
	std::vector<std::vector<float>> Z;
	std::vector<std::vector<int>> C;
};

struct output{


	std::vector<std::vector<float>> Mx;
	std::vector<std::vector<float>> My;
	std::vector<std::vector<float>> Mz;
	std::vector<std::vector<float>> Fx;
	std::vector<std::vector<float>> Fy;
	std::vector<std::vector<float>> Fz;

	std::vector<kinematic_data> Q;

	std::vector<float> T;

	std::vector<std::string> names;


	void init(std::vector<std::string> whiskernames){
		names = whiskernames;
		for(int w=0;w<whiskernames.size();w++){
			kinematic_data w_data;
			w_data.name = whiskernames[w];
			Q.push_back(w_data);
		}
	
	};
};


void clear_output(output* data);
void save_data(output* data, std::string filename = "../output/test");

void read_csv_string(std::string fileName, std::vector<std::string> &dataList);
void read_csv_int(std::string fileName, std::vector<std::vector<int> > &dataList);
void read_csv_float(std::string fileName, std::vector<std::vector<float> > &dataList);

void write_2D_float_csv(std::string filename, std::vector<std::vector<float>> data);
void write_2D_int_csv(std::string filename, std::vector<std::vector<int>> data);
void write_1D_string_csv(std::string filename, std::vector<std::string> data);

#endif //SIMULATION_IO_H