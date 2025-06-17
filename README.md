🌌 Solar System Augmented Reality Project

An augmented reality project using Godot 4.x and GDExtension to display the planets of our solar system on AR markers.
It uses a custom godot-cpp extension for marker detection and 3D model placement.

⸻

📸 Features
	•	Realistic 3D representation of planets (with scale-adjusted models) on detected markers
	•	OpenCV integration for marker detection and image processing
	•	Native C++ processing with Godot GDExtension
	•	Dynamic 3D labels above each planet
	•	Live camera streaming or video file input support

⸻

🛠 Requirements
	•	Godot Engine 4.x
	•	C++ toolchain (e.g. clang++, g++)
	•	Python (for scons)
	•	Git (with submodule support)
	•	Git LFS (for large 3D models)

⸻

📦 Setup

git clone --recurse-submodules git@github.com:philippw23/Solar-System-Augmented-Reality-Project.git
cd Solar-System-Augmented-Reality-Project

If you forgot --recurse-submodules:

git submodule update --init --recursive


⸻

⚙️ Build GDExtension (C++)

cd godot-cpp
scons platform=macos generate_bindings=yes -j4
cd ..
scons platform=macos

Replace platform=macos with windows, linux, or your target platform.

⸻

🗂 Project Structure

Solar-System-Augmented-Reality-Project/
├── godot-cpp/               # Added as a submodule
├── project/                 # Godot project files (.tscn, .gd, assets)
├── src/                     # C++ code (marker tracking, GDExtension)
├── .gitattributes           # Git LFS tracking for large files
└── .gitignore


⸻

⚠️ GitHub Notes

If your project includes large files like .glb models:

Make sure Git LFS is installed:

git lfs install
git lfs pull


⸻

📄 License

None

⸻

✨ Author

Philipp Wiese
github.com/philippw23
