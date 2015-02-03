class GeoDecision

	def initialize
		@Options = Hash.new
		@Paths = Hash.new
	end

	def add_Option(id, x)
		if x.is_a?(Array) && x.length == 2
			x.push(0)
		elsif not x.is_a?(Array) || x.length != 3
			return
		end
		if x.all? {|o| o.is_a?(Integer)}
			@Options[id] = x
		end
		return
	end

	def add_Path(id, p)
		if p.is_a?(Array)
			if p.all? {|x| x.is_a?(Integer) and p.length == 4}
				@Paths[id] = p
			end
		end
		return
	end

	def middle
		x = 0
		y = 0
		@Options.each do |key, co|
			x = x + co[0]
			y = y + co[1]
		end
		return [x/@Options.length.to_f, y/@Options.length.to_f]
	end

	def decide
		middle = middle()
		x = 0.0
		y = 0.0
		@Options.each do |key, co|
			x = x + co[0]+((co[0]-middle[0])*(co[2]/100))
			y = y + co[1]+((co[1]-middle[1])*(co[2]/100))
		end
		return [x/@Options.length, y/@Options.length]
	end

	def decide_Magnetic
		result = []
		icog = decide()
		@Paths.each do |key, p|
			closePoint = get_closest_Point_on_Path(icog, p)
			if result.length == 0 || (getVectorLen(icog, closePoint)*((100-p[4])/100)) < getVectorLen(icog, result)
				result = []
				result.push(closePoint[0])
				result.push(closePoint[1])
			end
		end
		return result
	end

	def get_Paths(id)
		return @Paths[id]
	end

	def get_Options(id)
		return @Options[id]
	end

	def remove_Paths(id)
		@Paths.delete(id)
	end

	def remove_Options(id)
		@Options.delete(id)
	end

	def get_OptionLen
		return @Options.length
	end

	def get_PathsLen
		return @Paths.length
	end

	def getVectorLen(a, b)
		return Math.sqrt(((b[1]-a[1])**2)+((b[0]-a[0])**2))
	end

	def get_closest_Point_on_Path(point, path)
		if (path[2]-path[0]) == 0
				y = point[1]
				x = path[0]
		elsif (path[3]-path[1]) == 0
			y = path[1]
			x = point[0]
		else
			slope = (path[3]-path[1]) / (path[2]-path[0])
			a = getVectorLen([path[2],path[3]], point)
			b = getVectorLen(point, [path[0],path[1]])
			c = getVectorLen([path[0],path[1]], [path[2],path[3]])
			t1 = path[1] - (slope*path[0])
			t2 = point[1] - (-(slope**(-1))*point[0])
			x = (t2 - t1)/(slope-(-(slope**(-1))))
			y = (slope*x)+t1
			y += path[1]
			x += path[0]
		end
		return [x, y]
	end
end