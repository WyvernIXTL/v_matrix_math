
//          Copyright Adam McKellar 2023.
// Distributed under the Boost Software License, Version 1.0.
//        (See accompanying file LICENSE  or copy at
//          https://www.boost.org/LICENSE_1_0.txt)

module v_matrix_math

fn test_new_dense_matrix() {
	a := new_dense_matrix[f64](34, 60, -123.456)?
	assert a.row_size() == 34
	assert a.column_size() == 60
	for i in 0..34 {
		for j in 0..60 {
			assert a.get(i, j) == -123.456
		}
	}
}

fn test_new_identity_dense_matrix() {
	a := new_identity_dense_matrix[f64](40, 43)?
	assert a.row_size() == 40
	assert a.column_size() == 43
	for i in 0..a.row_size() {
		for j in 0..a.column_size() {
			assert if i == j { a.get(i, j) == 1 } else { a.get(i, j) == 0 }
		}
	}
} 