package co.edu.unal.modev.generator.nodejs.layeredApp.rest

import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

class GenerateRESTLayer {
	
	@Inject extension LayeredAppUtil
	@Inject extension LocationsUtil
	
	@Inject GenerateRoutesIndexJsTemplate generateRoutesIndexJsTemplate
	
	def generate(Resource resource, JavaIoFileSystemAccess fsa){
		
		generateRouteIndexJs(resource, fsa)
		
	}
	
	private def generateRouteIndexJs(Resource resource, JavaIoFileSystemAccess fsa) {
		//generate index.js for routes
		fsa.generateFile(routeIndexJsLocation,generateRoutesIndexJsTemplate.generate)
	}
	
	
}