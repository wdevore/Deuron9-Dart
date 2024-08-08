class Maths {
// Lerp returns a the value between min and max given t = 0->1
// Typically used in conjunction with random generators
  static double lerp(double min, double max, double t) {
    return min * (1.0 - t) + max * t;
  }

// Linear returns 0->1 for a "value" between min and max.
// Generally used to map from view-space to unit-space
  static double linear(double min, double max, double value) {
    if (max < min) {
      double tmp = max;
      max = min;
      min = tmp;
    }

    if (min < 0.0) {
      return 1.0 - (value - max) / (min - max);
    }

    return (value - min) / (max - min);
  }
}
