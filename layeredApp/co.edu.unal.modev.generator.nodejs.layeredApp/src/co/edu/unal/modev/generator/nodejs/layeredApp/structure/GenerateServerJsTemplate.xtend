package co.edu.unal.modev.generator.nodejs.layeredApp.structure

class GenerateServerJsTemplate {

	def generate() '''
		var express = require("express");
		var passport = require('passport');
		
		//logging config
		var logger = require("./config/logger");
		
		// Load configurations according to the selected environment
		var env = process.env.NODE_ENV || 'development';
		var config = require('./config/config')[env];
		
		var app = express();
		
		// bootstrap database connection and save it in express context
		app.set("models", require("./app/model"));
		var repositoryFactory = require("./app/repository/RepositoryFactory").init(app);
		
		//set some global constants
		app.set("constants", require("./config/constants"));
		
		//bootstrap auth strategies
		//require("./app/auth/")(passport, config, app);
		
		// express settings
		require('./config/express')(app, config, passport);
		
		// Bootstrap routes
		require('./app/route')(app, passport);
		
		//start app on mentioned port
		app.listen(config.app.port);
		
		logger.info('listening on port ' + config.app.port);
			
	'''

}
