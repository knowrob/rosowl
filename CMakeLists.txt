cmake_minimum_required(VERSION 2.8.3)
project(rosowl)
find_package(catkin REQUIRED genowl)
catkin_package()
# catkin_python_setup()

# install legacy infrastructure needed by rosbuild
install(FILES rosbuild/rosowl.cmake
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/rosbuild)
catkin_install_python(PROGRAMS
  rosbuild/scripts/genmsg_owl.py
  rosbuild/scripts/gensrv_owl.py
  rosbuild/scripts/genutil_owl.py
DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/rosbuild/scripts)

generate_pkg_owl(rosowl std_msgs)
generate_pkg_owl(rosowl geometry_msgs)
