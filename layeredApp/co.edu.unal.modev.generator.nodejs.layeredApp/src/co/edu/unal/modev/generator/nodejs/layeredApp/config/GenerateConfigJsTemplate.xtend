package co.edu.unal.modev.generator.nodejs.layeredApp.config

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.dbConfig.dbConfigDsl.DIALECT
import co.edu.unal.modev.layeredApp.layeredAppDsl.Config
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
		  	 	«var dbDevConfig = config.development.dbConfig»
		  	 	«IF dbDevConfig != null»
		  	 		db: {
		  	 			host: "«dbDevConfig.host»",
		  	 			port: "«dbDevConfig.port»",
		  	 			name: "«dbDevConfig.database»",
		  	 			user: "«dbDevConfig.user»",
		  	 			password: "«dbDevConfig.password»",
		  	 			dialect: "«dbDevConfig.dialect.dialectForSequelize»"
		  	 		},
		  	 	«ENDIF»
		  	 	«var mongoDevConfig = config.development.mongoConfig»
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
					host: '«config.development.host»',
					port: «config.development.serverPort»,
					inversePort: «config.development.inversePort»,
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
				«var mongoTestConfig = config.test.mongoConfig»
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
					host: '«config.test.host»',
					port: «config.test.serverPort»,
					inversePort: «config.test.inversePort»,
					tokenExpiration: 3600000*2
				}
			},
			qa: {
		  	 	loggerLevel: "info",
		  	 	root: rootPath,
		  	 	tokenHeader: "Secure-Token",
		  	 	«var dbQAConfig = config.qa.dbConfig»
		  	 	«IF dbQAConfig != null»
		  	 		db: {
		  	 			host: "«dbQAConfig.host»",
		  	 			port: "«dbQAConfig.port»",
		  	 			name: "«dbQAConfig.database»",
		  	 			user: "«dbQAConfig.user»",
		  	 			password: "«dbQAConfig.password»",
		  	 			dialect: "«dbQAConfig.dialect.dialectForSequelize»"
		  	 		},
		  	 	«ENDIF»
		  	 	«var mongoQAConfig = config.qa.mongoConfig»
		  	 	«IF mongoQAConfig != null»
		  	 		mongo: {
		  	 			host: "«mongoQAConfig.host»",
		  	 			port: "«mongoQAConfig.port»",
		  	 			name: "«mongoQAConfig.database»",
		  	 			user: "«mongoQAConfig.user»",
		  	 			password: "«mongoQAConfig.password»"
		  	 		},
		  	 	«ENDIF»
		  	 	
				app: {
					name: '«config.projectConfig.projectName»',
					host: '«config.qa.host»',
					port: «config.qa.serverPort»,
					inversePort: «config.qa.inversePort»,
					tokenExpiration: 3600000*2
				}
			},
			production: {
				loggerLevel: "info",
				root: rootPath,
				tokenHeader: "Secure-Token",
				«var allDbConfigProd = config.production.dbConfig»
				«IF allDbConfigProd != null»
				db: {
					host: "«allDbConfigProd.host»",
					port: "«allDbConfigProd.port»",
					name: "«allDbConfigProd.database»",
					user: "«allDbConfigProd.user»",
					password: "«allDbConfigProd.password»",
					dialect: "«allDbConfigProd.dialect.dialectForSequelize»"
				},
			«ENDIF»
			«var allMongoConfigProd = config.production.mongoConfig»
			«IF allMongoConfigProd != null»
				mongo: {
					host: "«allMongoConfigProd.host»",
					port: "«allMongoConfigProd.port»",
					name: "«allMongoConfigProd.database»",
					user: "«allMongoConfigProd.user»",
					password: "«allMongoConfigProd.password»"
				},
			«ENDIF»
				app: {
					name: '«config.projectConfig.projectName»',
					host: '«config.production.host»',
					port: «config.production.serverPort»,
					inversePort: «config.production.inversePort»,
					tokenExpiration: 3600000*2
				}
			}
		};
		
		«startJavaProtectedRegion(getUniqueId("additional", configCommon))»
		«endJavaProtectedRegion»
		
	'''

	private def getDialectForSequelize(DIALECT dialect) {
		switch dialect {
			case DIALECT.POSTGRES:
				return "postgres"
			case DIALECT.SQLITE:
				return "sqlite"
			default:
				return "mysql"
		}
	}

	private def getUniqueId(String id, ConfigCommon configCommon) {
		configCommon.projectName + "_" + configCommon.packageName + "_config_config_" + id
	}
}
