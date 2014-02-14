package co.edu.unal.modev.generator.nodejs.layeredApp.business

import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

class GenerateBusinessLayer {
	
	@Inject extension LayeredAppUtil
	@Inject extension LocationsUtil
	
	def generate(Resource resource, JavaIoFileSystemAccess fsa){
		
		//generateBusinessClasses(resource, fsa)
		
	}
}