cmake_minimum_required(VERSION 3.8)
project(face_module_msgs)
find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(std_msgs REQUIRED)
find_package(geometry_msgs REQUIRED)
rosidl_generate_interfaces(${PROJECT_NAME}
  "msg/AUCommand.msg" "msg/AUCommandArray.msg" "msg/Viseme.msg"
  "msg/GazeTarget.msg" "msg/NeckCommand.msg" "msg/Heartbeat.msg"
  "msg/AUState.msg" "msg/AUStateArray.msg" "msg/ActuatorHealth.msg" "msg/Health.msg"
  "srv/GetCapabilities.srv" "srv/SetMode.srv" "srv/PlaySequence.srv"
  "srv/SafeStop.srv" "srv/Reset.srv"
  "action/Recalibrate.action"
  DEPENDENCIES std_msgs geometry_msgs)
ament_package()
