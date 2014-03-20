package co.edu.unal.modev.generator.nodejs.repository

import co.edu.unal.modev.generator.nodejs.repository.util.RepositoryUtil
import co.edu.unal.modev.relationalRepository.relationalRepositoryDsl.EntityMapper
import co.edu.unal.modev.repository.repositoryDsl.Repository
import co.edu.unal.modev.repository.repositoryDsl.RepositoryParameter
import java.util.List
import javax.inject.Inject

class GenerateRepositoryTemplate {

	@Inject extension RepositoryUtil

	def generate(Repository repository) '''
		var logger = require("../../../config/logger");
		/**
		 * This module represents a repository for the table accounts
		 «IF repository.hasEntity»
		 	* @param {Sequelize} «repository.entity.name» the model created by sequelize
		 «ELSE»
		 	* @param {Sequelize} the model created by sequelize
		 «ENDIF»
		 */
		var «repository.modelReferenceVariableName»;
		
		module.exports.init = function(«repository.modelVariableName») {
		
		    «repository.modelReferenceVariableName» = «repository.modelVariableName»;
		    return this;
		}
		
		module.exports.getModel = function() {
		    return «repository.modelReferenceVariableName»;
		}
		
		«FOR operation : repository.operations»
			module.exports.«operation.name» = function(«operation.parameters.operationParameters» options, success, error) {
				/* PROTECTED REGION ID(«repository.name»_«operation.name») ENABLED START */
				
				/* PROTECTED REGION END */
			}
		«ENDFOR»
	'''

	private def getOperationParameters(List<RepositoryParameter> params) {
		var paramsReturn = "";

		for (param : params) {
			paramsReturn = paramsReturn + param.name + ", "
		}

		return paramsReturn
	}
}
