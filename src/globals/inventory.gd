class_name Inventory 
signal inventory_full
signal stack_full

var item_list = []
var max_slots = 5
var max_stack = 10

func _init(slots_number, stack_slot):
	max_slots = slots_number
	max_stack = stack_slot

func _ready():
	connect("inventory_full", self, "_i_full")
	connect("stack_full", self,"_s_full")

func add_item_to(item, value) :
	var template = {"item": null, "ammount": 0}
	var stack = _is_stacked(item)
	if not stack and not _is_inventory_full() :
		template.item = item
		template.ammount = value
		item_list.append(template)
		
	if stack and not _is_stack_full(stack, value) :
		stack.ammount += value
	

func remove_item_from(_item, _value) :
	pass


func _search_item(_item):
	pass


func _get_stacked_item(_item):
	pass

func _is_inventory_full() -> bool:
	if item_list.size() >= max_slots :
		emit_signal("inventory_full")
		return true
	return false


func _is_stack_full(stack, new) -> bool:
	if not stack :
		return false
	if stack.ammount == max_stack or  stack.ammount + new > max_stack : 
		emit_signal("stack_full", stack)
		return true
	return false

func _is_stacked(item):
	if item_list.size() == 0 : 
		return false
	
	for i in item_list :
		if i.item.name == item.name :
			return i
	
	return false


# para fins de debug
func _show_item_list_names() -> void:
	print("----")
	for i in item_list:
		print(i.item.name," | ",i.ammount)


func _save_inventory():
	var file = File.new()
	file.open("user://inventory_data.dat", File.WRITE)
	file.store_var(item_list)
	file.close()

func _i_full():
	print("inventário full")

func _s_full(stack):
	print("Stack full: " , stack.item.name)
