#include "streamline_addon.h"
#include "streamline_annotate.h"
#include <string>
#include <string_view>

// Add annotation marker code for Streamline
// This is a wrapper around the ANNOTATE_MARKER_STR macro
void streamline_annotation_marker(std::string_view str) {
    // std::string will allocate memory and null-terminate automatically
    std::string buffer(str);
    ANNOTATE_MARKER_STR(buffer.c_str());
}

void streamline_annotation_marker_color(std::string_view str, uint32_t color) {
    // std::string will allocate memory and null-terminate automatically
    std::string buffer(str);
    ANNOTATE_MARKER_COLOR_STR(color, buffer.c_str());
}

