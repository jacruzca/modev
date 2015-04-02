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
import co.edu.unal.modev.repository.repositoryDsl.RepositoryReturnType
import co.edu.unal.modev.documentRepository.documentRepositoryDsl.DocumentMapper
import co.edu.unal.modev.repository.repositoryDsl.SimpleRepositoryTypes
import co.edu.unal.modev.generator.nodejs.repository.exception.InvalidTypeException
import co.edu.unal.modev.repository.repositoryDsl.RepositoryType

class GenerateDocumentalRepositoryTemplate {

	@Inject extension RepositoryUtil
	@Inject extension TemplateExtensions

	def generate(Repository repository, ConfigCommon configCommon) '''
		/**
		* This module represents a repository for the collection «repository.document.name»
		* @module repository/«repository.repositoryModule.name»/«repository.name»
		*/
		«startJavaProtectedRegion(getUniqueId("init", repository, configCommon))»
		
		var logger = console;
		var mongoose = require('mongoose');
		
		«endJavaProtectedRegion»
		
		var «repository.document.name» = mongoose.model('«repository.document.name»');
		
		«FOR operation : repository.operations»
			
			/**
			 * «operation.description»
			«FOR param : operation.parameters»			 
				* @param {«param.type.paramType»} «param.name» «param.description»
			«ENDFOR»
			«IF operation.returnType != null»
				* @returns {«operation.returnType.operationReturnType»} 
			«ENDIF»
			 */
			module.exports.«operation.name» = function(«operation.parameters.operationParameters») {
				«startJavaProtectedRegion(getRepositoryOperationUniqueId("body", operation, configCommon))»
				
				«endJavaProtectedRegion»
			};
		«ENDFOR»
		
		«startJavaProtectedRegion(getUniqueId("additional", repository, configCommon))»
		«endJavaProtectedRegion»
	'''
	
	private def getParamType(RepositoryType abstractType){
		if(abstractType.entityType != null){
			return (abstractType.entityType as DocumentMapper).document.name
		} else if(abstractType.literalType != null 
				&& !abstractType.literalType.literal.trim.empty){
			return abstractType.literalType.literal
		}else if(abstractType.simple != null){
			return abstractType.simple.simpleType
		}
	}
	
	private def getSimpleType(SimpleRepositoryTypes simpleRepositoryTypes){
		
		var retType = ""
		
		switch simpleRepositoryTypes{
			case BOOLEAN:
				retType = "boolean"
			case DATE:
				retType = "Date"
			case DECIMAL:
				retType = "number"
			case NUMBER:
				retType = "number"
			case STRING:
				retType = "string"
			default:
				retType = ""
		}
		
		if(retType.empty){
			throw new InvalidTypeException("Type not found")
		}
		
		retType
	}
	
	private def getOperationReturnType(RepositoryReturnType returnType){
		if(returnType.repositoryType != null){
			return returnType.repositoryType.paramType
		}else{
			return "undefined"
		}
	}

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

		config.projectName + "_" + config.packageName + "_" + module.name + "_DocumentalRepository_" + repository.name + "_" + id
	}
}
