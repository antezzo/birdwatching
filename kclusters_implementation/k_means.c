/* k_means.c
 *
 * Contains implementation of the K-Means algorithm in C.
 *
 * author - Dylan DiBenedetto
 */

#include <stdio.h>

double *calculate_clusters(double data[], int num_points, int num_features, int k) {

  double *centroids = malloc(sizeof(double)*num_features*k);

  int size = num_points * num_features;

  for (int i = 0; i < size; i++) {
    data[i] = 50;
  }



  return data;
}
