Array.prototype.checkElemNumb = function() {

    for(var i = 0; i < this.length-1; i++)
    {
        if(!(typeof this[i] == "number")){
            return false;
        }
    }

    return true;
}

function GeoDecision () {

    this.Options = [];
    this.Paths = [];

    this.add_Option = function(x) {
        if(x instanceof Array && x.length == 2){
        	x.push(0);
        }else if(!(x instanceof Array) || x.length != 3){
        	return false;
        }
		if(x.checkElemNumb()){
			this.Options.push(x);
			return true;
		}
		return false;
    };

    this.add_Paths = function(p) {
        if(p instanceof Array && p.length == 2 && p.checkElemNumb()){
            this.Paths.push(p);
            return true;
        }
        return false;
    };

    this.middle = function(){
        var x = 0;
        var y = 0;
        for(var co = 0; co < this.Options.length; co++){
            x = x + this.Options[co][0];
            y = y + this.Options[co][1];
        }
        return [x/this.Options.length, y/this.Options.length];
    };

    this.decide = function(){
        var middle = this.middle();
        var x = 0;
        var y = 0;
        for(var co = 0; co < this.Options.length; co++){
            x = x + this.Options[co][0] + ((this.Options[co][0]-middle[0])*(this.Options[co][2]/100))
            y = y + this.Options[co][1] + ((this.Options[co][1]-middle[1])*(this.Options[co][2]/100))
        }
        return [x/this.Options.length, y/this.Options.length];
    };

    this.decide_Magnetic = function(){
        var result = [];
        var icog = this.decide();
        for(var p = 0; p < this.Paths.length; p++){
            var closePoint = this.get_closest_Point_on_Path(icog, p);
            if(result.length == 0 || this.getVectorLen(icog, closePoint) < this.getVectorLen(icog, closePoint)){
                result = [];
                result.push(closePoint[0])
                result.push(closePoint[0])
            }
        return result;
        }
    };

    this.decide_Magnetic_best_Path = function(){
        var result = [];
        var icog = this.decide();
        for(var p = 0; p < this.Paths.length; p++){
            var closePoint = get_closest_Point_on_Path(icog, p);
            if(result.length == 0 || (this.getVectorLen(icog, closePoint)*((100-p[4])/100)) < this.getVectorLen(icog, result)){
                result = [];
                result.push(closePoint[0]);
                result.push(closePoint[1]);
            }
        }
        return result;
    };

    this.get_closest_Point_on_Path = function(point, path){
        if(path[2]-path[0] == 0){
            var y = point[1];
            var x = path[0];
        }else if(path[3]-path[1] == 0){
            var y = path[1];
            var x = point[0];
        }else{
            var slope = (path[3]-path[1]) / (path[2]-path[0]);
            var a = this.getVectorLen([path[2],path[3]], point);
            var b = this.getVectorLen(point, [path[0],path[1]]);
            var c = this.getVectorLen([path[0],path[1]], [path[2],path[3]]);
            var t1 = path[1] - (slope*path[0]);
            var t2 = point[1] - (-(Math.pow(slope,-1))*point[0]);
            var x = (t2 - t1)/(slope - ( -(Math.pow(slope,-1))));
            var y = (slope*x)+t1;
            y = y + path[1];
            x = x + path[0];
        }
        return [x,y];
    };

    this.get_Paths = function(x){
        if(!(x instanceof Number)){
            return false;
        }
        return this.Paths[x];
    };

    this.get_Option = function(x){
        if(!(x instanceof Number)){
            return false;
        }
        return this.Options[x];
    }

    this.get_OptionLen = function(){
        return this.Options.length;
    }

    this.get_PathsLen = function(){
        return this.Paths.length;
    }

    this.getVectorLen = function(a, b){
        return Math.sqrt(Math.pow((b[1]-a[1]),2)+Math.pow((b[0]-a[0]),2));
    }
}

