package co.edu.unal.modev.generator.nodejs.layeredApp.util

import co.edu.unal.modev.entity.entityDsl.Entity
import co.edu.unal.modev.entity.entityDsl.EntitiesModule
import co.edu.unal.modev.repository.repositoryDsl.Repository
import co.edu.unal.modev.repository.repositoryDsl.RepositoriesModule

class LocationsUtil {
	
	final static String PATH_SEPARATOR = "/"
	final static String JS_EXTENSION = ".js"
	
	final static String SERVER = "server"
	final static String APP = "app"
	final static String MODEL = "model"
	final static String REPOSITORY = "repository"
	final static String REPOSITORY_SUFFIX = "Repository"
	final static String REPOSITORY_FACTORY = REPOSITORY_SUFFIX+"Factory"
	
	
	def getServerLocation(){
		return SERVER+PATH_SEPARATOR
	}
	
	def getAppLocation(){
		return serverLocation+APP+PATH_SEPARATOR
	}
	
	def getModelLocation(){
		return appLocation+MODEL+PATH_SEPARATOR
	}
	
	/**
	 * returns the entity location relative to the project
	 */
	def getEntityLocation(Entity entity){
		var location = modelLocation as String
		//add module
		var entitiesModule = entity.eContainer as EntitiesModule
		location = location+ entitiesModule.name+PATH_SEPARATOR
		//add filename
		location = location+ entity.name.toFirstUpper+JS_EXTENSION
		
		return location
	}
	
	def getIndexModelLocation(){
		return modelLocation+"index"+JS_EXTENSION
	}
	
	def getRepositoryLocation(){
		return appLocation+REPOSITORY+PATH_SEPARATOR
	}
	
	/**
	 * returns the entity location relative to the project
	 */
	def getRepositoryLocation(Repository repository){
		var location = repositoryLocation as String
		//add module
		var repositoriesModule = repository.eContainer as RepositoriesModule
		location = location+ repositoriesModule.name+PATH_SEPARATOR
		//add filename
		location = location+ repository.name.toFirstUpper+JS_EXTENSION
		
		return location
	}
	
	def getRepositoryFactoryLocation(){
		return repositoryLocation+REPOSITORY_FACTORY+JS_EXTENSION
	}
	
}