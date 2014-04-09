package co.edu.unal.modev.generator.nodejs.repository.util

import co.edu.unal.modev.document.documentDsl.Document
import co.edu.unal.modev.document.documentDsl.DocumentsModule
import co.edu.unal.modev.documentRepository.documentRepositoryDsl.DocumentMapper
import co.edu.unal.modev.relationalRepository.relationalRepositoryDsl.EntityMapper
import co.edu.unal.modev.repository.repositoryDsl.RepositoriesModule
import co.edu.unal.modev.repository.repositoryDsl.Repository

class RepositoryUtil {

	final static String REPOSITORY_SUFFIX = "Repository"
	final static String GET_PREFIX = "get"

	def hasEntity(Repository repository) {
		var has = false

		if(repository.belongsTo instanceof EntityMapper) {
			has = true
		}

		return has
	}

	def getEntity(Repository repository) {
		return (repository.belongsTo as EntityMapper).entity
	}

	def getDocument(Repository repository) {
		return (repository.belongsTo as DocumentMapper).document
	}

	def getModelReferenceVariableName(Repository repository) {
		return repository.name.toFirstLower + "ModelReference"
	}

	def getModelVariableName(Repository repository) {
		return repository.name + "Model"
	}
	
	def getRepositoryVariableName(Repository repository) {
		return repository.name.toFirstLower
	}

	def getRepositoryFactoryGetterName(Repository repository) {
		return GET_PREFIX + repository.name.toFirstUpper
	}

	def getRepositoryModule(Repository repository) {
		return repository.eContainer as RepositoriesModule
	}
	
	/**
	 * finds the module of a document. 
	 * If it is a sub-doc, a DocumentsModuleNotFoundException exception will be thrown
	 */
	def getDocumentModule(Document document) {
		var module = document.eContainer
		if(module instanceof DocumentsModule) {
			return module
		}

		throw new RuntimeException("The module for the document " + document.name + " was not found");
	}

}
