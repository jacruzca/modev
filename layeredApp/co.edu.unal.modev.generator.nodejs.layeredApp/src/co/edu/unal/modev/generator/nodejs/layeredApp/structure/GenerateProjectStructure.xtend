package co.edu.unal.modev.generator.nodejs.layeredApp.structure

import co.edu.unal.modev.generator.nodejs.layeredApp.config.GenerateConfig
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import com.google.inject.Inject
import java.io.File
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

class GenerateProjectStructure {
	
	@Inject extension LayeredAppUtil
	@Inject extension LocationsUtil
	
	@Inject private GenerateServerJsTemplate generateServerJsTemplate
	@Inject private GeneratePackageJsonTemplate generatePackageJsonTemplate
	@Inject private GenerateConfig generateConfig
	
	def generate(Resource resource, JavaIoFileSystemAccess fsa){
		
		var app = resource.app as App;
		
		var projectName = app.config.projectConfig.projectName
		
		//generate server.js
		fsa.generateFile(projectName.serverJsLocation, generateServerJsTemplate.generate(resource, app.config.configCommon))
		
		//get object which represents the workspace  
		var currentPackagaeJsonURI = fsa.getURI(packageJsonLocation);  
		System::out.println("************** "+currentPackagaeJsonURI);
		System::out.println("************** "+currentPackagaeJsonURI);
		var previousFile = new File(currentPackagaeJsonURI.path);
		if(!previousFile.exists){
			fsa.generateFile(packageJsonLocation, generatePackageJsonTemplate.generate(app.config))	
		}
		//generate package.json
		
		
		//generate config folder
		generateConfig.generate(resource, fsa)
		
	}
	
}