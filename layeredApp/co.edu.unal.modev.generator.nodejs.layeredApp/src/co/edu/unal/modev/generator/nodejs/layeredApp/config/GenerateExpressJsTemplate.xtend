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
		
		«endJavaProtectedRegion»
		
		«startJavaProtectedRegion(getUniqueId("body", configCommon))»
		module.exports = function (app, config, passport) {
			
			// don't use logger for test env
			if (process.env.NODE_ENV !== 'test') {
				app.use(express.logger('dev'))
			}
		
			// should be placed before express.static
			app.use(express.compress({
				filter: function (req, res) {
				  return /json|text|javascript|css/.test(res.getHeader('Content-Type'))
				},
				level: 9
			}))
		
			app.use(express.favicon())
			app.use(express.static(config.root + '/public'))
		
			// set views path, template engine and default layout
			app.set('views', config.root + '/app/view')
		
			app.configure(function () {
		
				// cookieParser should be above session
				app.use(express.cookieParser(config.app.cookieSecret));
				app.use(express.session({secret: "This is a secret"}));
		
				//bodyParser
				app.use(express.json({limit: '50mb'}));
				app.use(express.urlencoded());
				app.use(express.multipart({uploadDir: config.uploadDir}));
		
				app.use(express.methodOverride());
		
				// use passport session
				   app.use(passport.initialize());
				   //app.use(passport.session())
		
				// routes should be at the last
				app.use(app.router);
		
				// assume "not found" in the error msgs
				// is a 404. this is somewhat silly, but
				// valid, you can do whatever you like, set
				// properties, use instanceof etc.
				app.use(function(err, req, res, next){
				  // treat as 404
				  if (err.message
				    && (~err.message.indexOf('not found')
				    || (~err.message.indexOf('Cast to ObjectId failed')))) {
				    return next();
				  }
		
				  // log it
				  // send emails if you want
				  logger.error(err.stack);
		
				  // error page
				  res.status(500).send(err.stack);
				});
		
				// assume 404 since no middleware responded
				app.use(function(req, res, next){
				  res.status(404).send("Not found");
				});
			});
		
			// development env config
			app.configure('development', function () {
				app.locals.pretty = true
			});
			
			«endJavaProtectedRegion»
		}
	'''

	private def getUniqueId(String id, ConfigCommon configCommon) {
		configCommon.projectName + "_" + configCommon.packageName + "_config_express_" + id
	}
}
