package co.edu.unal.modev.generator.nodejs.layeredApp.structure

import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions

class GenerateServerJsTemplate {
	
	@Inject extension LayeredAppUtil
	@Inject extension TemplateExtensions
	
	def generate(Resource resource, ConfigCommon config) '''
		«startJavaProtectedRegion(getUniqueId("init", config))»
		«var app = resource.app as App»
		var express = require('express');
		var passport = require('passport');
		
		//logging config
		var logger = require('./config/logger');
		
		// Load configurations according to the selected environment
		var env = process.env.NODE_ENV || 'development';
		var config = require('./config/config')[env];
		
		var app = express();
		
		«endJavaProtectedRegion»
		
		«IF app.persistenceLayer.entityModules.size > 0»
		// bootstrap relational database connection and save it in express context
		app.set('models', require('./app/model/indexRelational'));
		«ENDIF»
		
		«IF app.persistenceLayer.documentModules.size > 0»
		//boostrap mongoDB schemas and models
		require('./app/model/indexDocumental');
		«ENDIF»
		
		«startJavaProtectedRegion(getUniqueId("config", config))»
		
		//initialize repositories if required
		require('./app/repository/RepositoryFactory').init(app);
		
		// express settings
		require('./config/express')(app, config, passport);
		
		// Bootstrap routes
		require('./app/route')(app, passport);
		
		//start app on mentioned port
		app.listen(config.app.port);
		
		logger.info('listening on port ' + config.app.port);
		
		«endJavaProtectedRegion»
	'''
	
	private def getUniqueId(String id, ConfigCommon config){
		config.projectName+"_"+config.packageName+"_server"+id
	}
}
