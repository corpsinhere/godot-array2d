class_name Array2D

## A 2D array. If you want a typed array see the instructions in array2d_int.gd 

var _internal: Array					# Linear list of all items for internal use
var size: Vector2i						# [column count, row count]
var type								# For handling default values; if this script is altered to use a typed array, give this variable that type


# Constructs empty with size a_size
func _init(a_size: Vector2i) -> void:
	size = a_size
	_internal = []
	_internal.resize(size.x * size.y)


# Rebuild self from a set of rows (arrays)
func construct_from_rows(a_row_set: Array[Array]):
	var t_width: int = 0
	var t_height : int = a_row_set.size()
	for i_row: Array in a_row_set:
		if not i_row is Array: 
			return
		t_width = maxi(t_width, i_row.size())
	size = Vector2i(t_width, t_height)
	_internal = []
	_internal.resize(size.x * size.y)
	for i_row_index: int in range(a_row_set.size()):
		# This assignment is an aftifact from the typed versions
		var t_row: Array = a_row_set[i_row_index]
		replace_row(i_row_index, t_row)


# Rebuild self from a set of columns (arrays)
func construct_from_columns(a_column_set: Array[Array]):
	var t_width: int = a_column_set.size()
	var t_height : int = 0
	for i_column: Array in a_column_set:
		if not i_column is Array: 
			return
		t_height = maxi(t_height, i_column.size())
	size = Vector2i(t_width, t_height)
	_internal = []
	_internal.resize(size.x * size.y)
	for i_column_index: int in range(a_column_set.size()):
		# This assignment is an aftifact from the typed versions
		var t_column: Array = a_column_set[i_column_index]
		replace_column(i_column_index, t_column)


# Rebuild self using items from a_linear and resizing to a_size
# Note if linear.size() does not match a_size items will be truncated or nulls added
func construct_from_linear(a_linear: Array, a_size: Vector2i):
	var t_linear = a_linear.duplicate()
	t_linear.resize(a_size.x * a_size.y)
	_internal = t_linear
	size = a_size


# Linear list of all items for external use
func linear() -> Array:
	return _internal


# Array of all items organized into row array
func rows() -> Array[Array]:
	var t_rows: Array[Array] = []
	for i_row_index: int in size.y:
		t_rows.append(row(i_row_index))
	return t_rows


# Array constructed of all items in a given row
func row(a_row_index: int) -> Array:
	return slice(Vector2i(0, a_row_index), Vector2i(1, 0))
	#if not is_valid_row_index(a_row_index): return []
	#var t_row: Array = []
	#for i_column_index: int in range(size.x):
		#t_row.append(at_coord(i_column_index, a_row_index))
	#return t_row


# Array of all items organized into column arrays
func columns() -> Array[Array]:
	var t_columns: Array[Array] = []
	for i_column_index: int in size.x:
		t_columns.append(column(i_column_index))
	return t_columns


# Array constructed of all items in a given column
func column(a_column_index: int) -> Array:
	return slice(Vector2i(a_column_index, 0), Vector2i(0, 1))
	#if not is_valid_column_index(a_column_index): return []
	#var t_column: Array = []
	#for i_row_index: int in range(size.y):
		#t_column.append(at_coord(a_column_index, i_row_index))
	#return t_column


# Return a Vector2i of form [-1 to 1, -1 to 1]
func normalized_vector(a_vector: Vector2i) -> Vector2i:
	var t_sign: int = 1 if a_vector.x >= 0 else -1
	var t_x: int = mini(absi(a_vector.x), 1)
	t_x = t_sign * t_x
	t_sign = 1 if a_vector.y >= 0 else -1
	var t_y: int = mini(absi(a_vector.y), 1)
	t_y = t_sign * t_y
	return Vector2i(t_x, t_y)


# Returns a slice starting at a_origin in a_direction until out of bounds
func slice(a_origin: Vector2i, a_direction: Vector2i) -> Array:
	if not is_valid_coord(a_origin): return []
	var t_direction = normalized_vector(a_direction)
	if t_direction == Vector2i(0, 0): return []
	var t_slice: Array = [at(a_origin)]
	var t_max: int = maxi(size.x, size.y)
	var t_coord: Vector2i = Vector2i(a_origin.x, a_origin.y)
	for i_index: int in range(1, t_max):
		t_coord += t_direction
		if not is_valid_coord(t_coord): break
		t_slice.append(at(t_coord))
	return t_slice


# Item at given coordinates
func at(a_coord: Vector2i) -> Variant:
	return at_coord(a_coord.x, a_coord.y)


# Item at given column and row
func at_coord(a_column: int, a_row: int) -> Variant:
	if not is_valid_column_index(a_column) or not is_valid_row_index(a_row):
		return default_value()
	return _internal[a_column + a_row * size.x]


# As it says
func is_valid_coord(a_coord: Vector2i) -> bool:
	return is_valid_column_index(a_coord.x) and is_valid_row_index(a_coord.y)


# As it says
func is_valid_column_index(a_index: int) -> bool:
	return a_index >= 0 and a_index < size.x


# As it says
func is_valid_row_index(a_index: int) -> bool:
	return a_index >= 0 and a_index < size.y


# This one is easy as an appended row is just added on to the end of _internal
func append_row(a_row: Array):
	# We are going to resize the added array to be sure we have the correct number
	# of items and do not want to alter the passed in array
	# Note this means if the new row is too long the extra itmes are ignored
	var t_row: Array = a_row.duplicate()
	t_row.resize(size.x)
	size = Vector2i(size.x, size.y + 1)
	for i_item: Variant in t_row:
		_internal.append(i_item)


func append_column(a_column: Array):
	# We are going to resize the added array to be sure we have the correct number
	# of items and do not want to alter the passed in array
	# Note this means if the new column is too tall the extra items are ignored
	var t_column: Array = a_column.duplicate()
	t_column.resize(size.y)
	var t_internal: Array = []
	for i_index: int in range(size.y):
		t_internal.append_array(row(i_index))
		t_internal.append(t_column[i_index])
	_internal = t_internal
	size = Vector2i(size.x + 1, size.y)


# Maybe this would be useful?
func linear_index_to_coords(a_index: int) -> Vector2i:
	return Vector2i(a_index % size.x, a_index / size.x)


# Replaces item at a_coord with a_item
func put(a_item: Variant, a_coord: Vector2i):
	put_at_coord(a_item, a_coord.x, a_coord.y)


# Replaces item at [a_column, a_row] with a_item
func put_at_coord(a_item: Variant, a_column: int, a_row: int):
	_internal[a_column + a_row * size.x] = a_item


# As it says
func replace_row(a_row_index: int, a_new_row: Array):
	# We are going to resize the new row array to be sure we have the correct number
	# of items and do not want to alter the passed in array
	# Note this means if the new row is too long the extra items are ignored
	var t_row: Array = a_new_row.duplicate()
	t_row.resize(size.x)
	for i_column_index: int in range(mini(size.x, a_new_row.size())):
		put_at_coord(a_new_row[i_column_index], i_column_index, a_row_index)


# As it says
func replace_column(a_column_index: int, a_new_column: Array):
	# We are going to resize the new column array to be sure we have the correct number
	# of items and do not want to alter the passed in array
	# Note this means if the new column is too long the extra items are ignored
	var t_column: Array = a_new_column.duplicate()
	t_column.resize(size.y)
	for i_row_index: int in range(mini(size.y, a_new_column.size())):
		put_at_coord(a_new_column[i_row_index], a_column_index, i_row_index)


# String representation of self
func out():
	var t_rows: Array[Array] = rows()
	for i_row: Array in t_rows:
		print_row(i_row)


# String representation of a_row
func print_row(a_row: Array):
	var t_text: String = ""
	for i_item: Variant in a_row:
		t_text += str(i_item) + " "
	print(t_text)


# For typed arrays e.g. Array[String] we use the hint variable type
func default_value():
	var t_name: String = type_string(typeof(type))
	if t_name == type_string(typeof("")): return ""
	if t_name == type_string(typeof(false)): return false
	if t_name == type_string(typeof(1)): return 0
	if t_name == type_string(typeof(1.0)): return 0.0
	return null
	
	
	
