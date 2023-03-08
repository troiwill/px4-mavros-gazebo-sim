The following instructions describe how to use the installation 

## Prerequisites

We tested the installation with a [VMware virtual machine](https://www.vmware.com) and with [Ubuntu 20.04 LTS](https://releases.ubuntu.com/20.04/). However, it is not necessary to use a virtual machine.

Make a directory for repositories.
```
mkdir -p ${HOME}/repos
```

## Download QGroundControl Daily Build

Download the daily build for QGroundControl via the following [link](https://docs.qgroundcontrol.com/master/en/releases/daily_builds.html). Once downloaded, make the AppImage file executable by running the following lines.
```
cd ${HOME}/Downloads
chmod +x QGroundControl.AppImage
```

## Install python3 and pip3
The Gazebo and ROS Noetic installation script will fail if we do not install the Python future package.
```
sudo apt-get update
sudo apt-get install python3 python3-pip
```

## Install ROS Noetic and Gazebo

Follow the instructions on the ROS website to install ROS Noetic and Gazebo. [Here is the link](http://wiki.ros.org/noetic/Installation/Ubuntu).

## Install Mavlink and Mavros.

The original PX4 script to install Mavlink and Mavros was written for Ubuntu 18.04. This script is an *altered* version that works for Ubuntu 20.04 LTS and ROS Noetic. Go to the `scripts` directory in this repository and run [install_mav_tools.sh](scripts/install_mav_tools.sh).

## Building the PX4 repository

Let's build the PX4 repository. The following lines clone the PX4 repository and then uses the PX4 `ubuntu.sh` script to build the tools.

**Note:** When you run the `ubuntu.sh` script, you may receive `apt-get install *` errors. To avoid those errors, go to `Software & Updates` application and click on the `Ubuntu Software` tab. Finally, enable `Community-maintained free and open-source software (universe)`.
```
cd ${HOME}/repos
git clone https://github.com/PX4/PX4-Autopilot.git -b v1.13.0 --recursive
cd PX4-Autopilot
bash ./Tools/setup/ubuntu.sh
```

Once you built the tools, you must restart your computer.

Now, run the following commands once you've logged back into your account.
```
cd ${HOME}/repos/PX4-Autopilot
DONT_RUN=1 make px4_sitl_default gazebo
source ~/catkin_ws/devel/setup.bash    # (optional)
source Tools/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)/Tools/sitl_gazebo
```

Next, test your installation by running the following command:
```
roslaunch px4 mavros_posix_sitl.launch
```

## Update Iris SDF Jinja file

Update the `iris.sdf.jinja` file so that it includes a downward-facing FPV camera (this camera is also within PX4).
```
cd ${HOME}/repos

git clone https://github.com/troiwill/px4-mavros-gazebo-sim.git -b ros-noetic
cp px4-mavros-gazebo-sim/models/iris/iris.sdf.jinja PX4-Autopilot/Tools/sitl_gazebo/models/iris/
```

Next, build the Iris drone again and launch Gazebo to ensure the camera is attached to the drone. **Note:** If Gazebo fails to spawn the drone and camera, try restarting your computer and then run again.
```
# Build the updated Iris drone.
cd PX4-Autopilot
DONT_RUN=1 make px4_sitl_default gazebo

# Launch Gazebo
roslaunch px4 mavros_posix_sitl.launch
```

## Add a ROS Environment script

For each terminal, you may need to run the commands mentioned in the subsection that describes building PX4. Therefore, we provide a simple script that will run these commands for you every time you open a new terminal.

Copy the script to your home directory and add a reference to it in your `.bashrc` file.
```
cp px4-mavros-gazebo-sim/scripts/px4_sim_ros_env.sh ${HOME}/.px4_sim_ros_env.sh
cp ${HOME}/.bashrc ${HOME}/.bashrc.orig
echo "\n\n# Setup PX4 ROS environment.\n" >> ~/.bashrc
echo ". \"${HOME}/.px4_sim_ros_env.sh\" >/dev/null" >> ~/.bashrc
```

## Controlling the Drone with MAVROS PX4 Vehicle

Follow the [installation instructions](https://github.com/troiwill/mavros-px4-vehicle#installation) to use MAVROS PX4 vehicle to control the drone.

**Note:** You should checkout the `experimental-avoidance` branch to enable to drone to "fly over known obstacles." This feature is barebones and simply makes the drone ascend upward, move to the goal position, and then descend to the goal pose. There is **no** explicit obstacle avoidance feature.
