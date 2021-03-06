# 16-662_Robot_Autonomy_Project
Collaboration on Robot Autonomy Project: 
An integrated system of 3D pose estimation and primitive robot actions for cluttered manipulation.

Link to the image data set:https://drive.google.com/drive/folders/0B3SUGe-kEOL4MXFzaU5VMFJRcUk?usp=sharing.


-----------------------------------Get the Training data-----------------------------------

-- Single object: background subtraction



-- Multiple objects: LabelMeToolBox:https://drive.google.com/drive/folders/0B9acCGhIdEtKVW9mYkNDV3NPbnM?usp=sharing

After you done labeling, download the images and the annotation files which is in the .xml format. <br />
Go to the LabelMeToolBox folder, use the demo_new.m to generate ground truth images based on the annotation you labeled by LabelMe. 

In the demo_new.m, modify the directory according to your own setting, HOMEIMAGES is where you store the original JPEG Images, HOMEANNOTATIONS is where you store your .xml file, NEWHOMELMSEGMENTS is where you are going to store the ground truth images. 

You can set the image size by modifying the NEWIMAGESIZE, making the input images smaller can save the GPU memories and make the training process faster.

Define the class name of your chosen objects in objectlist which should be a string containing all the class name and separated by coma. 

Now you can run the demo_new.m to generate data which could be used for training the FCN model. <br />
After running the script, three new folders and a report.txt file containing the number of each object’s appearance will be generated. <br />

The SegmentationClass containing the segmentation ground truth images, JPEGImages containing the original images, the Segmentation folder in ImageSets containing three txt files, which identify the image name of the training images, validation images and test images.

If you uncomment “LMdbshowscenes(LMquery(database, 'object.name', objectlist), HOMEIMAGES);
”, you will be able to check if you have labeled the objects correctly by visualization.


if you uncomment “LMdbshowobjects(LMquery(database, 'object.name', objectlist), HOMEIMAGES);
”, you will be able to check of you labeled each single object properly by visualization.

----------------------------------------Background substraction---------------------------------------------
In this section, we use the depth information to substract objects from the images. 
1. Open backgroundSubstract.m and check if all the objects are placed in the right path.
2. change "class","i","j" according to your case 


----------------------------------Train the FCN for segmentation--------------------------------------------

When you create the dataset for training successfully, you can move on to the training stage. 
Go to the fcn.berkeleyvision.org-master folder, which could be Git clone from the FCN Github:https://github.com/shelhamer/fcn.berkeleyvision.org.git. <br />
Or you can download from:https://drive.google.com/drive/folders/0B9acCGhIdEtKa3FsVHE0QnRadWM?usp=sharing.
Go to any voc-fcn folder (voc-fcn8s has the best result), there is a PYTHON script called solve.py which is used for training the network. Define your pre-trained model as the following format: “weights = '../voc-fcn8s/_iter_232000.caffemodel'”. Define your validation set by load the val.txt file you have created in the last step and give it to the variable val. <br />

solver.step(num) means the caffemodel will be saved everything num iterations. <br />

“solver.prototxt” is where you define the learning setup and also the snapshot where you store the caffemodel during training. <br />

Modify the output size in the “train.prototxt”, “val.prototxt” and “deploy.prototxt” file which is used to define the network architecture in caffe according to the number of object classes, the correct output size should be the number of object classes + 1(indicating the background class). <br />

Remember to modify the name of the layers which you have modified the output size, just give any name you like as long as it is different from the original one to tell caffe that new parameters should be initialized to this layer so it will ignore the pre-trained weights whose dimension will not match after you change the output size. <br />

The input data layer is defined in the voc_layers.py under the fcn.berkeleyvision.org-master folder.



Use the trained caffemodel for Segmentation

Go to the FCN_Segmentation folder, which can be downloaded from: https://drive.google.com/drive/folders/0B9acCGhIdEtKckhTRC1HQkkwSTQ?usp=sharing <br /> 
open the PYTHON script test.py.<br />

Put your deploy.prototxt at the “prototxtname”, your caffemodel at the “modelname”, and the image folder which you want to segment at the “foldername”.<br />

Run the test.py, there will be a new folder generated under the foldername dir, which contained the segmentation result(without postprocessing) generated by FCN model. <br />

After this step, all the following work is written in MATLAB, you can use the MATLAB script “pose_estimation_pipeline.m” to generate the object pose.<br />


--------------------------------------Get the object pose---------------------------------------------

Go to the “tf_optimization_0429” folder, which can be downloaded from:https://drive.google.com/drive/folders/0B9acCGhIdEtKWldGR09lV21YYzg?usp=sharing, <br />

open the MATLAB script “pose_estimation_pipeline.m”, you can directly run this script to get the pose estimation and ground truth validation results. <br />

Following the comment in the code to give the corresponding input. <br />

First we need to do some post-processing to the segmentation results. Note that this function is used for deal with the single object images. Put the segmentation output of the FCN at the imagedir. Set fill to be 1 to fill in the holes in the segmented area, set vis to be 1 to visualize the segmentation results, adjust the threshold to remove the noise.

Use the function tf_C2E_optimization to get the transformation from the camera to endofeffector. <br />

Use the function PCL to get the pose estimation under the robot base frame. <br />

We project all the 3D points in the point cloud onto the image plane and check if the projected 2D point lies in the segmented area to decide if we want this point or not. <br />

For the initialization of ICP, we decide its position based on the center of the dense point cloud, and decide the orietation based on the reference diretion we get using the pcfitcylinder function in matlab. The referenceVector is the initialization reference you need to give as the input in the script. <br />



-----------------------------Pose estimation ROS part-------------------------------

All files were tested on ubuntu 14.04, and ros-indigo <br />
Prerequisites <br />
1.Install librealsense: http://wiki.ros.org/librealsense#Installation_Prerequisites <br />
2.download and make the ros package “realsease_camera”: http://wiki.ros.org/realsense_camera <br />
3.download and make the ros package "apriltags_ros” http://wiki.ros.org/apriltags_ros <br />

4.download the whole package in this github : RA project,which include three ros package: 1. Show_object 2.adjust_tf <br /> 3.camera_info_publisher (the camera info publisher, not used it here) <br />
5.If you need more mesh model, you can dowload from ycb data set: http://rll.eecs.berkeley.edu/ycb/ <br />


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
