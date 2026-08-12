extends Node

#var BankInventory_IDstack = []
var BankInventory_size = 999
var BankInventory_Resourcestack = [] #to be wiped when entering dungeon.



func Add_to_Bank_Inv_stack(Item:ItemData,stack_size:int):
	var success:=true
	var remaining_stack = stack_size
	for slot in BankInventory_Resourcestack:
		if slot[0] == Item and slot[1] < Item.max_stack:
			var space = Item.max_stack-slot[1]
			if space >= remaining_stack:
				slot[1] += remaining_stack
				remaining_stack = 0
				return [success,remaining_stack]
			elif Item.max_stack > 1:
				slot[1] = Item.max_stack
				remaining_stack -= space
				return [success,remaining_stack]
			if BankInventory_Resourcestack.size() < BankInventory_size and remaining_stack > 0:
				BankInventory_Resourcestack.append([Item,remaining_stack])
				return [success,remaining_stack]
	if BankInventory_Resourcestack.size() < BankInventory_size:
		print("adding to empty inventory slot")
		BankInventory_Resourcestack.append([Item,stack_size])
		remaining_stack = 0
		return [success,remaining_stack]
	success = false
	return [success,remaining_stack]

func Remove_from_Bank_Inv_stack(Item:ItemData,index:int):
	#print(BankInventory_IDstack)
	var success:=false
	#var remaining_stack = stack_size
	if BankInventory_Resourcestack[index][0] == Item:
		print("removed ",Item.ItemName," from inventory")
		BankInventory_Resourcestack.pop_at(index)
		success = true
		
	return success
