# This program is a part of EASIFEM library.
# See. www.easifem.com
# Copyright (c) 2020-2021, All right reserved, Vikas Sharma, Ph.D.
#

import os
import sys
import platform

def installRequest(LIB):
    while True:
        choice = input(
            f"Do you want to Install {LIB} 'yes' or 'no' [Y/n]: ").lower()
        if choice in ['Y', 'y', 'ye', 'yes']:
            return True
        else:
            return False

def getOption(key, opt):
    while True:
        separator = ', '
        return input(f"select option for {key}, possible options are : {separator.join(opt)} : ") + " "

print("Detecting OS type...")
_os = platform.system()
if _os == 'Windows':
    print("ERROR: INSTALLATION on windows is work in progress")
    exit
    #print("Please use Windows Subsystem Linux(WSL) ")
    #print("Installation DONE!!")
else:
    cmake_def = ""

    opt = getOption("CMAKE_GENERATOR", [
                    "Unix Makefiles", "Ninja", "Ninja Multi-Config"])
    if(opt == " "):
        opt = '"Ninja"'
        # opt = '"Ninja"'
    cmake_def += " -G " + opt

    opt = getOption("USE_GMSH_SDK", ["ON", "OFF"])
    if(opt == " "):
        opt = "ON"
    cmake_def += " -DUSE_GMSH_SDK=" + opt

    opt = getOption("USE_OpenMP", ["ON", "OFF"])
    if(opt == " "):
        opt = "ON"
    cmake_def += " -DUSE_OpenMP=" + opt

    opt = getOption("CMAKE_BUILD_TYPE", ["Release", "Debug"])
    if(opt == " "):
        opt = "Release"
    cmake_def += " -DCMAKE_BUILD_TYPE=" + opt

    opt = getOption("BUILD_SHARED_LIBS", ["ON", "OFF"])
    if(opt == " "):
        opt = "ON"
    cmake_def += " -DBUILD_SHARED_LIBS=" + opt

    opt = getOption("CMAKE_INSTALL_PREFIX", ["${PREFIX}"])
    if(opt == " "):
        opt = "${EASIFEM_CLASSES}"
    cmake_def += " -DCMAKE_INSTALL_PREFIX=" + opt

    cmake_def += " -DUSE_Int32=ON -DUSE_Real64=ON"

    print("CMAKE DEF : ", cmake_def)

    os.system(f"cmake -S ./ -B ~/temp/easifem-classes/build {cmake_def}")
    os.system(f"cmake --build ~/temp/easifem-classes/build --target install")
    print("Installation DONE!!")
