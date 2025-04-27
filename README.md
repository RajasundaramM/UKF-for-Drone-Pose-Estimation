# UKF-for-Drone-Pose-Estimation
This repository contains the code and documentation for reliable drone pose estimation using sensor fusion of IMU and visual odometry data with an Unscented Kalman Filter.

# Project Overview
  This project explores the domain of reliable drone localization in GPS-denied environments. Multiple sensor modlaities such as IMU and camera are widely used to estimate a drone's position and orientation. Sensor fusion methods such as Kalman filter, Baysian filter, Particle filter etc. are traditional methods for fusing multiple sensor modalities to reliably estimate system state from noisy sensor measurements. While basic kalman filter method is widely used for state estimation in linear systems, variations of this widely used method like Extended Kalman Filter (EKF) and Unscented Kalman Filter (UKF) are shown to give much more reliable state estimates for non-linear systems. This project explores and implements UKF for estimating a drone's position, orientation and velocity from noisy velociity estimates through visual odometry on on-board camera feed, and linear acceleration and angular velocity measurements from on-board IMU. 

<p align="center">
  <img src="top_view.jpeg" alt="Drone Top View" width="300"/>
  <img src="side_view.jpg" alt="Drone Side View" width="300"/>
</p>

# Optical flow based velocity measurement
Camera feed can be used to estimate velocity by computing optical flow. Optical flow is computed through library functions that match distinct visual features across frames and computes pixel-wise displacement of those features. Further computations are done on this optical flow to estimate the velocity of camera and hence velocity of the drone's body. 
Though velocity estimation through optical flow is accurate enough, it's reliability is challenged while facing surfaces with poor visual features / in low-light conditions. For this project, the drone is piloted in a controlled environment such that a mat with Apriltags is always present in the camera frame, such that the optical flow output doesn't produce extreme errors. 

# Unscented Kalman Filter
While both EKF and UKF can be used for state estimation in non-linear systems, UKF is recommended for better results as the perdiction and updates are done by discretization around multiple states that are strategically chosen, rather than considering only the current state like in EKF. 
Sigma-points (states) are chosen for current state estimation based on the mean and co-variance of state estimate in the previous time-step. The system dynamics model is discretized around these sigma points, and prediction and update steps are carried out. The predicted and updated state values are copmuted through weigthed sum of the values corresponding the sigma points. 
  In this project, the dynamics of the drone is modeled by taking linear and angular acceleration measurements from IMU as control inputs, and the drone position, orientation, and linear velocity in world frame as the state variables that are to be estimated. The velocity measured through optical flow is taken as the measurement variable for the update step. Detailed mathematical modeling is presented in the [report](Rajasundaram_Mathiazhagan_UKF_for_Drone_Pose_Estimation_Report.pd) section of this repository. 

# Results and Keypoints
  The estimated state values are compared with the ground truth values captured through the VICON system. A graph overlaying the estimated and ground-truth measurements is presented below.
  <p align="center">
  <img src="part2_ds1.jpg" alt="Drone Top View" width="600"/>
</p>
The Kalman Filter has covariance paramters that require fine-tuning for best performance. The above results that are generated after inital tuning displays good performance of the filter with most of the estimated variables closely following the ground truth measurement. 
