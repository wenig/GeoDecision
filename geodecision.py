class GeoDecision:
	
	def __init__(self):
		self.Options = []

	def add_Option(self, x):
		if isinstance(x, list) and len(x) == 2:
			x.append(0)
		elif not isinstance(x, list) or not len(x) == 3:
			return
		self.Options.append(x)
		return

	def decide_exactly(self):
		y = [0, 0, 0]
		for x in self.Options:
			if x[2] > y[2]:
				y = x
		return str(y[0]) + ", " + str(y[1])

	def middle(self):
		x = 0
		y = 0
		for co in self.Options:
			x = x + co[0]
			y = y + co[1]
		return list([x/len(self.Options), y/len(self.Options)])

	def decide(self):
		middle = self.middle()
		x = 0
		y = 0
		for co in self.Options:
			x = x + co[0]+((co[0]-middle[0])*(co[2]/100))
			y = y + co[1]+((co[1]-middle[1])*(co[2]/100))
		return list([x/len(self.Options), y/len(self.Options)])

	def getOption(self, x):
		if not isinstance(x, int):
			return
		return self.Options[x]

	def getOptionLen(self):
		return len(self.Options)