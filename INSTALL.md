The following instructions describe how to use the installation 

## Prerequisites

We tested the installation with a [VMware virtual machine](https://www.vmware.com) and with [Ubuntu 18.04 LTS (Bionic Beaver)](https://releases.ubuntu.com/18.04/). However, it is not necessary to use a virtual machine. We use Ubuntu 18.04 because the PX4 installation uses ROS Melodic, which is tied to Ubuntu 18.04.

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

## Installing VSCode (Optional)

Let's install the Visual Studio Code (VSCode) IDE. Use the following lines to install VSCode or follow the installation instructions on the [official website](https://code.visualstudio.com/download).

## Install Python2, Pip2, and the 'future' package
The Gazebo and ROS Melodic installation script will fail if we do not install the Python future package.
```
sudo apt install python-minimal python-pip
python2 -m pip install future --user
```

## Install ROS Melodic with Gazebo 9
We will use the installation script from PX4 to install ROS Melodic and Gazebo 9.
```
cd ${HOME}/Downloads
wget https://raw.githubusercontent.com/PX4/Devguide/master/build_scripts/ubuntu_sim_ros_melodic.sh
bash ubuntu_sim_ros_melodic.sh
```

## Installing the Intel RealSense ROS packages

Follow the [installation instructions](https://github.com/troiwill/realsense-ros-sdf/blob/main/README.md#installation) for the `realsense-ros-sdf` repository to install the RealSense library, RealSense plugin, and ROS packages for Melodic.

## Building the PX4 repository

Let's build the PX4 repository. The following lines clone the PX4 repository and then uses the PX4 ubuntu.sh script to build the tools.
```
cd ${HOME}/repos
git clone https://github.com/PX4/PX4-Autopilot.git --recursive
cd PX4-Autopilot
bash ./Tools/setup/ubuntu.sh
```

Once you built the tools, you must restart your computer.

## Update Iris SDF Jinja file

Update the `iris.sdf.jinja` file so that it includes a RealSense D435 camera.
```
cd ${HOME}/repos
git clone https://github.com/troiwill/px4-mavros-gazebo-sim.git
cp px4-mavros-gazebo-sim/iris.sdf.jinja PX4-Autopilot/Tools/sitl_gazebo/models/iris/
```

## Fixing Gazebo 9 launch issues
Gazebo fails to run in our virtual machine after installation. Run the following lines fix the errors. First, we replace a YAML file with a modified version that contains a new URL. We used the following [link](https://varhowto.com/how-to-fix-libcurl-51-ssl-no-alternative-certificate-subject-name-matches-target-host-name-api-ignitionfuel-org-gazebo-ubuntu-ros-melodic/) to implement the fix.
```
cp "${HOME}/.ignition/fuel/config.yaml" "${HOME}/.ignition/fuel/config.yaml.original"
echo "" > "${HOME}/.ignition/fuel/config.yaml"
echo """
---
# The list of servers.
servers:
  -
    name: osrf
    url: https://fuel.ignitionrobotics.org

  # -
    # name: another_server
    # url: https://myserver

# Where are the assets stored in disk.
# cache:
#   path: /tmp/ignition/fuel
""" > "${HOME}/.ignition/fuel/config.yaml"
```

You might receive a symbol lookup error when trying to running Gazebo, which is described on this [Gazebo answers post](https://answers.gazebosim.org//question/22071/symbol-lookup-error-both-instalation-methods/). If you do, run the following command.
```
sudo apt upgrade libignition-math2
```

Finally, let's confirm that Gazebo launches by running the following line. If all went well, Gazebo will run with no errors or warnings.
