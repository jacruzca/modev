package co.edu.unal.modev.generator.nodejs.repository

import co.edu.unal.modev.generator.nodejs.repository.util.RepositoryUtil
import co.edu.unal.modev.repository.repositoryDsl.Repository
import java.util.List
import javax.inject.Inject

class GenerateRepositoryFactoryTemplate {
	
	@Inject extension RepositoryUtil
	
	def generate(List<Repository> repositories)'''
	var logger = require("../../config/logger");

	var appReference = null;
	
	module.exports.init = function(app) {
	
	    appReference = app;
	};
	
	module.exports.getRepositoryFactory = function() {
		var repositoryFactory = {
			«FOR repository: repositories»
				«IF repository.hasEntity»
				«repository.repositoryFactoryGetterName»: function(){
					return require("./«repository.repositoryModule.name»/«repository.name»").init(appReference.get("models").«repository.entity.name.toFirstUpper»);
					
				},
				«ENDIF»
			«ENDFOR»
		}
		
		return repositoryFactory;
	}
	'''
}