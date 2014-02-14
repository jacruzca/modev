package co.edu.unal.modev.generator.nodejs.layeredApp.rest

class GenerateRoutesIndexJsTemplate {

	def generate() '''
		var logger = require("../../config/logger");
		
		//var roleRoutes = require("./RoleRoutes");
		
		
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
			
			//roleRoutes(app, passport);
		}
	'''
}
