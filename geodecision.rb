class GeoDecision

	def initialize
		@Options = Hash.new
		@Paths = Hash.new
	end

	def add_Option(id, x)
		if x.is_a?(Array) && x.length.between?(2,4)
			(4-x.length).times do
				x.push(0)
			end
		else
			return false
		end
		if x.all? {|o| o.is_a?(Integer)}
			@Options[id] = x
		end
		return true
	end

	def add_Path(id, p, prio=0)
		if p.is_a?(Array)
			if p.all? {|x| x.is_a?(Integer) && p.length == 4 && prio.is_a?(Integer)}
				p.push(prio)
				@Paths[id] = p
				return true
			else
				return false
			end
		else
			return false
		end
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
			if result.length == 0 || getVectorLen(icog, closePoint) < getVectorLen(icog, result)
				result = []
				result.push(closePoint[0])
				result.push(closePoint[1])
			end
		end

		return result
	end

	def decide_Magnetic_best_Path
		result = []
		icog = decide()
		@Paths.each do |key, p|
			closePoint = get_closest_Point_on_Path(icog, p)
			if result.length == 0 || (getVectorLen(icog, closePoint)*((100-p[4])/100) < getVectorLen(icog, result))
				result = []
				result.push(closePoint[0])
				result.push(closePoint[1])
			end
		end
		return result
	end

	def check_distances(center)
		@Options.each do |key, co|
			length = co[3] - getVectorLen([co[0], co[1]], center)
			if length > 0
				center = increaseVector(center, [co[0], co[1]], length)
			end
		end
		return center
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

	def increaseVector(moving, fixed, distance)
		vlength = getVectorLen(moving, fixed)
		rel = distance/vlength
		xadd = (moving[0]-fixed[0])*rel
		yadd = (moving[1]-fixed[1])*rel
		return [moving[0]+xadd, moving[1]+yadd]
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
			t1 = path[1] - (slope*path[0])
			t2 = point[1] - (-(slope**(-1))*point[0])
			x = (t2 - t1)/(slope-(-(slope**(-1))))
			y = (slope*x)+t1
			y += path[1]
			x += path[0]
		end
		if x.between?(path[0], path[2]) && y.between?(path[1], path[3])
			return [x, y]
		else
			if getVectorLen([x, y], [path[0], path[1]]) < getVectorLen([x, y], [path[2], path[3]])
				return [path[0], path[1]]
			else
				return [path[2], path[3]]
			end
		end
	end
	
end