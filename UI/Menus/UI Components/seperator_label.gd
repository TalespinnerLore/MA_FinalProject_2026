extends Label
func kill_instance():
	self.queue_free()
	print('killing node')
