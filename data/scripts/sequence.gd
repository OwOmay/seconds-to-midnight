class_name Sequence
extends Resource

@export var spam: Pool
@export var pools: Array[Pool]

func pick(pool: int) -> Mail:
	while spam.mails.size() != 0:
		var spam_message := spam.pick()
		spam.mails.erase(spam_message)
		var i := randi() % pools.size()
		while pools[i].mails.size() == 1:
			i = randi() % pools.size()
		pools[i].mails.append(spam_message)
	
	if pool >= pools.size():
		return
	var ret_mail := pools[pool].pick()
	if ret_mail == null:
		return
	pools[pool].mails.erase(ret_mail)
	return ret_mail
