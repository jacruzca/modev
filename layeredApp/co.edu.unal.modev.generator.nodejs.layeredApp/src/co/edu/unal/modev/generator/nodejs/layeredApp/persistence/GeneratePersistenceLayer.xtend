package co.edu.unal.modev.generator.nodejs.layeredApp.persistence

import co.edu.unal.modev.entity.entityDsl.Entity
import co.edu.unal.modev.generator.nodejs.entity.GenerateEntityTemplate
import co.edu.unal.modev.generator.nodejs.entity.GenerateIndexModelTemplate
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil
import co.edu.unal.modev.generator.nodejs.repository.GenerateRepositoryFactoryTemplate
import co.edu.unal.modev.generator.nodejs.repository.GenerateRepositoryTemplate
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import co.edu.unal.modev.layeredApp.layeredAppDsl.PersistenceLayer
import co.edu.unal.modev.repository.repositoryDsl.Repository
import com.google.inject.Inject
import java.util.ArrayList
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import co.edu.unal.modev.relationalRepository.relationalRepositoryDsl.EntityMapper

class GeneratePersistenceLayer {
	
	@Inject extension LayeredAppUtil
	@Inject extension LocationsUtil
	@Inject GenerateEntityTemplate generateEntityTemplate
	@Inject GenerateRepositoryTemplate generateRepositoryTemplate
	@Inject GenerateRepositoryFactoryTemplate generateRepositoryFactoryTemplate
	@Inject GenerateIndexModelTemplate generateIndexModelTemplate
	
	def generate(Resource resource, JavaIoFileSystemAccess fsa){
		
		generateEntities(resource, fsa)
		
		generateIndexModel(resource, fsa)
		
		generateRepositories(resource, fsa)
		
		generateRepositoryFactory(resource, fsa)
		
	}
	
	/**
	 * Generate the index model. This is the setup of sequelize
	 */
	private def generateIndexModel(Resource resource, JavaIoFileSystemAccess fsa) {
		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;
		
		fsa.generateFile(indexModelLocation, generateIndexModelTemplate.generate(persistenceLayer.allEntitiesList))
	}
	
	/**
	 * Returns all registered entities of the application in a list
	 */
	private def getAllEntitiesList(PersistenceLayer persistenceLayer){
		var entityModules = persistenceLayer.entityModules
		
		var entities = new ArrayList<Entity>
		
		for(entityModule: entityModules){
			entities.addAll(entityModule.entities)
		}
		
		return entities
	}
	
	/**
	 * Generates all entities
	 */
	def private generateEntities(Resource resource, JavaIoFileSystemAccess fsa) {
		
		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;
		
		//iterate all entity modules
		for(entitiesModule: persistenceLayer.entityModules){
			//iterate all entities
			for(entity: entitiesModule.entities){
				//generate entity file
				fsa.generateFile(entity.entityLocation, generateEntityTemplate.generate(entity))
			}
		}
	}
	
	/**
	 * Generates all repositories
	 */
	def private generateRepositories(Resource resource, JavaIoFileSystemAccess fsa) {
		
		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;
		
		//iterate all repo modules
		for(repositoriesModule: persistenceLayer.repositoryModules){
			//iterate all repos
			for(repository: repositoriesModule.repositories){
				
				if(repository.belongsTo instanceof EntityMapper){
					System.out.println("Relational!!!")	
				}else{
					System.out.println("NOT Relational! $$$")
				}
				
				
				//generate repo file
				fsa.generateFile(repository.repositoryLocation, generateRepositoryTemplate.generate(repository))
			}
		}
	}
	
	/**
	 * Returns all registered repositories of the application in a list
	 */
	private def getAllRepositoriesList(PersistenceLayer persistenceLayer){
		var repositoryModules = persistenceLayer.repositoryModules
		
		var repositories = new ArrayList<Repository>
		
		for(repositoryModule: repositoryModules){
			repositories.addAll(repositoryModule.repositories)
		}
		
		return repositories
	}
	
	/**
	 * Generate the index model. This is the setup of sequelize
	 */
	private def generateRepositoryFactory(Resource resource, JavaIoFileSystemAccess fsa) {
		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;
		
		fsa.generateFile(repositoryFactoryLocation, generateRepositoryFactoryTemplate.generate(persistenceLayer.allRepositoriesList))
	}
}