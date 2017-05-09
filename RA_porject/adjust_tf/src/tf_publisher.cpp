#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include <turtlesim/Pose.h>
#include "std_msgs/Char.h"

std::string turtle_name;

//typedef aptiltags_ros::AprilTagDetectionArray April_arrary;
//typedef aptiltags_ros::AprilTagDetection April_det;
float x = 0;
float y = 0;
float z = 0;
float rx = 0;
float ry = 0;
float rz = 0;
float level_x = 0.005;
float level_a = 0.1; 

void tfposeCallback(const std_msgs::Char::ConstPtr& msg ){
  char a  = msg->data;
  if(a == 'q') x = x + level_x;
  else if ( a == 'a') x = x - level_x;
  else if(a == 'w') y = y + level_x;
  else if ( a == 's') y = y - level_x;
  else if(a == 'e') z = z + level_x;
  else if ( a == 'd') z = z - level_x;
  else if(a == 'r') rx = rx + level_a;
  else if ( a == 'f') rx = rx - level_a;
  else if(a == 't') ry = ry + level_a;
  else if ( a == 'g') ry = ry - level_a;
  else if(a == 'y') rz = rz + level_a;
  else if ( a == 'h') rz = rz - level_a;
  else if (a == ' ');

  static tf::TransformBroadcaster br;
  tf::Transform transform;
  transform.setOrigin(tf::Vector3(x, y, z) );
  tf::Quaternion q;
  q.setRPY(rx, ry, rz);
  transform.setRotation(q);
  ROS_INFO("x,y,z,rw,rx,ry,rz = %f %f %f %f %f %f %f\n",x,y,z,q.w(),q.x(),q.y(),q.z());
  br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "apriltag_frame", "object_link"));
}

int main(int argc, char** argv){
  ros::init(argc, argv, "tf_publisher");
  //if (argc != 2){ROS_ERROR("need turtle name as argument"); return -1;};
  ros::NodeHandle node;

    ros::Subscriber sub = node.subscribe("tf_tele", 10, &tfposeCallback);
    ros::spin();
  return 0;
};

