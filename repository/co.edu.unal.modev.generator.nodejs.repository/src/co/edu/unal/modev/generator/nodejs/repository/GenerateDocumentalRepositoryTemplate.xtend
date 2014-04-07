package co.edu.unal.modev.generator.nodejs.repository

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.generator.nodejs.repository.util.RepositoryUtil
import co.edu.unal.modev.repository.repositoryDsl.RepositoriesModule
import co.edu.unal.modev.repository.repositoryDsl.Repository
import co.edu.unal.modev.repository.repositoryDsl.RepositoryOperation
import co.edu.unal.modev.repository.repositoryDsl.RepositoryParameter
import java.util.List
import javax.inject.Inject

class GenerateDocumentalRepositoryTemplate {

	@Inject extension RepositoryUtil
	@Inject extension TemplateExtensions

	def generate(Repository repository, ConfigCommon configCommon) '''
		«startJavaProtectedRegion(getUniqueId("init", repository, configCommon))»
		/**
		 * This module represents a repository for the collection «repository.document.name»
		 */
		
		var logger = require("../../../config/logger");
		var mongoose = require('mongoose');
		
		«endJavaProtectedRegion»
		
		var «repository.document.name» = mongoose.model('«repository.document.name»');
		
		«FOR operation : repository.operations»
			«startJavaProtectedRegion(getRepositoryOperationUniqueId("documentation", operation, configCommon))»
			/**
			 * Repository operation «operation.name»
			«FOR param : operation.parameters»			 
				* «param.name» - «param.name»
			«ENDFOR»
			«IF operation.returnType != null»
				* Returns 
			«ENDIF»
			*/
			«endJavaProtectedRegion»
			module.exports.«operation.name» = function(«operation.parameters.operationParameters» options, success, error) {
				«startJavaProtectedRegion(getRepositoryOperationUniqueId("body", operation, configCommon))»
				
				«endJavaProtectedRegion»
			}
		«ENDFOR»
		
		«startJavaProtectedRegion(getUniqueId("additional", repository, configCommon))»
		«endJavaProtectedRegion»
	'''

	private def getOperationParameters(List<RepositoryParameter> params) {
		var paramsReturn = "";

		for (param : params) {
			paramsReturn = paramsReturn + param.name + ", "
		}

		return paramsReturn
	}

	private def getRepositoryOperationUniqueId(String id, RepositoryOperation repositoryOperation, ConfigCommon config) {
		var repository = repositoryOperation.eContainer as Repository

		getUniqueId("_Operation_" + repositoryOperation.name + "_" + id, repository, config)
	}

	private def getUniqueId(String id, Repository repository, ConfigCommon config) {
		var module = repository.repositoryModule as RepositoriesModule

		config.projectName + "_" + config.packageName + "_" + module.name + "_DocumentalRepository_" + repository.name + "_" + id
	}
}
