#include <iostream>

#define BLOCK_SIZE_X 32
#define BLOCK_SIZE_Y 1
#define GRID_SIZE_X 32
#define GRID_SIZE_Y 1

using namespace std;

__global__ void matrix_multiplication(float * a, float * b, float *c, int N, int K) {
    int rowIdx = threadIdx.x;

    for (int j = 0; j < N; j++)
        for(int k = 0; k < K; k++)
            c[rowIdx][j] += a[rowIdx][k]*b[k][j];
}

int main() {
    int M = 3, K = 4, N = 5;

    float * a, * b, * c;
    float * d_a, *d_b, *d_c;

    a = new float[M*K];
    b = new float[K*N];
    c = new float[M*N];


    for (int i = 0; i < M*K; i++)
        a[i] = rand() % 10;
    
    for (int i = 0; i < K*N; i++)
        b[i] = rand() % 10;

    for (int i = 0; i < M*N; i++)
        c[i] = 0;
    
    cudaMalloc((void**)&d_a, M * K * sizeof(float));
    cudaMalloc((void**)&d_b, K * N * sizeof(float));
    cudaMalloc((void**)&d_c, M * N * sizeof(float));

    cudaMemcpy(d_a, a, M * K * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, K * N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_c, c, M * N * sizeof(float), cudaMemcpyHostToDevice);
    

    dim3 threads(BLOCK_SIZE_X, BLOCK_SIZE_Y, 1);
    dim3 blocks(GRID_SIZE_X, GRID_SIZE_Y, 1);
    matrix_multiplication<<<threads, blocks>>>(a, b, c, N, K);

    for (int i = 0; i < M; i++){
        for(int j = 0; j < K; j++)
            cout << a[i][j] << " ";
        cout << endl;
    }
    cout << "===================================" << endl;
    for (int i = 0; i < K; i++){
        for(int j = 0; j < N; j++)
            cout << b[i][j] << " ";
        cout << endl;
    }
    cout << "===================================" << endl;
    for (int i = 0; i < M; i++){
        for(int j = 0; j < N; j++)
            cout << c[i][j] << " ";
        cout << endl;
    }
}