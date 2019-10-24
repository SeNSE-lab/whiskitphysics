
import subprocess

def simulate(whisker):
   
    print('Simulating: ' + str(whisker))
    dirout = "../output"
    cmdstr = "../build/AppWhiskerGui --SAVE 1" + " --WHISKER_NAMES " + whisker + " --dir_out " + dirout
    s = subprocess.getoutput([cmdstr])


if __name__ == "__main__":

    # whisker_names = ["RA0", "RA1", "RA2", "RA3", "RA4",
    #                  "RB0", "RB1", "RB2", "RB3", "RB4", "RB5",
    #                  "RC0", "RC1", "RC2", "RC3", "RC4", "RC5", "RC6",
    #                  "RD0", "RD1", "RD2", "RD3", "RD4", "RD5", "RD6",
    #                  "RE1", "RE2", "RE3", "RE4", "RE5", "RE6"]

    simulate("R")

    pool = Pool(1) # set number of cores to use in simulation
    try:
        pool.map(simulate, whisker_names)
    finally:
        pool.close()
        pool.join()