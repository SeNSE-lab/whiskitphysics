#include "Simulation_IO.h"


void clear_output(output* data){

    data->Mx.clear();
    data->My.clear();
    data->Mz.clear();
    data->Fx.clear();
    data->Fy.clear();
    data->Fz.clear();
    data->T.clear();
    data->names.clear();

    for(int w=0; w < data->Q.size(); w++){
		data->Q[w].X.clear();
		data->Q[w].Y.clear();
		data->Q[w].Z.clear();
		data->Q[w].C.clear();
	}

}

void save_data(output* data, std::string dirname){
    
    if(boost::filesystem::exists("../output")){
        std::cout << "Saving data..." << std::endl;
    }
    else{
        std::cout << "Saving data..." << std::endl;
        try{
            boost::filesystem::create_directory("../output");
        }
        catch(int e){
            printf("- Error creating output directory!\n");
            exit(1);
        }

    }

    if(boost::filesystem::exists(dirname)){
        std::cout << "- Output folder exists." << std::endl;
    }
    else{
        std::cout << "- Creating new output folder." << std::endl;
        try{
            boost::filesystem::create_directory(dirname);
        }
        catch(int e){
            printf("- Error creating output target directory!\n");
            exit(1);
        }

    }


    std::string subdirname0 = dirname + "/dynamics";
    if(!boost::filesystem::exists(subdirname0)){
        try{
            boost::filesystem::create_directory(subdirname0);
        }
        catch(int e){
            printf("- Error creating output subdirectory!\n");
            exit(1);
        }
    }

    std::string subdirname1 = dirname + "/kinematics";
    if(!boost::filesystem::exists(subdirname1)){
        try{
            boost::filesystem::create_directory(subdirname1);
        }
        catch(int e){
            printf("- Error creating output subdirectory!\n");
            exit(1);
        }
        
    }

    std::string subdirname2 = dirname + "/kinematics/x";
    if(!boost::filesystem::exists(subdirname2)){
        try{
            boost::filesystem::create_directory(subdirname2);
        }
        catch(int e){
            printf("- Error creating output subdirectory!\n");
            exit(1);
        }
    }

    std::string subdirname3 = dirname + "/kinematics/y";
    if(!boost::filesystem::exists(subdirname3)){
        try{
            boost::filesystem::create_directory(subdirname3);
        }
        catch(int e){
            printf("- Error creating output subdirectory!\n");
            exit(1);
        }
    }

    std::string subdirname4 = dirname + "/kinematics/z";
    if(!boost::filesystem::exists(subdirname4)){
        try{
            boost::filesystem::create_directory(subdirname4);
        }
        catch(int e){
            printf("- Error creating output subdirectory!\n");
            exit(1);
        }
    }

    std::string subdirname5 = dirname + "/kinematics/c";
    if(!boost::filesystem::exists(subdirname5)){
        try{
            boost::filesystem::create_directory(subdirname5);
        }
        catch(int e){
            printf("- Error creating output subdirectory!\n");
            exit(1);
        }
    }
    
    std::string filename;
    
    // save data to csv files
    try{
        filename = dirname + "/whisker_ID.csv";
        write_1D_string_csv(filename,data->names);
        std::cout << "- Whisker IDs saved." << std::endl;
    }
    catch (...) { 
        std::cout << "- Saving Whisker IDs failed." << std::endl;
    }

    try{
        for(int i=0;i<data->Q.size();i++){
            filename = subdirname2 + "/" + data->Q[i].name + ".csv";
            write_2D_float_csv(filename,data->Q[i].X);
            filename = subdirname3 + "/" + data->Q[i].name + ".csv";
            write_2D_float_csv(filename,data->Q[i].Y);
            filename = subdirname4 + "/" + data->Q[i].name + ".csv";
            write_2D_float_csv(filename,data->Q[i].Z);
            filename = subdirname5 + "/" + data->Q[i].name + ".csv";
            write_2D_int_csv(filename,data->Q[i].C);
            
        }
        std::cout << "- Kinematics saved." << std::endl;
    }
    catch (...) { 
        std::cout << "- Saving kinematics failed." << std::endl;
    }
    

    // save data to csv files
    try{
        filename = subdirname0 + "/Mx.csv";
        write_2D_float_csv(filename,data->Mx);
        std::cout << "- Mx saved." << std::endl;
    }
    catch (...) { 
        std::cout << "- Saving Mx failed." << std::endl;
    }
    try{
        filename = subdirname0 + "/My.csv";
        write_2D_float_csv(filename,data->My);
        std::cout << "- My saved." << std::endl;
    }
    catch (...) { 
        std::cout << "- Saving My failed." << std::endl;
    }
    try{
        filename = subdirname0 + "/Mz.csv";
        write_2D_float_csv(filename,data->Mz);
        std::cout << "- Mz saved." << std::endl;
    }
    catch (...) { 
        std::cout << "- Saving Mz failed." << std::endl;
    }
    try{
        filename = subdirname0 + "/Fx.csv";
        write_2D_float_csv(filename,data->Fx);
        std::cout << "- Fx saved." << std::endl;
    }
    catch (...) { 
        std::cout << "- Saving Fx failed." << std::endl;
    }
    try{
        filename = subdirname0 + "/Fy.csv";
        write_2D_float_csv(filename,data->Fy);
        std::cout << "- Fy saved." << std::endl;
    }
    catch (...) { 
        std::cout << "- Saving Fy failed." << std::endl;
    }
    try{
        filename = subdirname0 + "/Fz.csv";
        write_2D_float_csv(filename,data->Fz);
        std::cout << "- Fz saved." << std::endl;
    }
    catch (...) { 
        std::cout << "- Saving Fz failed." << std::endl;
    }
    
}

void write_2D_float_csv(std::string filename, std::vector<std::vector<float>> data){
    std::ofstream outputFile;
    outputFile.open(filename);
    for(int row=0;row<data.size();row++){
        for(int col=0;col<data[row].size();col++){
            outputFile << data[row][col] << ",";
        }
        outputFile << std::endl;
    }
    outputFile.close();
}

void write_2D_int_csv(std::string filename, std::vector<std::vector<int>> data){
    std::ofstream outputFile;
    outputFile.open(filename);
    for(int row=0;row<data.size();row++){
        for(int col=0;col<data[row].size();col++){
            outputFile << data[row][col] << ",";
        }
        outputFile << std::endl;
    }
    outputFile.close();
}

void write_1D_string_csv(std::string filename, std::vector<std::string> data){
    std::ofstream outputFile;
    outputFile.open(filename);
    for(int row=0;row<data.size();row++){
        outputFile << data[row] << ",";
        outputFile << std::endl;
    }
    outputFile.close();
}


void read_csv_string(std::string fileName, std::vector<std::string> &dataList){
    
    std::ifstream file(fileName);
    std::string line = "";
    std::string delimeter = ",";

    if (file.good()){
        // Iterate through each line and split the content using delimeter
        while (getline(file, line))
        {
            
            dataList.push_back(line);
        }
        // Close the File
        file.close();
    }
    else{
        std::cout << "\n======== ABORT SIMULATION ========" << std::endl;
        std::cout << "Failure in loading file " << fileName << "\n" << std::endl;
        exit (EXIT_FAILURE);
    }
}

void read_csv_int(std::string fileName, std::vector<std::vector<int> > &dataList){
    
    std::ifstream file(fileName);
    std::string line = "";
    std::string delimeter = ",";

    if (file.good()){
        // Iterate through each line and split the content using delimeter
        while (getline(file, line))
        {
            std::vector<std::string> vec_string;
            std::vector<int> vec_num;
            boost::algorithm::split(vec_string, line, boost::is_any_of(delimeter));

            // convert to float
            for(int i=0;i<vec_string.size();i++){
                vec_num.push_back(boost::lexical_cast<int>(vec_string[i]));
            }
            
            dataList.push_back(vec_num);
        }
        // Close the File
        file.close();
    }
    else{
        std::cout << "\n======== ABORT SIMULATION ========" << std::endl;
        std::cout << "Failure in loading file " << fileName << "\n" << std::endl;
        exit (EXIT_FAILURE);
    }

}

void read_csv_float(std::string fileName, std::vector<std::vector<float> > &dataList){
    
    

    std::ifstream file(fileName);
    std::string line = "";
    std::string delimeter = ",";

    if (file.good()){
    // Iterate through each line and split the content using delimeter
        while (getline(file, line))
        {
            std::vector<std::string> vec_string;
            std::vector<float> vec_num;
            boost::algorithm::split(vec_string, line, boost::is_any_of(delimeter));

            // convert to float
            for(int i=0;i<vec_string.size();i++){
                vec_num.push_back(boost::lexical_cast<float>(vec_string[i]));
            }
            
            dataList.push_back(vec_num);
        }
        // Close the File
        file.close();
    }
    else{
        std::cout << "\n======== ABORT SIMULATION ========" << std::endl;
        std::cout << "Failure in loading file " << fileName << "\n" << std::endl;
        exit (EXIT_FAILURE);
    }

}

