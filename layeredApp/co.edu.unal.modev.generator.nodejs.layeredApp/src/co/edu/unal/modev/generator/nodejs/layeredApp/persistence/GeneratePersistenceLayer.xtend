package co.edu.unal.modev.generator.nodejs.layeredApp.persistence

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import co.edu.unal.modev.entity.entityDsl.EntitiesModule

class GeneratePersistenceLayer {
	
	def generate(Resource resource, JavaIoFileSystemAccess fsa){
		
		
		generateEntities(resource, fsa)
		
		
	}
	
	def generateEntities(Resource resource, JavaIoFileSystemAccess fsa) {
		//generar entities
		for(entitiesModule:resource.allContents.toIterable.filter(typeof(EntitiesModule))){
			System.out.println(entitiesModule);
			for(entity:entitiesModule.entities){
				System.out.println(entity);
			}	
		}
		
	}
	
}