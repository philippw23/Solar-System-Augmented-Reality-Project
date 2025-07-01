cd ORB_SLAM3/build

rm -rf *

cmake .. -DCMAKE_BUILD_TYPE=Release \
    -DPangolin_DIR="/Users/haoliang/Projects/student.tum.edu/Solar-System-Augmented-Reality-Project/ORB_SLAM3/Thirdparty/Pangolin/build" \
    -DBoost_INCLUDE_DIR=/opt/homebrew/include \
    -DBoost_LIBRARY_DIR=/opt/homebrew/lib -DCMAKE_EXE_LINKER_FLAGS="-L/opt/homebrew/lib" \
  -DCMAKE_SHARED_LINKER_FLAGS="-L/opt/homebrew/lib"

make -j$(nproc)