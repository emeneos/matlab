#include <stdlib.h>

int** create_2x2_matrix(int number) {
  // Allocate memory for the 2x2 matrix.
  int** matrix = malloc(sizeof(int*) * 2);
  for (int i = 0; i < 2; i++) {
    matrix[i] = malloc(sizeof(int) * 2);
  }

  // Fill each element of the matrix with the input number.
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 2; j++) {
      matrix[i][j] = number;
    }
  }

  // Return the matrix.
  return matrix;
}