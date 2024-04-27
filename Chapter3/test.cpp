#include <iostream>

using namespace std;

void test_func(float * b) {
    cout << "b address: " << &b << endl;
}

int main() {
    int M = 3, K = 4, N = 5;
    float * a, * b, * c;

    a = new float[M*K];

    for (int i = 0; i < M*K; i++)
        a[i] = rand() % 10;
    
    cout << "a address: " << &a << endl;
    test_func(a);
}