package co.edu.unal.modev.generator.nodejs.entity

import co.edu.unal.modev.entity.entityDsl.Entity

class GenerateEntity {
	
	def generate(Entity entity)'''
		class «entity.name»{
			
		}
	'''
	
}