import math
class GeoDecision:

	def __init__(self):
		self.Options = []
		self.Paths = []

	def add_Option(self, x):
		if isinstance(x, list) and len(x) == 2:
			x.append(0)
		elif not isinstance(x, list) or not len(x) == 3:
			return
		if all((isinstance(o,int)) for o in x):
			self.Options.append(x)
		return

	def add_Path(self, p):
		if isinstance(p, list):
			if all((isinstance(x,int) and len(p) == 4) for x in p):
				self.Paths.append(p)
		return

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

	def decide_Magnetic(self):
		result = []
		icog = self.decide()
		for p in self.Paths:
			if (p[2]-p[0]) == 0:
				y = icog[1]
				x = p[0]
			elif (p[3]-p[1]) == 0:
				y = p[1]
				x = icog[0]
			else:
				slope = (p[3]-p[1]) / (p[2]-p[0])
				a = self.getVectorLen([p[2],p[3]], icog)
				b = self.getVectorLen(icog, [p[0],p[1]])
				c = self.getVectorLen([p[0],p[1]], [p[2],p[3]])
				t1 = p[1] - (slope*p[0])
				t2 = icog[1] - (-(slope**(-1))*icog[0])
				x = (t2 - t1)/(slope-(-(slope**(-1))))
				y = (slope*x)+t1
				print(x)
				print(y)
				y += p[1]
				x += p[0]
			if len(result) == 0 or self.getVectorLen(icog, [x,y]) < self.getVectorLen(icog, result):
				result = []
				result.append(x)
				result.append(y)
		return result

	def get_Paths(self, x):
		if not isinstance(x, int):
			return
		return self.Paths[x]

	def get_Option(self, x):
		if not isinstance(x, int):
			return
		return self.Options[x]

	def get_OptionLen(self):
		return len(self.Options)

	def get_PathsLen(self):
		return len(self.Paths)

	def getVectorLen(self, a, b):
		return math.sqrt(((b[1]-a[1])**2)+((b[0]-a[0])**2))