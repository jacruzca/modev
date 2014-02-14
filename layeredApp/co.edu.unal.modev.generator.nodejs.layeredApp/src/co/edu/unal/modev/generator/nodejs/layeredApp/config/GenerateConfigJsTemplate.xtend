package co.edu.unal.modev.generator.nodejs.layeredApp.config

import co.edu.unal.modev.dbConfig.dbConfigDsl.DIALECT
import co.edu.unal.modev.dbConfig.dbConfigDsl.DatabaseConfiguration
import co.edu.unal.modev.dbConfig.dbConfigDsl.ENVIRONMENT
import co.edu.unal.modev.layeredApp.layeredAppDsl.Config
import java.util.List

class GenerateConfigJsTemplate {
	
	def generate(Config config)'''
	var path = require('path');
	var rootPath = path.normalize(__dirname + '/..');
	
	module.exports = {
		«var devConfig = getConfigByEnvironment(config, ENVIRONMENT.DEVELOPMENT)»
	  	development: {
	    	loggerLevel: "debug",
	    	root: rootPath,
	    	db: {
	      		host: "«devConfig.host»",
		      	port: "«devConfig.port»",
		      	name: "«devConfig.database»",
		      	user: "«devConfig.user»",
		      	password: "«devConfig.password»",
		      	dialect: "«devConfig.dialect.dialectForSequelize»"
	    	},
			app: {
	    		name: '«config.projectConfig.projectName»',
	      		port: «config.inferServerPort»,
	      		tokenExpiration: 3600000*2
	    	}
	  	},
	  	test: {
	    	loggerLevel: "debug",
	    	root: rootPath,
	    	db: {
	      		dialect: "sqlite"
	    	},
	    	app: {
	    		name: '«config.projectConfig.projectName»',
	      		port: «config.inferServerPort»,
	      		tokenExpiration: 3600000*2
	    	}
	  	},
	  	«var productionConfig = getConfigByEnvironment(config, ENVIRONMENT.PRODUCTION)»
	  	production: {
	  		loggerLevel: "info",
	    	root: rootPath,
	    	db: {
	      		host: "«productionConfig.host»",
		      	port: "«productionConfig.port»",
		      	name: "«productionConfig.database»",
		      	user: "«productionConfig.user»",
		      	password: "«productionConfig.password»",
		      	dialect: "«productionConfig.dialect.dialectForSequelize»"
	    	},
			app: {
	    		name: '«config.projectConfig.projectName»',
	      		port: «config.inferServerPort»,
	      		tokenExpiration: 3600000*2
	    	}
	  	}
	};
	'''
	
	private def inferServerPort(Config config){
		val serverPort = config.projectConfig.serverPort
		if(serverPort > 0){
			return serverPort
		}else{
			return 3001
		}
	}
	
	private def getDialectForSequelize(DIALECT dialect){
		switch dialect{
			case DIALECT.POSTGRES:
				return "postgres"
			case DIALECT.SQLITE:
				return "sqlite"
			case DIALECT.MARIADB:
				return "mariadb"
			case DIALECT.MARIADB:
				return "mariadb"
			default:
				return "mysql"
		}
	}
	
	private def getConfigByEnvironment(Config config, ENVIRONMENT environment){
		var dbConfigs = config.dbConfig as List<DatabaseConfiguration>
		
		var ret = dbConfigs.get(0) as DatabaseConfiguration
		
		for(dbConfig: dbConfigs){
			if(dbConfig.environment.equals(environment)){
				return dbConfig
				
			}
		}
		
		return ret;
	}
	
}