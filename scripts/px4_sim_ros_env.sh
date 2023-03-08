#!/bin/bash

CATKIN_WS="${HOME}/catkin_ws"
PX4_DIR="${HOME}/repos/PX4-Autopilot"
CURR_WDIR=$(pwd)

export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/.local/lib"

# Source catkin ws
cd ${CATKIN_WS}
. "./devel/setup.bash"

# Source and export PX4
cd ${PX4_DIR}
. "./Tools/setup_gazebo.bash" $(pwd) $(pwd)/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)/Tools/sitl_gazebo

# Go back to working dir
cd ${CURR_WDIR}
