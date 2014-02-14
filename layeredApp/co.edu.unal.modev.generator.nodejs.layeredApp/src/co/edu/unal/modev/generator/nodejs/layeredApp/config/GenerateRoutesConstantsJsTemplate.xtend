package co.edu.unal.modev.generator.nodejs.layeredApp.config

class GenerateRoutesConstantsJsTemplate {
	
	def generate()'''
	module.exports.getRoutes = function() {

	    var routes = {
	        index: '/'
	    }
	
	    return routes;
	};
	'''
}