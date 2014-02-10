package co.edu.unal.modev.generator.nodejs.layeredApp.util

import org.eclipse.emf.ecore.resource.Resource
import co.edu.unal.modev.layeredApp.layeredAppDsl.App

class LayeredAppUtil {
	
	def getApp(Resource resource){
		return resource.contents.get(0) as App;
	}
	
}