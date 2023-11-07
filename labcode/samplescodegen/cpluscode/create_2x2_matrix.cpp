#include <array>

using namespace std;

array<array<int, 2>, 2> create_2x2_matrix(int integer) {
  array<array<int, 2>, 2> matrix;

  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 2; j++) {
      matrix[i][j] = integer;
    }
  }

  return matrix;
}