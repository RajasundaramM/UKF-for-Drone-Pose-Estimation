# UKF-for-Drone-Pose-Estimation
This repository contains the code and documentation for reliable drone pose estimation using sensor fusion of IMU and visual odometry data with an Unscented Kalman Filter.

# Project Overview
  This project explores the domain of reliable drone localization in GPS-denied environments. Multiple sensor modlaities such as IMU and camera are widely used to estimate a drone's position and orientation. Sensor fusion methods such as Kalman filter, Baysian filter, Particle filter etc. are traditional methods for fusing multiple sensor modalities to reliably estimate system state from noisy sensor measurements. While basic kalman filter method is widely used for state estimation in linear systems, variations of this widely used method like Extended Kalman Filter (EKF) and Unscented Kalman Filter (UKF) are shown to give much more reliable state estimates for non-linear systems. This project explores and implements UKF for estimating a drone's position, orientation and velocity from noisy velociity estimates through visual odometry on on-board camera feed, and linear acceleration and angular velocity measurements from on-board IMU. 

# Velocity Estimation from camera data
General picture
constraints here
implementation overview

# Unscented Kalman Filter
Why UKF
Tech explanation
Implementation Steps

# Results and Keypoints
Graphs
Points about tuning
Observations
