package co.edu.unal.modev.generator.nodejs.route

import co.edu.unal.modev.route.routeDsl.RoutesModule
import java.util.List

class GenerateRoutesIndexJsTemplate {

	def generate(List<RoutesModule> routesModules) '''
		var logger = require("../../config/logger");
		
		«FOR module : routesModules»
			var «module.name.toFirstLower» = require("./«module.name.toFirstUpper»");
		«ENDFOR»
		
		
		var constants = require("../../config/constants");
		
		/**
		 * Main function to bootstrap all routes of this app
		 * @param app the express app
		 * @param passport the passport object for auth
		 */
		module.exports = function (app, passport) {
		
			app.all('*', function(req, res, next) {
				res.header("Access-Control-Allow-Origin", "*");
				res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
				res.header("Access-Control-Allow-Headers", "X-Requested-With, "+constants.tokenHeader);
		
				if (req.method === 'OPTIONS') {
				      res.writeHead(200, headers);
				      res.end();
				}else{
					next();
				}
				 
			});
			
			«FOR module : routesModules»
			«module.name.toFirstLower»(app, passport);
			«ENDFOR»
		}
	'''
}
