void init_array(double* array, int numel) {
    int* zz = new int[2];
  for (int i = 0; i < numel; i++) {
    array[i] = 42;
  }
    delete[] zz;
}