package co.edu.unal.modev.generator.nodejs.repository

import co.edu.unal.modev.repository.repositoryDsl.Repository
import co.edu.unal.modev.entity.entityDsl.Entity

class GenerateRepository {
	
	def generate(Repository repository)'''
		class «repository.name»{
			
		«var entity = repository.belongsTo as Entity»
		«System::out.println(entity)»
		
		var «entity.name» = new Entity();
			
		}
	'''
}