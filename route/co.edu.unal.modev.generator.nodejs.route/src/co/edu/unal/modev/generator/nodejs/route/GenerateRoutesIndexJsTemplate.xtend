package co.edu.unal.modev.generator.nodejs.route

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.route.routeDsl.RoutesModule
import com.google.inject.Inject
import java.util.List

class GenerateRoutesIndexJsTemplate {

	@Inject extension TemplateExtensions

	def generate(List<RoutesModule> routesModules, ConfigCommon configCommon) '''
		«FOR module : routesModules»
			var «module.name.toFirstLower» = require("./«module.name»");
		«ENDFOR»
		
		«startJavaProtectedRegion(getUniqueId("init", configCommon))»
		
		var logger = require("../../config/logger");
		var env = process.env.NODE_ENV || 'development';
		var config = require('../../config/config')[env];
		
		var apiDocBusiness = require('../business/api-doc/APIDocBusiness');
		
		«endJavaProtectedRegion»
		
		
		
		/**
		 * Main function to bootstrap all routes of this app
		 * @param app the express app
		 * @param passport the passport object for auth
		 */
		module.exports = function (app, passport) {
			
			«startJavaProtectedRegion(getUniqueId("commonRoute", configCommon))»
			app.all('*', function(req, res, next) {
				res.header("Access-Control-Allow-Origin", "*");
				res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
				res.header("Access-Control-Allow-Headers", "X-Requested-With, "+config.tokenHeader);
		
				if (req.method === 'OPTIONS') {
				      res.writeHead(200, headers);
				      res.end();
				}else{
					next();
				}

			});
			«endJavaProtectedRegion»

			«FOR module : routesModules»
			«module.name.toFirstLower»(app, passport);
			«ENDFOR»


			//routes for the api-doc
			app.get('/api-docs', apiDocBusiness.apiDoc);
	
			«startJavaProtectedRegion(getUniqueId("additionalRoutes", configCommon))»
			«endJavaProtectedRegion»
		}
	'''

	private def getUniqueId(String id, ConfigCommon config) {
		config.projectName + "_" + config.packageName + "_" + "_route_RouteIndex_" + id
	}
}
