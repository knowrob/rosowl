rosbuild_find_ros_package(rosowl)

# Message-generation support.
macro(genmsg_owl)
  rosbuild_get_msgs(_msglist)
  set(_inlist "")
  set(_autogen "")
  set(genmsg_owl_exe ${rosowl_PACKAGE_PATH}/rosbuild/scripts/genmsg_owl.py)

  foreach(_msg ${_msglist})
    # Construct the path to the .msg file
    set(_input ${PROJECT_SOURCE_DIR}/msg/${_msg})
    # Append it to a list, which we'll pass back to gensrv below
    list(APPEND _inlist ${_input})
  
    rosbuild_gendeps(${PROJECT_NAME} ${_msg})
  

    set(_output_owl ${PROJECT_SOURCE_DIR}/src/${PROJECT_NAME}/msg/${_msg})
    string(REPLACE ".msg" ".owl" _output_owl ${_output_owl})
  
    # Add the rule to build the .owl from the .msg.
    add_custom_command(OUTPUT ${_output_owl} 
                       COMMAND ${genmsg_owl_exe} ${_input}
                       DEPENDS ${_input} ${genmsg_owl_exe} ${gendeps_exe} ${${PROJECT_NAME}_${_msg}_GENDEPS} ${ROS_MANIFEST_LIST})
    list(APPEND _autogen ${_output_owl})
  endforeach(_msg)

  if(_autogen)
    add_custom_target(ROSBUILD_genmsg_owl)
    # Make our target depend on rosbuild_premsgsrvgen, to allow any
    # pre-msg/srv generation steps to be done first.
    add_dependencies(ROSBUILD_genmsg_owl rosbuild_premsgsrvgen)
    # Add our target to the top-level genmsg target, which will be fired if
    # the user calls genmsg()
    add_dependencies(rospack_genmsg ROSBUILD_genmsg_owl)

    # Also set up to clean the src/<project>/msg directory
    get_directory_property(_old_clean_files ADDITIONAL_MAKE_CLEAN_FILES)
    list(APPEND _old_clean_files ${PROJECT_SOURCE_DIR}/src/${PROJECT_NAME}/msg)
    set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${_old_clean_files}")
  endif(_autogen)
endmacro(genmsg_owl)

# Call the macro we just defined.
genmsg_owl()

# Service-generation support.
macro(gensrv_owl)
  rosbuild_get_srvs(_srvlist)
  set(_inlist "")
  set(_autogen "")
  set(gensrv_owl_exe ${rosowl_PACKAGE_PATH}/rosbuild/scripts/gensrv_owl.py)

  foreach(_srv ${_srvlist})
    # Construct the path to the .srv file
    set(_input ${PROJECT_SOURCE_DIR}/srv/${_srv})
    # Append it to a list, which we'll pass back to gensrv below
    list(APPEND _inlist ${_input})
  
    rosbuild_gendeps(${PROJECT_NAME} ${_srv})
  

    set(_output_owl ${PROJECT_SOURCE_DIR}/src/${PROJECT_NAME}/srv/${_srv})
    string(REPLACE ".srv" ".owl" _output_owl ${_output_owl})
  
    # Add the rule to build the .owl from the .srv
    add_custom_command(OUTPUT ${_output_owl} 
                       COMMAND ${gensrv_owl_exe} ${_input}
                       DEPENDS ${_input} ${gensrv_owl_exe} ${gendeps_exe} ${${PROJECT_NAME}_${_srv}_GENDEPS} ${ROS_MANIFEST_LIST})
    list(APPEND _autogen ${_output_owl})
  endforeach(_srv)

  if(_autogen)
    add_custom_target(ROSBUILD_gensrv_owl)
    # Make our target depend on rosbuild_premsgsrvgen, to allow any
    # pre-msg/srv generation steps to be done first.
    add_dependencies(ROSBUILD_gensrv_owl rosbuild_premsgsrvgen)
    # Add our target to the top-level gensrv target, which will be fired if
    # the user calls gensrv()
    add_dependencies(rospack_gensrv ROSBUILD_gensrv_owl)

    # Also set up to clean the src/<project>/srv directory
    get_directory_property(_old_clean_files ADDITIONAL_MAKE_CLEAN_FILES)
    list(APPEND _old_clean_files ${PROJECT_SOURCE_DIR}/src/${PROJECT_NAME}/srv)
    set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${_old_clean_files}")
  endif(_autogen)
endmacro(gensrv_owl)

# Call the macro we just defined.
gensrv_owl()
