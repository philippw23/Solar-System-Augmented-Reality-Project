/*
Contribution credits:
Leonard Keil <leonard.keil@tum.de>
Jannik Waldraff <jannik.waldraff@tum.de>
Sandro Weber <sandro.weber@tum.de>
*/

#ifndef CV_CAMERA_H
#define CV_CAMERA_H

#include <stdio.h>
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>
#include <godot_cpp/classes/image.hpp>
#include <opencv2/core.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/imgproc.hpp>
#include <map>

struct StripDimensions
{
    int stripLength;
    int nStop;
    int nStart;
    cv::Point2f stripeVecX;
    cv::Point2f stripeVecY;
};

namespace godot
{

    class CVCamera : public RefCounted
    {
        GDCLASS(CVCamera, RefCounted)

    private:
        cv::VideoCapture capture;
        uint64_t last_update_frame;
        cv::Mat frame_raw;
        cv::Mat frame_rgb;
        cv::Mat frame_gray;
        cv::Mat frame_treshold;
        cv::Mat frame_overlay;
        std::map<int, cv::Mat> marker_poses;
        bool flip_lr, flip_ud;
        bool video_file_playback;
        double framerate;
        double threshold;

        void update_frame();
        Ref<Image> mat_to_image(cv::Mat mat);
        int subpixSampleSafe(const cv::Mat &pSrc, const cv::Point2f &p);
        void computeStrip(cv::Point *centerPoint, StripDimensions *strip, cv::Mat *outImagePixelStrip, bool drawOnOverlay);
        cv::Mat calculateStripDimensions(double dx, double dy, StripDimensions &st);
        void calculateSubpixEdgePoint(cv::Point subdivisionPoint, cv::Point line, cv::Point2f &out_subpix_edge_points, bool draw_on_overlay);
        std::array<cv::Point2f, 4> calculateSubpixCorners(float subpix_line_params[16], bool draw_on_overlay);
        int getMarkerId(cv::Mat frame_src, std::array<cv::Point2f, 4> subpix_corners, bool draw_marker_id);
        cv::Mat getMarkerPose(std::array<cv::Point2f, 4> subpixel_corners);

    protected:
        static void _bind_methods();

    public:
        CVCamera();
        ~CVCamera();

        void open(int device, int width, int height);
        void open_file(String path);
        void close();
        Ref<Image> get_image();
        Ref<Image> get_gray_image();
        Ref<Image> get_threshold_image();
        Ref<Image> get_overlay_image();
        void flip(bool flip_lr, bool flip_ud);
        double get_framerate() const;
        void set_threshold(double threshold);
        int find_rectangles(bool draw_on_overlay);
        godot::Transform3D get_marker_transform(int marker_id);
        bool has_marker_transform(int marker_id);
        TypedArray<int> get_all_marker_ids() const;
    };
    
} // namespace godot

#endif