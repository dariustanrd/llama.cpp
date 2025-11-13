#ifndef STREAMLINE_ADDON_H
#define STREAMLINE_ADDON_H

#include <string_view>
#include <stdint.h>

void streamline_annotation_marker(std::string_view str);
void streamline_annotation_marker_color(std::string_view str, uint32_t color);

#endif