package co.edu.unal.modev.generator.nodejs.layeredApp.config

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.dbConfig.dbConfigDsl.DB_ENVIRONMENT
import co.edu.unal.modev.dbConfig.dbConfigDsl.DIALECT
import co.edu.unal.modev.layeredApp.layeredAppDsl.Config
import co.edu.unal.modev.mongoConfig.mongoConfigDsl.MONGO_ENVIRONMENT
import com.google.inject.Inject

class GenerateConfigJsTemplate {

	@Inject extension TemplateExtensions

	def generate(Config config, ConfigCommon configCommon) '''
		«startJavaProtectedRegion(getUniqueId("init", configCommon))»
		
		var path = require('path');
		var rootPath = path.normalize(__dirname + '/..');
		
		«endJavaProtectedRegion»
		
		module.exports = {
		  	development: {
		  	 	loggerLevel: "debug",
		  	 	root: rootPath,
		  	 	tokenHeader: "Secure-Token",
		  	 	«var allDbConfigDevelopment = config.dbConfig.filter(configItem|configItem.environment.equals(DB_ENVIRONMENT.DEVELOPMENT)).iterator»
		  	 	«IF allDbConfigDevelopment.hasNext»
		  	 		«var dbConfig = allDbConfigDevelopment.next»
		  	 		db: {
		  	 			host: "«dbConfig.host»",
		  	 			port: "«dbConfig.port»",
		  	 			name: "«dbConfig.database»",
		  	 			user: "«dbConfig.user»",
		  	 			password: "«dbConfig.password»",
		  	 			dialect: "«dbConfig.dialect.dialectForSequelize»"
		  	 		},
		  	 	«ENDIF»
		  	 	«var mongoDevConfig = config.mongoConfig.filter(configItem|configItem.environment.equals(MONGO_ENVIRONMENT.DEVELOPMENT)).head»
		  	 	«IF mongoDevConfig != null»
		  	 		mongo: {
		  	 			host: "«mongoDevConfig.host»",
		  	 			port: "«mongoDevConfig.port»",
		  	 			name: "«mongoDevConfig.database»",
		  	 			user: "«mongoDevConfig.user»",
		  	 			password: "«mongoDevConfig.password»"
		  	 		},
		  	 	«ENDIF»
		  	 	
				app: {
				name: '«config.projectConfig.projectName»',
				port: «config.inferServerPort»,
				tokenExpiration: 3600000*2
				}
			},
			test: {
			loggerLevel: "debug",
			root: rootPath,
			tokenHeader: "Secure-Token",
			db: {
				dialect: "sqlite"
			},
				«var mongoTestConfig = config.mongoConfig.filter(configItem|configItem.environment.equals(MONGO_ENVIRONMENT.TEST)).head»
			 	«IF mongoTestConfig != null»
			 		mongo: {
			 			host: "«mongoTestConfig.host»",
			 			port: "«mongoTestConfig.port»",
			 			name: "«mongoTestConfig.database»",
			 			user: "«mongoTestConfig.user»",
			 			password: "«mongoTestConfig.password»"
			 		},
			 	«ENDIF»
			app: {
			name: '«config.projectConfig.projectName»',
			port: «config.inferServerPort»,
			tokenExpiration: 3600000*2
			}
			},
			production: {
			loggerLevel: "info",
			root: rootPath,
			tokenHeader: "Secure-Token",
			«var allDbConfigProd = config.dbConfig.filter(configItem|configItem.environment.equals(MONGO_ENVIRONMENT.PRODUCTION)).iterator»
			«IF allDbConfigProd.hasNext»
			«var dbConfig = allDbConfigProd.next»
			db: {
				host: "«dbConfig.host»",
				port: "«dbConfig.port»",
				name: "«dbConfig.database»",
				user: "«dbConfig.user»",
				password: "«dbConfig.password»",
				dialect: "«dbConfig.dialect.dialectForSequelize»"
			},
			«ENDIF»
			«var allMongoConfigProd = config.mongoConfig.filter(configItem|configItem.environment.equals(MONGO_ENVIRONMENT.PRODUCTION)).iterator»
			«IF allMongoConfigProd.hasNext»
			«var mongoConfig = allMongoConfigProd.next»
				mongo: {
					host: "«mongoConfig.host»",
					port: "«mongoConfig.port»",
					name: "«mongoConfig.database»",
					user: "«mongoConfig.user»",
					password: "«mongoConfig.password»"
				},
			«ENDIF»
				app: {
			name: '«config.projectConfig.projectName»',
				port: «config.inferServerPort»,
				tokenExpiration: 3600000*2
				}
			}
		};
		
		«startJavaProtectedRegion(getUniqueId("additional", configCommon))»
		«endJavaProtectedRegion»
		
	'''

	private def inferServerPort(Config config) {
		val serverPort = config.projectConfig.serverPort
		if(serverPort > 0) {
			return serverPort
		} else {
			return 3001
		}
	}

	private def getDialectForSequelize(DIALECT dialect) {
		switch dialect {
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

	private def getUniqueId(String id, ConfigCommon configCommon) {
		configCommon.projectName + "_" + configCommon.packageName + "_config_config_" + id
	}
}
