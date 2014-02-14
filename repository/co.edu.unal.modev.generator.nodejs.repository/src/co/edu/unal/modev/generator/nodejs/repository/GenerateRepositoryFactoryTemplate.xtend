package co.edu.unal.modev.generator.nodejs.repository

import co.edu.unal.modev.generator.nodejs.repository.util.RepositoryUtil
import co.edu.unal.modev.repository.repositoryDsl.Repository
import java.util.List
import javax.inject.Inject
import co.edu.unal.modev.generator.nodejs.entity.util.EntityUtil

class GenerateRepositoryFactoryTemplate {
	
	@Inject extension RepositoryUtil
	@Inject extension EntityUtil
	
	def generate(List<Repository> repositories)'''
	var logger = require("../../config/logger");

	var appReference = null;
	
	module.exports.init = function(app) {
	
	    appReference = app;
	};
	
	module.exports.getRepositoryFactory = function() {
		var repositoryFactory = {
			«FOR repository: repositories»
				«repository.repositoryFactoryGetterName»: function(){
					return require("./«repository.repositoryModule.name»/«repository.name»").init(appReference.get("models").«repository.belongsTo.dbTableName»);
				},
			«ENDFOR»
		}
	}
	'''
}