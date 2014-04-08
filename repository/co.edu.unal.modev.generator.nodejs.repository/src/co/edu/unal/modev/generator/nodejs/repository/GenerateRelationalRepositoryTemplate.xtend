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

class GenerateRelationalRepositoryTemplate {

	@Inject extension RepositoryUtil
	@Inject extension TemplateExtensions

	def generate(Repository repository, ConfigCommon configCommon) '''
		«startJavaProtectedRegion(getUniqueId("init", repository, configCommon))»
		/**
		 * This module represents a repository for the table «repository.entity.name»
		 */
		
		var logger = require("../../../config/logger");
		
		«endJavaProtectedRegion»
		
		var «repository.modelReferenceVariableName»;
		
		module.exports.init = function(«repository.modelVariableName») {
		
		    «repository.modelReferenceVariableName» = «repository.modelVariableName»;
		    return this;
		}
		
		module.exports.getModel = function() {
		    return «repository.modelReferenceVariableName»;
		}
		
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
			module.exports.«operation.name» = function(«operation.parameters.operationParameters») {
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
		
		//remove the last comma
		if(!paramsReturn.empty){
			paramsReturn = paramsReturn.substring(0,paramsReturn.length-2);	
		}

		return paramsReturn
	}

	private def getRepositoryOperationUniqueId(String id, RepositoryOperation repositoryOperation, ConfigCommon config) {
		var repository = repositoryOperation.eContainer as Repository

		getUniqueId("_Operation_" + repositoryOperation.name + "_" + id, repository, config)
	}

	private def getUniqueId(String id, Repository repository, ConfigCommon config) {
		var module = repository.repositoryModule as RepositoriesModule

		config.projectName + "_" + config.packageName + "_" + module.name + "_RelationalRepository_" + repository.name + "_" + id
	}
}
