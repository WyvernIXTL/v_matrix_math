
//             Copyright Adam McKellar 2023.
// Distributed under the Boost Software License, Version 1.0.
//        (See accompanying file LICENSE  or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module v_matrix_math

pub struct DenseMatrix[T] {
mut:
	matrix [][]T
}

pub fn DenseMatrix.new[T](row_size int, column_size int, init T) DenseMatrix[T] {
	if !(row_size > 0 && column_size > 0) { panic("!(row_size > 0 && column_size > 0)") }
	return DenseMatrix[T]{matrix: [][]T{len: row_size, init: []T{len: column_size, init: init}}}
}

pub fn DenseMatrix.new_from_array[T](array [][]T) DenseMatrix[T] {
	return DenseMatrix[T]{matrix: array}
}

pub fn DenseMatrix.new_from_dense_matrix[T](matrix DenseMatrix[T]) DenseMatrix[T] {
	return DenseMatrix.new_from_array(matrix.matrix.clone())
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

pub fn (matrix DenseMatrix[T]) str() string {
	mut s := ""
	for i in 0..matrix.row_size() {
		for j in 0..matrix.column_size() {
			s += "${matrix.matrix[i][j]:15}"
		}
		s += "\n"
	}
	return s
}

pub fn DenseMatrix.new_identity[T](row_size int, column_size int) DenseMatrix[T] {
	mut matrix := DenseMatrix.new[T](row_size, column_size, T(0))
	for i in 0..row_size {
		for j in 0..column_size {
			if i == j {
				matrix.set[T](i, j, T(1))
			}
		}
	}
	return matrix
}

pub fn (mut matrix DenseMatrix[T]) inplace_scalar_multiplication[T](scalar T) {
	for i in 0..matrix.row_size() {
		for j in 0..matrix.column_size() {
			matrix.matrix[i][j] *= scalar
		}
	}
}

pub fn (left_matrix DenseMatrix[T]) * (right_matrix DenseMatrix[T]) DenseMatrix[T] {
	if left_matrix.column_size() != right_matrix.row_size() {
		panic("left_matrix.column_size() != right_matrix.row_size()")
	}
	mut new_matrix := DenseMatrix.new[T](left_matrix.row_size(), right_matrix.column_size(), T(0))
	for i in 0..new_matrix.row_size() {
		for j in 0..new_matrix.column_size() {
			for x in 0..left_matrix.column_size() {
				new_matrix.matrix[i][j] += left_matrix.matrix[i][x] * right_matrix.matrix[x][j]
			}
		}
	}
	return new_matrix
}

pub fn (left_matrix DenseMatrix[T]) == (right_matrix DenseMatrix[T]) bool {
	mut rval := left_matrix.column_size() == right_matrix.column_size()
	rval = rval && left_matrix.row_size() == right_matrix.row_size()
	for i in 0..left_matrix.row_size() {
		for j in 0..right_matrix.column_size() {
			rval = rval && left_matrix.get(i, j) == right_matrix.get(i, j)
		}
	}
	return rval
}

pub fn (mut matrix DenseMatrix[T]) inplace_lu_no_pivot() {
	if matrix.column_size() < matrix.row_size() {
		panic("matrix.column_size() < matrix.row_size()")
	}
	for row in 0..matrix.row_size() {
		for i in (row+1)..matrix.row_size() {
			matrix.matrix[i][row] /= matrix.matrix[row][row]
			for j in (row+1)..matrix.column_size() {
				matrix.matrix[i][j] -= matrix.matrix[row][j] * matrix.matrix[i][row]
			}
		}
	}
}

pub fn (matrix DenseMatrix[T]) get_l_from_lu[T]() DenseMatrix[T] {
	mut l := DenseMatrix.new_identity[T](matrix.row_size(), matrix.column_size())
	for i in 1..matrix.row_size() {
		for j in 0..i {
			l.set(i, j, matrix.get(i, j))
		}
	}
	return l
}

pub fn (matrix DenseMatrix[T]) get_u_from_lu[T]() DenseMatrix[T] {
	mut u := DenseMatrix.new[T](matrix.row_size(), matrix.column_size(), T(0))
	for i in 0..matrix.row_size() {
		for j in i..matrix.column_size() {
			u.set(i, j, matrix.get(i, j))
		}
	}
	return u
}