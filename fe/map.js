document.getElementById("map").style.height = window.innerHeight+"px";
var map = L.map('map').setView([52.511312814111825, 13.398626708984384], 11);
L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png', {
			maxZoom: 18,
			attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
				'<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
				'Imagery © <a href="http://mapbox.com">Mapbox</a>',
			id: 'examples.map-i875mjb7'
		}).addTo(map);

/*var circle = L.circle([52.511312814111825, 13.398626708984384], 500, {
    color: 'red',
    fillColor: '#f03',
    fillOpacity: 0.5
}).addTo(map).on('click', function(e) {
});*/

function circleGrow(circle, speed){
	var i = 0;
	window.setInterval(function() {
    	circle.setRadius(i);
    	i++
	}, speed);
}