package co.edu.unal.modev.generator.nodejs.route

import co.edu.unal.modev.route.routeDsl.RoutesModule
import java.util.List

class GenerateRoutesConstantsJsTemplate {

	def generate(List<RoutesModule> routesModules) '''
		module.exports.getRoutes = function() {
		
		    var routes = {
		        index: '/',
		        «FOR module : routesModules»
		        	«FOR route : module.routes»
		        		«route.name»: "«route.uri»",
		        	«ENDFOR»	
				«ENDFOR»
		    }
		
		    return routes;
		};
	'''
}
