class_name Sequence
extends Resource

@export var pools: Array[Pool]

func pick(pool: int) -> Mail:
	if pool >= pools.size():
		return
	var ret_mail := pools[pool].pick()
	if ret_mail == null:
		return
	pools[pool].mails.erase(ret_mail)
	return ret_mail
