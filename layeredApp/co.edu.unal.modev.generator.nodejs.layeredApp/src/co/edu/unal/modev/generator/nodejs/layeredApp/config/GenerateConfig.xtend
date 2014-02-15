package co.edu.unal.modev.generator.nodejs.layeredApp.config

import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil
import co.edu.unal.modev.generator.nodejs.route.GenerateRoutesConstantsJsTemplate
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import co.edu.unal.modev.layeredApp.layeredAppDsl.RouteLayer
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

class GenerateConfig {
	
	@Inject private GenerateConfigJsTemplate generateConfigTemplate
	@Inject private GenerateConstantsJsTemplate generateConstantsJsTemplate
	@Inject private GenerateExpressJsTemplate generateExpressJsTemplate
	@Inject private GenerateLoggerJsTemplate generateLoggerJsTemplate
	@Inject private GenerateRoutesConstantsJsTemplate generateRoutesConstantsJsTemplate
	
	@Inject extension LocationsUtil
	@Inject extension LayeredAppUtil
	
	def generate(Resource resource, JavaIoFileSystemAccess fsa){
		
		var app = resource.app as App
		
		//generate config.js
		fsa.generateFile(configJsLocation, generateConfigTemplate.generate(app.config))
		
		//generate constants.js
		fsa.generateFile(constantsJsLocation, generateConstantsJsTemplate.generate)
		
		//generate express.js
		fsa.generateFile(expressJsLocation, generateExpressJsTemplate.generate)
		
		//generate logger.js
		fsa.generateFile(loggerJsLocation, generateLoggerJsTemplate.generate)
		
		var routesLayer = app.routeLayer as RouteLayer
		//generate routesConstants.js
		fsa.generateFile(routesConstantsJsLocation, generateRoutesConstantsJsTemplate.generate(routesLayer.routesModules))
		
	}
	
}