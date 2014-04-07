package co.edu.unal.modev.generator.nodejs.layeredApp.config

import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

class GenerateConfig {

	@Inject private GenerateConfigJsTemplate generateConfigTemplate
	@Inject private GenerateExpressJsTemplate generateExpressJsTemplate
	@Inject private GenerateLoggerJsTemplate generateLoggerJsTemplate

	@Inject extension LocationsUtil
	@Inject extension LayeredAppUtil

	def generate(Resource resource, JavaIoFileSystemAccess fsa) {

		var app = resource.app as App

		//generate config.js
		fsa.generateFile(configJsLocation, generateConfigTemplate.generate(app.config, app.config.configCommon))

		//generate express.js
		fsa.generateFile(expressJsLocation, generateExpressJsTemplate.generate(app.config.configCommon))

		//generate logger.js
		fsa.generateFile(loggerJsLocation, generateLoggerJsTemplate.generate)

	}

}
