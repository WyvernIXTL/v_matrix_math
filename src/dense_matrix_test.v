
//             Copyright Adam McKellar 2023.
// Distributed under the Boost Software License, Version 1.0.
//        (See accompanying file LICENSE  or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module v_matrix_math

fn test_new_dense_matrix() {
	a := DenseMatrix.new[f64](34, 60, -123.456)
	assert a.row_size() == 34
	assert a.column_size() == 60
	for i in 0..34 {
		for j in 0..60 {
			assert a.get(i, j) == -123.456
		}
	}
}

fn test_new_identity_dense_matrix() {
	a := DenseMatrix.new_identity[f64](40, 43)
	assert a.row_size() == 40
	assert a.column_size() == 43
	for i in 0..a.row_size() {
		for j in 0..a.column_size() {
			assert if i == j { a.get(i, j) == 1 } else { a.get(i, j) == 0 }
		}
	}
} 

fn test_inplace_scalar_multiplication() {
	mut a := DenseMatrix.new_identity[f64](9, 8)
	assert a.row_size() == 9
	assert a.column_size() == 8
	a.inplace_scalar_multiplication(3.0)
	for i in 0..a.row_size() {
		for j in 0..a.column_size() {
			assert if i == j { a.get(i, j) == 3.0 } else { a.get(i, j) == 0.0 }
		}
	}
}

fn test_matrix_multiplication() {
	a := DenseMatrix.new_from_array([
		[1, 0, 1],
		[2, 1, 1],
		[0, 1, 1],
		[1, 1, 2]
	])
	b := DenseMatrix.new_from_array([
		[1, 2, 1],
		[2, 3, 1],
		[4, 2, 2]
	])

	c := a * b
	
	d := DenseMatrix.new_from_array([
		[5, 4, 3],
		[8, 9, 5],
		[6, 5, 3],
		[11, 9, 6]
	])

	assert c == d

	for i in 0..d.row_size() {
		for j in 0..d.column_size() {
			assert c.get(i, j) == d.get(i, j)
		}
	}
}

fn test_inplace_lu_no_pivot() {
	mut a := DenseMatrix.new_from_array[f64]([
		[1.0, 2.0, 3.0],
		[1.0, 1.0, 1.0],
		[3.0, 3.0, 1.0]
	])

	mut b := DenseMatrix.new_from_dense_matrix(a)

	a.inplace_lu_no_pivot()

	assert b == (a.get_l_from_lu() * a.get_u_from_lu() )
}

fn test_inplace_lu_row_pivot() {
	mut a := DenseMatrix.new_from_array[f64]([
		[1.0, 2.0, 3.0],
		[1.0, 1.0, 1.0],
		[3.0, 3.0, 1.0]
	])

	mut b := DenseMatrix.new_from_dense_matrix(a)

	index := a.inplace_lu_row_pivot()

	c := a.get_l_from_pivoted_lu(index) * a.get_u_from_pivoted_lu(index)

	for i in 0..c.row_size() {
		for j in 0..c.column_size() {
			assert b.get(index[i], j) == c.get(i, j)
		}
	}
}