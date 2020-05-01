#include <cstdio>
#include <fstream>
#include <iostream>

#include "accel_designer.h"

int main(void) {
  // パラメータを設定
  const float j_max = 120000;
  const float a_max = 9000;
  const float v_max = 1800;
  const float v_start = 0;
  const float v_target = 600;
  const float distance = 720;
  // 曲線を生成
  ctrl::AccelDesigner ad(j_max, a_max, v_max, v_start, v_target, distance);
  // CSV出力
  for (float t = 0; t < ad.t_end(); t += 0.001f) {
    printf("%f,%f,%f,%f,%f\n", t, ad.j(t), ad.a(t), ad.v(t), ad.x(t));
  }

  return 0;
}
