#include "earcut.hpp"

template <typename T> using Polygon = std::vector<std::vector<T>>;

using Pointf64 = std::pair<double, double>;
using Polygonf64 = Polygon<Pointf64>;

extern "C" {
    struct Arrayui32{
        uint32_t* data;
        int length;
    };
    Arrayui32 u32_triangulate_f64(Pointf64** polygon, int* lengths, int len) {
        Polygonf64 v_polygon(len);
        for(int i = 0; i < len; i++){
            int len2 = lengths[i];
            std::vector<Pointf64> v_line(len2);
            for(int j = 0; j < len2; j++){
                v_line[j] = polygon[i][j];
            }
            v_polygon[i] = v_line;
        }
        std::vector<uint32_t> indices = mapbox::earcut<uint32_t>(v_polygon);
        uint32_t *result;
        int n = indices.size();
        result = new uint32_t[n];
        for(int i = 0; i < n; i++){
            result[i] = indices[i];
        }
        struct Arrayui32 result_array;
        result_array.data = result;
        result_array.length = n / 3; //these are triangles in real life
        return result_array;
    }
}
