extends Resource


class_name Invent

signal update

@export var slots: Array[InventSlot]

func insert(item: InventItems):
	var itemSlots = slots.filter(func(slot): return slot.item == item) #checks all slots to figure out is there already item in the slot
	if !itemSlots.is_empty(): #if there is item than it ads it there
		itemSlots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null) #if not, than create new slot
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()
