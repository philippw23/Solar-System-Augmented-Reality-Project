#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")

import platform

#if platform.machine() == "arm64":
#    env.Append(CCFLAGS=["-arch", "arm64"], LINKFLAGS=["-arch", "arm64"])

arch = ARGUMENTS.get("arch", platform.machine())

if arch == "arm64":
    env.Append(CCFLAGS=["-arch", "arm64"], LINKFLAGS=["-arch", "arm64"])
elif arch == "x86_64":
    env.Append(CCFLAGS=["-arch", "x86_64"], LINKFLAGS=["-arch", "x86_64"])
# For reference:
# - CCFLAGS are compilation flags shared between C and C++
# - CFLAGS are for C-specific compilation flags
# - CXXFLAGS are for C++-specific compilation flags
# - CPPFLAGS are for pre-processor flags
# - CPPDEFINES are for pre-processor defines
# - LINKFLAGS are for linking flags

# set this path to your library files. This is the location of dll, dylib and so files.
library_paths = [
    #'/usr/local/Cellar/opencv/4.11.0_1/lib'
    'opencv/4.11.0_1/lib'
]

# tweak this if you want to use different folders, or more folders, to store your source code in.
header_paths = [
    "src/",
    #"/usr/local/Cellar/opencv/4.11.0_1/lib"
    "opencv/4.11.0_1/include/opencv4"
]

library_files = {
    'windows': [
        'opencv_world490.lib',
        'opencv_world490d.lib'
    ],
    'macos': [
        'libopencv_core.dylib',
        'libopencv_imgcodecs.dylib',
        'libopencv_imgproc.dylib',
        'libopencv_videoio.dylib',
        'libopencv_objdetect.dylib',
        'libopencv_video.dylib',
        'libopencv_tracking.dylib'
    ],
    'linux': [
        'libopencv_core.so',
        'libopencv_imgcodecs.so',
        'libopencv_imgproc.so',
        'libopencv_videoio.so',
        'libopencv_objdetect.so',
        'libopencv_video.so',
        'libopencv_tracking.so'
    ]
}

# tweak this if you want to use different folders, or more folders, to store your source code in.
#env.Append(CPPPATH=["src/"])
env.Append(CPPPATH=header_paths)
env.Append(LIBPATH=library_paths)
env.Append(LIBS=library_files[env["platform"]])
sources = Glob("src/*.cpp")

if env["platform"] == "macos":
    library = env.SharedLibrary(
        "project/bin/libgdexample.{}.{}.framework/libgdexample.{}.{}".format(
            env["platform"], env["target"], env["platform"], env["target"]
        ),
        source=sources,
    )
elif env["platform"] == "ios":
    if env["ios_simulator"]:
        library = env.StaticLibrary(
            "project/bin/libgdexample.{}.{}.simulator.a".format(env["platform"], env["target"]),
            source=sources,
        )
    else:
        library = env.StaticLibrary(
            "project/bin/libgdexample.{}.{}.a".format(env["platform"], env["target"]),
            source=sources,
        )
else:
    library = env.SharedLibrary(
        "project/bin/libgdexample{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
