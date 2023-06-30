
//          Copyright Adam McKellar 2023.
// Distributed under the Boost Software License, Version 1.0.
//        (See accompanying file LICENSE  or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module v_matrix_math

pub struct DenseMatrix[T] {
mut:
	matrix [][]T
}

pub fn new_dense_matrix[T](row_size int, column_size int, init T) ?DenseMatrix[T] {
	if !(row_size > 0 && column_size > 0) { return none }
	return DenseMatrix[T]{[][]T{len: row_size, init: []T{len: column_size, init: init}}}
}

pub fn (matrix DenseMatrix[T]) get[T](i int, j int) T {
	return matrix.matrix[i][j]
}

pub fn (mut matrix DenseMatrix[T]) set[T](i int, j int, val T) {
	matrix.matrix[i][j] = val
}

pub fn (matrix DenseMatrix[T]) row_size() int {
	return matrix.matrix.len
}

pub fn (matrix DenseMatrix[T]) column_size() int {
	return matrix.matrix[0].len
}

pub fn new_identity_dense_matrix[T](row_size int, column_size int) ?DenseMatrix[T] {
	mut matrix := new_dense_matrix[T](row_size, column_size, 0.0)?
	for i in 0..row_size {
		for j in 0..column_size {
			if i == j {
				matrix.set[T](i, j, 1.0)
			}
		}
	}
	return matrix
}
