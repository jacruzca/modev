package co.edu.unal.modev.generator.nodejs.repository.util

import co.edu.unal.modev.repository.repositoryDsl.Repository
import co.edu.unal.modev.repository.repositoryDsl.RepositoriesModule

class RepositoryUtil {
	
	final static String REPOSITORY_SUFFIX = "Repository"
	final static String GET_PREFIX = "get"
	
	def getModelReferenceVariableName(Repository repository){
		return repository.name.toFirstLower+"ModelReference"
	}
	
	def getModelVariableName(Repository repository){
		return repository.name+"Model"
	}
	
	def getRepositoryFactoryGetterName(Repository repository){
		return GET_PREFIX+repository.name.toFirstUpper
	}
	
	def getRepositoryModule(Repository repository){
		return repository.eContainer as RepositoriesModule
	}
	
}