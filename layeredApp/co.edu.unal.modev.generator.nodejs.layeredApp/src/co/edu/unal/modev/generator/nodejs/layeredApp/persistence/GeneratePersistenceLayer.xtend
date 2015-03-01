package co.edu.unal.modev.generator.nodejs.layeredApp.persistence

import co.edu.unal.modev.document.documentDsl.Document
import co.edu.unal.modev.entity.entityDsl.Entity
import co.edu.unal.modev.generator.nodejs.document.GenerateDocumentTemplate
import co.edu.unal.modev.generator.nodejs.document.GenerateDocumentalIndexModelTemplate
import co.edu.unal.modev.generator.nodejs.entity.GenerateEntityTemplate
import co.edu.unal.modev.generator.nodejs.entity.GenerateRelationalIndexModelTemplate
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil
import co.edu.unal.modev.generator.nodejs.repository.GenerateRelationalRepositoryTemplate
import co.edu.unal.modev.generator.nodejs.repository.GenerateRepositoryFactoryTemplate
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import co.edu.unal.modev.layeredApp.layeredAppDsl.PersistenceLayer
import co.edu.unal.modev.relationalRepository.relationalRepositoryDsl.EntityMapper
import co.edu.unal.modev.repository.repositoryDsl.Repository
import com.google.inject.Inject
import java.util.ArrayList
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import co.edu.unal.modev.generator.nodejs.repository.GenerateDocumentalRepositoryTemplate
import co.edu.unal.modev.generator.nodejs.repository.test.GenerateDocumentalRepositoryTestTemplate
import co.edu.unal.modev.generator.nodejs.repository.test.GenerateDocumentDataTemplate

class GeneratePersistenceLayer {

	@Inject extension LayeredAppUtil
	@Inject extension LocationsUtil
	@Inject GenerateEntityTemplate generateEntityTemplate
	@Inject GenerateDocumentTemplate generateDocumentTemplate
	@Inject GenerateRelationalRepositoryTemplate generateRelationalRepositoryTemplate
	@Inject GenerateDocumentalRepositoryTemplate generateDocumentalRepositoryTemplate
	@Inject GenerateRepositoryFactoryTemplate generateRepositoryFactoryTemplate
	@Inject GenerateRelationalIndexModelTemplate generateRelationalIndexModelTemplate
	@Inject GenerateDocumentalIndexModelTemplate generateDocumentalIndexModelTemplate
	
	@Inject GenerateDocumentalRepositoryTestTemplate generateDocumentalRepositoryTestTemplate
	@Inject GenerateDocumentDataTemplate generateDocumentDataTemplate

	def generate(Resource resource, JavaIoFileSystemAccess fsa) {

		generateEntities(resource, fsa)

		generateDocuments(resource, fsa)

		generateIndexModel(resource, fsa)

		generateRepositories(resource, fsa)

		generateRepositoryFactory(resource, fsa)
		
		generateRepositoryTests(resource, fsa);

	}

	/**
	 * Generate the index model. This is the setup of sequelize
	 */
	private def generateIndexModel(Resource resource, JavaIoFileSystemAccess fsa) {
		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;

		var allEntities = persistenceLayer.allEntitiesList
		var allDocuments = persistenceLayer.allDocumentsList

		if(persistenceLayer.entityModules.size > 0) {
			fsa.generateFile(relationalIndexModelLocation, generateRelationalIndexModelTemplate.generate(allEntities, app.config.configCommon))
		}

		if(persistenceLayer.documentModules.size > 0) {
			fsa.generateFile(documentalIndexModelLocation, generateDocumentalIndexModelTemplate.generate(allDocuments, app.config.configCommon))
		}

	}

	/**
	 * Returns al registered documents of the app in a list
	 */
	private def getAllDocumentsList(PersistenceLayer persistenceLayer) {
		var documentsModules = persistenceLayer.documentModules

		var documents = new ArrayList<Document>

		for (documentModule : documentsModules) {
			documents.addAll(documentModule.documents)
		}

		documents
	}

	/**
	 * Returns all registered entities of the application in a list
	 */
	private def getAllEntitiesList(PersistenceLayer persistenceLayer) {
		var entityModules = persistenceLayer.entityModules

		var entities = new ArrayList<Entity>

		for (entityModule : entityModules) {
			entities.addAll(entityModule.entities)
		}

		entities
	}

	/**
	 * Generates all entities
	 */
	def private generateEntities(Resource resource, JavaIoFileSystemAccess fsa) {

		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;

		//iterate all entity modules
		for (entitiesModule : persistenceLayer.entityModules) {

			//iterate all entities
			for (entity : entitiesModule.entities) {

				//generate entity file
				fsa.generateFile(entity.entityLocation, generateEntityTemplate.generate(entity))
			}
		}
	}

	/**
	 * Generates all mongoDB documents
	 */
	def private generateDocuments(Resource resource, JavaIoFileSystemAccess fsa) {

		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;

		//iterate all document modules
		for (documentModule : persistenceLayer.documentModules) {

			//iterate all documents
			for (document : documentModule.documents) {

				//generate document file
				fsa.generateFile(document.documentLocation, generateDocumentTemplate.generate(document, app.config.configCommon))
			}
		}
	}

	/**
	 * Generates all repositories (relational and documental)
	 */
	def private generateRepositories(Resource resource, JavaIoFileSystemAccess fsa) {

		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;

		//iterate all repo modules
		for (repositoriesModule : persistenceLayer.repositoryModules) {

			//iterate all repos
			for (repository : repositoriesModule.repositories) {

				//relational repository
				if(repository.belongsTo instanceof EntityMapper) {

					//generate repo file
					fsa.generateFile(repository.repositoryLocation, generateRelationalRepositoryTemplate.generate(repository, app.config.configCommon))

				} else {

					//documental repository
					fsa.generateFile(repository.repositoryLocation, generateDocumentalRepositoryTemplate.generate(repository, app.config.configCommon))
				}

			}
		}
	}

	/**
	 * Returns all registered repositories of the application in a list
	 */
	private def getAllRepositoriesList(PersistenceLayer persistenceLayer) {
		var repositoryModules = persistenceLayer.repositoryModules

		var repositories = new ArrayList<Repository>

		for (repositoryModule : repositoryModules) {
			repositories.addAll(repositoryModule.repositories)
		}

		return repositories
	}

	/**
	 * Generate the repository factory class
	 */
	private def generateRepositoryFactory(Resource resource, JavaIoFileSystemAccess fsa) {
		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;

		fsa.generateFile(repositoryFactoryLocation, generateRepositoryFactoryTemplate.generate(persistenceLayer.allRepositoriesList, app.config.configCommon))
	}
	
	/**
	 * Generate tests for all repositories
	 */
	def generateRepositoryTests(Resource resource, JavaIoFileSystemAccess fsa) {
		var app = resource.app as App;
		var persistenceLayer = app.persistenceLayer;

		//iterate all repo modules
		for (repositoriesModule : persistenceLayer.repositoryModules) {

			//iterate all repos
			for (repository : repositoriesModule.repositories) {

				//relational repository
				if(repository.belongsTo instanceof EntityMapper) {

					//generate repo test file

				} else {

					//documental repository test file
					fsa.generateFile(repository.repositoryUnitTestLocation, generateDocumentalRepositoryTestTemplate.generate(repository, app.config.configCommon))
					
					//document data test
					fsa.generateFile(repository.repositoryUnitDataTestLocation, generateDocumentDataTemplate.generate(repository, app.config.configCommon))
				}

			}
		}
	}
}
