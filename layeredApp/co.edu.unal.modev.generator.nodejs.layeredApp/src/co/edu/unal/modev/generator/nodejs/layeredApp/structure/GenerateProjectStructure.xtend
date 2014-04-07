package co.edu.unal.modev.generator.nodejs.layeredApp.structure

import co.edu.unal.modev.generator.nodejs.layeredApp.config.GenerateConfig
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil

class GenerateProjectStructure {
	
	@Inject extension LayeredAppUtil
	@Inject extension LocationsUtil
	
	@Inject private GenerateServerJsTemplate generateServerJsTemplate
	@Inject private GeneratePackageJsonTemplate generatePackageJsonTemplate
	@Inject private GenerateConfig generateConfig
	
	def generate(Resource resource, JavaIoFileSystemAccess fsa){
		
		var app = resource.app as App;
		
		//generate server.js
		fsa.generateFile(serverJsLocation, generateServerJsTemplate.generate(resource, app.config.configCommon))
		
		//generate package.json
		fsa.generateFile(packageJsonLocation, generatePackageJsonTemplate.generate(app.config))
		
		//generate config folder
		generateConfig.generate(resource, fsa)
		
	}
	
}