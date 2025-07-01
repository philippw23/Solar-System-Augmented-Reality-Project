#!/bin/bash

VOCAB_PATH="ORB_SLAM3/Vocabulary/ORBvoc.txt"
SETTINGS_PATH="ORB_SLAM3/Examples/Monocular/MyAR.yaml"
IMAGE_FOLDER="received_frames"

./ORB_SLAM3/Examples/Monocular/live_mono_slam $VOCAB_PATH $SETTINGS_PATH $IMAGE_FOLDER
