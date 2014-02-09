package co.edu.unal.modev.generator.jee.layeredapp.persistence

import co.edu.unal.modev.entity.entityDsl.EntitiesModule
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

class GeneratePersistenceLayer {
	
	def generate(Resource resource, JavaIoFileSystemAccess fsa){
		
		
		generateEntities(resource, fsa)
		
		
	}
	
	def generateEntities(Resource resource, JavaIoFileSystemAccess fsa) {
		
		//generar entities
		for(entitiesModule:resource.allContents.toIterable.filter(typeof(EntitiesModule))){
			for(entity:entitiesModule.entities){
				System::out.println(entity);
			}	
		}
		
	}
	
}