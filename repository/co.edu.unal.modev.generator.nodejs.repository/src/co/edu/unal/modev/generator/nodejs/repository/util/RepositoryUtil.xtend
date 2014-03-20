package co.edu.unal.modev.generator.nodejs.repository.util

import co.edu.unal.modev.repository.repositoryDsl.RepositoriesModule
import co.edu.unal.modev.repository.repositoryDsl.Repository
import co.edu.unal.modev.relationalRepository.relationalRepositoryDsl.EntityMapper

class RepositoryUtil {

	final static String REPOSITORY_SUFFIX = "Repository"
	final static String GET_PREFIX = "get"

	def hasEntity(Repository repository) {
		var has = false
		
		if (repository.belongsTo instanceof EntityMapper) {
			has = true
		}
		
		return has
	}

	def getEntity(Repository repository) {
		return (repository.belongsTo as EntityMapper).entity
	}

	def getModelReferenceVariableName(Repository repository) {
		return repository.name.toFirstLower + "ModelReference"
	}

	def getModelVariableName(Repository repository) {
		return repository.name + "Model"
	}

	def getRepositoryFactoryGetterName(Repository repository) {
		return GET_PREFIX + repository.name.toFirstUpper
	}

	def getRepositoryModule(Repository repository) {
		return repository.eContainer as RepositoriesModule
	}

}
