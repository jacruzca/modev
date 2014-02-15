package co.edu.unal.modev.generator.nodejs.repository

import co.edu.unal.modev.generator.nodejs.repository.util.RepositoryUtil
import co.edu.unal.modev.repository.repositoryDsl.Repository
import javax.inject.Inject
import java.util.List
import co.edu.unal.modev.repository.repositoryDsl.RepositoryParameter

class GenerateRepositoryTemplate {
	
	@Inject extension RepositoryUtil
	
	def generate(Repository repository)'''
		var logger = require("../../config/logger");
		/**
		 * This module represents a repository for the table accounts
		 * @param {Sequelize} «repository.belongsTo.name» the model created by sequelize
		 */
		var «repository.modelReferenceVariableName»;
		
		module.exports.init = function(«repository.modelVariableName») {
		
		    «repository.modelReferenceVariableName» = «repository.modelVariableName»;
		    return this;
		}
		
		module.exports.getModel = function() {
		    return «repository.modelReferenceVariableName»;
		}
		
		«FOR operation: repository.operations»
		module.exports.«operation.name» = function(«operation.parameters.operationParameters» options, success, error) {
			
		}
		«ENDFOR»
	'''
	
	private def getOperationParameters(List<RepositoryParameter> params){
		var paramsReturn = "";
		
		for(param: params){
			paramsReturn = paramsReturn + param.name + ", "		
		}
		
		return paramsReturn
	}
}