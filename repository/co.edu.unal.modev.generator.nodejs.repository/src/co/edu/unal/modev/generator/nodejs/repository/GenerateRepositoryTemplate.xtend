package co.edu.unal.modev.generator.nodejs.repository

import co.edu.unal.modev.generator.nodejs.repository.util.RepositoryUtil
import co.edu.unal.modev.repository.repositoryDsl.Repository
import javax.inject.Inject

class GenerateRepositoryTemplate {
	
	@Inject extension RepositoryUtil
	
	def generate(Repository repository)'''
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
	'''
}