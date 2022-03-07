The following instructions describe how to use the installation 

## Prerequisites

We tested the installation with a [VMware virtual machine](https://www.vmware.com) and with [Ubuntu 18.04 LTS (Bionic Beaver)](https://releases.ubuntu.com/18.04/). However, it is not necessary to use a virtual machine. We use Ubuntu 18.04 because the PX4 installation uses ROS Melodic, which is tied to Ubuntu 18.04.

## Install Python Pip and the 'future' package
The Gazebo and ROS Melodic installation script will fail if we do not install the Python future package.
```
sudo apt install python-pip
python -m pip install future
```

## Install ROS Melodic with Gazebo 9
We will use the installation script from PX4 to install ROS Melodic and Gazebo 9.
```
pushd "${HOME}/Downloads"
wget https://raw.githubusercontent.com/PX4/Devguide/master/build_scripts/ubuntu_sim_ros_melodic.sh
bash ubuntu_sim_ros_melodic.sh
popd
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

Next, we run the following line. The fix was described in this [link](https://answers.gazebosim.org//question/13214/virtual-machine-not-launching-gazebo/).
```
echo "export SVGA_VGPU10=0" >> ~/.profile
```

Finally, let's confirm that Gazebo launches by running the following line. If all went well, Gazebo will run with no errors or warnings.
```
gazebo
```

## Download QGroundControl Daily Build

Download the daily build for QGroundControl via the following [link](https://docs.qgroundcontrol.com/master/en/releases/daily_builds.html). Once downloaded, make the AppImage file executable by running the following lines.
```
pushd ${HOME}/Downloads
chmod +x QGroundControl.AppImage
popd
```

## Installing VSCode

Let's install the Visual Studio Code (VSCode) IDE. Use the following lines to install VSCode or follow the installation instructions on the [official website](https://code.visualstudio.com/download).
```
pushd "${HOME}/Downloads"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https
sudo apt update
sudo apt install code
popd
```

## Building the PX4 repository

Let's build the PX4 repository. The following lines clone the PX4 repository and then uses the PX4 ubuntu.sh script to build the tools.
```
cd "${HOME}"
mkdir -p repos
pushd "${HOME}/repos"
git clone https://github.com/PX4/PX4-Autopilot.git --recursive
bash ./PX4-Autopilot/Tools/setup/ubuntu.sh
popd
```

Once you built the tools, you must restart your computer.
