package co.edu.unal.modev.generator.nodejs.layeredApp.persistence

import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import co.edu.unal.modev.generator.nodejs.entity.GenerateEntity

class GeneratePersistenceLayer {
	
	@Inject extension LayeredAppUtil
	@Inject GenerateEntity generateEntity
	
	def generate(Resource resource, JavaIoFileSystemAccess fsa){
		
		generateEntities(resource, fsa)
		
	}
	
	def private generateEntities(Resource resource, JavaIoFileSystemAccess fsa) {
		
		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;
		
		//iterate all entity modules
		for(entitiesModule: persistenceLayer.entityModules){
			//iterate all entities
			for(entity: entitiesModule.entities){
				//generate entity file
				fsa.generateFile(entity.name+".java", generateEntity.generate(entity));
			}
		}
	}
}