#include "sharedFunction.h"
#include "D:/uvalladolid/DMRIMatlab/mexcode/mathsmex/sphericalHarmonics.h" 
#include "D:/uvalladolid/DMRIMatlab/mexcode/mathsmex/mexToMathsTypes.h"
// Shared function to perform common operations used in different parts of the codebase
int sharedFunction(double* plhs0, double* plhs1, const unsigned int L, const double* Gi, const unsigned int G_) {
    // Check if L is even
    if (L != 2 * (L / 2)) {
        return -1;  // Indicate an error if L is not even
    }

    // Cast G_ to size_t for consistency in representing sizes or counts
    size_t G = (size_t)G_;
    size_t D = 3;  // Dimensionality of the gradient data

    // Extract components from the input gradient directions
    double* gx = new double[G];
    double* gy = new double[G];
    double* gz = new double[G];
    for (unsigned int k = 0; k < G; ++k) {
        gx[k] = Gi[k];
        gy[k] = Gi[k + G];
        gz[k] = Gi[k + 2 * G];
    }

    // If plhs1 is provided, compute associated Legendre polynomials
    if (plhs1 != nullptr) {
        double* buffer = new double[L + 1];
        for (unsigned int k = 0; k < G; ++k) {
            // Compute associated Legendre polynomials for each gradient direction
            shmaths::computeAssociatedLegendrePolynomialsL(gz[k], L, buffer);
            // Store the results in plhs1
            for (unsigned int l = 0; l <= L; ++l)
                plhs1[l * G + k] = buffer[l];
        }
        delete[] buffer;
    }

    // Compute spherical coordinates from Cartesian coordinates
    double* theta = new double[G];
    double* phi = new double[G];
    shmaths::computeSphericalCoordsFromCartesian(gx, gy, gz, theta, phi, G);

    // Clean up memory
    delete[] gx;
    delete[] gy;
    delete[] gz;

    // Compute spherical harmonic (SH) matrix and store the result in plhs0
    shmaths::computeSHMatrixSymmetric(G, theta, phi, L, plhs0);

    // Clean up memory
    delete[] theta;
    delete[] phi;

    return 0;  // Indicate success
}
