# 16-662_Robot_Autonomy_Project
Collaboration on Robot Autonomy Project: An integrated system of 3D pose estimation and primitive robot actions for cluttered manipulation.




---------------------Pose Esitmation-------------------------------
Robot autonomy <br />
Pose estimation ROS part <br />
All files were tested on ubuntu 14.04, and ros-indigo <br />
Prerequisites <br />
1.Install librealsense: http://wiki.ros.org/librealsense#Installation_Prerequisites <br />
2.download and make the ros package “realsease_camera”: http://wiki.ros.org/realsense_camera <br />
3.download and make the ros package "apriltags_ros” http://wiki.ros.org/apriltags_ros <br />

4.download the whole package in code : RA project,which include three ros package: 1. Show_object 2.adjust_tf <br /> 3.camera_info_publisher (the camera info publisher, not used it here) <br />
5.If you need more model mesh, you can dowload from ycb data set: http://rll.eecs.berkeley.edu/ycb/ <br />


A.Show object using existing tf <br />

Detect the april tag( 36h11, Id:0) and use the existing static tf to place the object <br />
1.Plug in camera <br />
2. $roscd show_object<br />
3. $roslaunch show_object example.launch<br />
PS. for creating the new object launch file, you will need to create a new urdf also. <br />

B.Show object using adjust_tf(using this to find the tf from object to apriltags frame) <br />

1.plug in camera <br />
2.$roscd show_object<br />
3.$roslaunch show_object “object”.launch(example: banana.launch)<br />
PS. In “object”.launch, you show comment the static transformation node: <br />
<!--node pkg="tf" type="static_transform_publisher" name="wood_wrt_apr" args="0.015000 0.060000 -0.025000 0.987535 -0.149251 0.049418 0.007469  apriltag_frame object_link 100" /--> , to prevent the static transform work when you want to adjust the tf manually<br />

4.Open new terminal console, cd your workspace<br />
5.$roslaunch adjust_tf.launch<br />
6. Then you can type the char and press enter in the terminal to change the tf from object to apriltags fram and see what the change via rviz.<br />
char result<br />
q/a  In x axis +0.005/-0.005<br />
w/s  In y axis +0.005/-0.005<br />
e/d  In z axis +0.005/-0.005<br />
r/f  Rotate x-axis +0.1 /-0.1radius<br />
t/g  Rotate y-axis +0.1 /-0.1radius<br />
y/h  Roate z-axis +0.1 /-0.1radius<br />

you type the character in the terminal and press Enter to see the result.<br />

7. Then after you find the good tf from object to apriltags frame, you can record it, and save it at stage A.<br />
