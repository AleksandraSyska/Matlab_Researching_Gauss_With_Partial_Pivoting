# Matlab_Researching_Gauss_With_Partial_Pivoting

## Description
This MATLAB project focuses on solving a system of linear equations of the form \(Cz = c\), where \(C\) is a complex \(n \times n\) matrix, and \(z\) and \(c\) are complex vectors.
The components are defined as:
- \(C = A + iB\), where \(A\) and \(B\) are real \(n \times n\) matrices.
- \(z = x + iy\), where \(x\) and \(y\) are real \(n \times 1\) vectors (the unknowns).
- \(c = a + ib\), where \(a\) and \(b\) are real \(n \times 1\) vectors.

The project implements a solution using Gaussian Elimination with Partial Pivoting (GEPP).

## How it Works
The core idea is to transform the complex system \(Cz = c\) into an equivalent real system. By substituting \(C = A + iB\), \(z = x + iy\), and \(c = a + ib\) into the equation \(Cz = c\), we get:
\[ (A + iB)(x + iy) = a + ib \]
\[ Ax + iAy + iBx - By = a + ib \]
\[ (Ax - By) + i(Ay + Bx) = a + ib \]

Equating the real and imaginary parts, we obtain a system of two real matrix-vector equations:
\[ Ax - By = a \]
\[ Bx + Ay = b \]

This system can be represented in matrix form using a larger, \(2n \times 2n\) real matrix \(M\):
\[ M \begin{pmatrix} x \\ y \end{pmatrix} = \begin{pmatrix} a \\ b \end{pmatrix} \]
where the matrix \(M\) is defined as:
\[ M = \begin{pmatrix} A & -B \\ B & A \end{pmatrix} \]
The project applies the Gaussian Elimination with Partial Pivoting (GEPP) method to this real-valued block matrix \(M\) to solve for the vectors \(x\) and \(y\), which constitute the real and imaginary parts of the solution vector \(z\).

## Features
- Solves complex linear systems \(Cz=c\).
- Implements Gaussian Elimination with Partial Pivoting (GEPP).
- Transforms the complex system into an equivalent \(2n \times 2n\) real system.
- Includes a comparison of the results obtained with this method against MATLAB's built-in function for solving linear systems (e.g., `mldivide` or `\`) to verify accuracy.

## Usage
To use this project:
1. Ensure you have MATLAB installed.
2. Prepare your complex matrix \(C\) (by defining its real part \(A\) and imaginary part \(B\)) and the complex vector \(c\) (by defining its real part \(a\) and imaginary part \(b\)).
3. Use the provided MATLAB function(s) to form the block matrix \(M\) and the augmented right-hand side vector.
4. The function will apply GEPP to solve for \(x\) and \(y\), and then reconstruct the complex solution \(z = x + iy\).
5. Compare the result with `C\c` in MATLAB.

*(You can add more specific usage examples here, such as sample function calls or scripts demonstrating the setup and solution process.)*

