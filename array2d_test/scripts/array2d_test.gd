extends Node2D

signal test_signal


var test_linear01: Array = ["one", "two", "three", "four", 
		"five", "six", "seven", "eight", 
		"nine", "ten", "eleven", "twelve", 
		"thirteen", ]

var test_linear02: Array = ["one", Vector2(1.0, 0.3), "three", 4, 
		[], "six", "seven", "eight", 
		"nine", 1000.4,]

var test_row_00: Array = ["apple", "beet", "carrot", "daikon", "eggplant"]
var test_row_01: Array = ["ant", "bear", "cat", "dog", "elephant"]
var test_row_02: Array = ["Aluminium", "Boron", "Carbon", "Deuterium", "Eggplantium"]
var test_row_03: Array = ["armchair", "baseball", "can", "drill", "endoscope"]


var test_array2d_00: Array2D
var test_array2d_01: Array2D
var test_array2d_02: Array2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_inputs()
	test_construct_from_rows()
	test_construct_from_columns()
	test_rows()
	test_columns()
	test_at()
	test_append_row()
	test_append_column()
	test_linear_index_to_coords()
	test_put()
	test_replace_row()
	test_replace_column()


func print_inputs():
	print_rich("[color=yellow][b]INPUTS:[/b][/color]")
	print_rich("[color=green][b]test_linear01: [/b][/color]" + str(test_linear01))
	print_rich("[color=green][b]test_linear02: [/b][/color]" + str(test_linear02))
	print_rich("[color=green][b]test_row_00: [/b][/color]" + str(test_row_00))
	print_rich("[color=green][b]test_row_01: [/b][/color]" + str(test_row_01))
	print_rich("[color=green][b]test_row_02: [/b][/color]" + str(test_row_02))
	print_rich("[color=green][b]test_row_03: [/b][/color]" + str(test_row_03))
	print_rich("[color=green][b]test_array_00[/b][/color]")
	get_test_array2d_00().out()
	print_rich("[color=green][b]test_array_01[/b][/color]")
	get_test_array2d_01().out()
	print_rich("[color=green][b]test_array_02[/b][/color]")
	get_test_array2d_02().out()
	print_rich("\n________________")	


# Made empty 
func get_test_array2d_00() -> Array2D:
	test_array2d_00 = Array2D.new(Vector2i(1, 1))
	return test_array2d_00


func get_test_array2d_01() -> Array2D:
	test_array2d_01 = Array2D.new(Vector2i(1, 1))
	test_array2d_01.construct_from_linear(test_linear01, Vector2i(3, 5))
	return test_array2d_01


func get_test_array2d_02() -> Array2D:
	test_array2d_02 = Array2D.new(Vector2i(1, 1))
	test_array2d_02.construct_from_linear(test_linear02, Vector2i(3, 4))
	return test_array2d_02


func test_construct_from_rows():
	print_rich("[color=yellow][b]test_construct_from_rows[/b][/color]\n")
	var t_array: Array2D = get_test_array2d_00()
	t_array.construct_from_rows([test_row_00, test_row_01, test_row_02, test_row_03, ])
	t_array.out()
	print_rich("\n________________")

func test_construct_from_columns():
	print_rich("[color=yellow][b]test_construct_from_columns[/b][/color]\n")
	var t_array: Array2D = get_test_array2d_00()
	t_array.construct_from_columns([test_row_00, test_row_01, test_row_02, test_row_03, ])
	t_array.out()
	print_rich("\n________________")


func test_rows():
	print_rich("[color=yellow][b]test_rows[/b][/color]\n")
	print_rich("[color=yellow][b]Using test_array2d_01[/b][/color]")
	var t_array: Array2D = get_test_array2d_01()
	print_rich(t_array.rows())
	print_rich("\n________________")


func test_columns():
	print_rich("[color=yellow][b]test_columns[/b][/color]\n")
	print_rich("[color=yellow][b]Using test_array2d_01[/b][/color]")
	var t_array: Array2D = get_test_array2d_01()
	print_rich(t_array.columns())
	print_rich("\n________________")


func test_at():
	print_rich("[color=yellow][b]test_at[/b][/color]\n")
	print_rich("[color=yellow][b]Using test_array2d_02[/b][/color]")
	var t_array: Array2D = get_test_array2d_02()
	var t_column: int = randi_range(0, t_array.size.x - 1)
	var t_row: int = randi_range(0, t_array.size.y - 1)
	print_rich("[" + str(t_column) + ", " + str(t_row) + "]: " + str(t_array.at(Vector2i(t_column, t_row))))
	print_rich("\n________________")


func test_append_row():
	print_rich("[color=yellow][b]test_append_row[/b][/color]\n")
	print_rich("[color=yellow][b]Using test_array2d_01[/b][/color]")
	var t_array: Array2D = get_test_array2d_01()
	t_array.append_row(["new00", "new01", "new02", "new03", "new04", "new05", "new06", "new07", ])
	t_array.out()
	print_rich("\n________________")


func test_append_column():
	print_rich("[color=yellow][b]test_append_column[/b][/color]\n")
	print_rich("[color=yellow][b]Using test_array2d_01[/b][/color]")
	var t_array: Array2D = get_test_array2d_01()
	t_array.append_column(["NEW00", "NEW01", "NEW02", "NEW03", "NEW04", "NEW05", "NEW06", "NEW07", ])
	t_array.out()
	print_rich("\n________________")


func test_linear_index_to_coords():
	print_rich("[color=yellow][b]test_linear_index_to_coords[/b][/color]\n")
	var t_array: Array2D = get_test_array2d_02()
	print_rich("[color=yellow][b]Using test_array2d_02[/b][/color]")
	var t_index_00: int = 0
	var t_index_01: int = t_array.linear().size() - 1
	var t_index_02: int = randi_range(1, t_array.linear().size() - 2)
	print_rich("Size: " + str(t_array.size))
	print_rich("index == " + str(t_index_00) + " -> " + str(t_array.linear_index_to_coords(t_index_00)))
	print_rich("index == " + str(t_index_01) + " -> " + str(t_array.linear_index_to_coords(t_index_01)))
	print_rich("index == " + str(t_index_02) + " -> " + str(t_array.linear_index_to_coords(t_index_02)))
	print_rich("\n________________")


func test_put():
	print_rich("[color=yellow][b]test_put[/b][/color]\n")
	print_rich("[color=yellow][b]Using test_array2d_02[/b][/color]")
	var t_array: Array2D = get_test_array2d_02()
	t_array.out()
	print_rich("")
	var t_coord: Vector2i = Vector2i(randi_range(0, t_array.size.x - 1), randi_range(0, t_array.size.y - 1))
	print_rich(t_coord)
	print_rich("--")
	t_array.put("REPLACED", t_coord)
	t_array.out()
	print_rich("\n________________")


func test_replace_row():
	print_rich("[color=yellow][b]test_replace_row[/b][/color]\n")
	print_rich("[color=yellow][b]Using test_array2d_01[/b][/color]")
	var t_array: Array2D = get_test_array2d_01()
	var t_row_index: int = randi_range(0, t_array.size.y - 1)
	print_rich("replaced row index: " + str(t_row_index))
	t_array.replace_row(t_row_index, ["REPLACED", "REPLACED", "REPLACED", "REPLACED", "REPLACED", "REPLACED", "REPLACED", "REPLACED", ])
	t_array.out()
	print_rich("\n________________")


func test_replace_column():
	print_rich("[color=yellow][b]test_replace_column[/b][/color]\n")
	print_rich("[color=yellow][b]Using test_array2d_01[/b][/color]")
	var t_array: Array2D = get_test_array2d_01()
	var t_column_index: int = randi_range(0, t_array.size.x - 1)
	print_rich("replaced column index: " + str(t_column_index))
	t_array.replace_column(t_column_index, ["REPLACED", "REPLACED", "REPLACED", "REPLACED", "REPLACED", "REPLACED", "REPLACED", "REPLACED", ])
	t_array.out()
	print_rich("\n________________")
