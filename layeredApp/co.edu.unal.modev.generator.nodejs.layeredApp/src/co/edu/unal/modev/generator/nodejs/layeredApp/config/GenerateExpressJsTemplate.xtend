package co.edu.unal.modev.generator.nodejs.layeredApp.config

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import com.google.inject.Inject

class GenerateExpressJsTemplate {

	@Inject extension TemplateExtensions

	def generate(ConfigCommon configCommon) '''
		«startJavaProtectedRegion(getUniqueId("init", configCommon))»
		
		var express = require('express');
		var logger = require("./logger");
		// Load configurations according to the selected environment
		var env = process.env.NODE_ENV || 'development';
		var config = require('./config')[env];
		
		var bodyParser = require('body-parser');
		var methodOverride = require('method-override');
		
		«endJavaProtectedRegion»
		
		«startJavaProtectedRegion(getUniqueId("body", configCommon))»
		module.exports = function (app, config, passport) {

			app.use(bodyParser());
			// parse application/json
			app.use(bodyParser.json())
		    app.use(methodOverride());
		
		    var router = express.Router(); 				// get an instance of the express Router
		
		    // middleware to use for all requests
		    router.use(function (req, res, next) {
		        // do logging
		        console.log('Something is happening.');
		        next(); // make sure we go to the next routes and don't stop here
		    });
		
		    // assume "not found" in the error msgs
		    // is a 404. this is somewhat silly, but
		    // valid, you can do whatever you like, set
		    // properties, use instanceof etc.
		    router.use(function (err, req, res, next) {
		        // log it
		        // send emails if you want
		        logger.error(err.stack);
		
		        // error page
		        res.status(500).send(err.stack);
		    });
		
		    // assume 404 since no middleware responded
		    router.use(function (req, res, next) {
		        res.status(404).send(Error.notFoundError('Resource not found'));
		    });

			
		};
		
		«endJavaProtectedRegion»
	'''

	private def getUniqueId(String id, ConfigCommon configCommon) {
		configCommon.projectName + "_" + configCommon.packageName + "_config_express_" + id
	}
}
