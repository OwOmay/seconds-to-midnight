class_name Sequence
extends Resource

@export var spam: Pool
@export var pools: Array[Pool]

var num_since_last_positive := 0

func pick(pool: int) -> Mail:
	randomize()
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
	var retry_count := 0
	if ret_mail == null:
		return
	while ret_mail.score < 0 and pools[pool].num_good() > floor(pools[pool].mails.size() * 0.4) and retry_count < 5 and num_since_last_positive > 3:
		ret_mail = pools[pool].pick()
		retry_count += 1
	if ret_mail.score < 0:
		num_since_last_positive += 1
	pools[pool].mails.erase(ret_mail)
	return ret_mail
