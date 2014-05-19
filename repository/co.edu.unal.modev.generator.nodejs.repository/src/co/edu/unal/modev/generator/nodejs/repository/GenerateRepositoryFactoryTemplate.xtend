package co.edu.unal.modev.generator.nodejs.repository

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.generator.nodejs.repository.util.RepositoryUtil
import co.edu.unal.modev.repository.repositoryDsl.Repository
import java.util.List
import javax.inject.Inject

class GenerateRepositoryFactoryTemplate {

	@Inject extension RepositoryUtil
	@Inject extension TemplateExtensions

	def generate(List<Repository> repositories, ConfigCommon configCommon) '''
		«startJavaProtectedRegion(getUniqueId("init", configCommon))»
		var logger = require("../../config/logger");
		var appReference = null;
		
		«endJavaProtectedRegion»
		
		module.exports.init = function(app) {
		    appReference = app;
		};
		
		module.exports.getRepositoryFactory = function() {
			var repositoryFactory = {
				«FOR repository : repositories SEPARATOR ","»
					«IF repository.hasEntity»
						«repository.repositoryFactoryGetterName»: function(){
							return require("./«repository.repositoryModule.name»/«repository.name»").init(appReference.get("models").«repository.entity.name.toFirstUpper»);
							
						}
					«ELSE»
						«repository.repositoryFactoryGetterName»: function(){
							return require("./«repository.repositoryModule.name»/«repository.name»");
						}
					«ENDIF»
				«ENDFOR»
			};
			
			«startJavaProtectedRegion(getUniqueId("additionalRepos", configCommon))»
			«endJavaProtectedRegion»
			
			return repositoryFactory;
		};
		
		«startJavaProtectedRegion(getUniqueId("additional", configCommon))»
		«endJavaProtectedRegion»
	'''

	private def getUniqueId(String id, ConfigCommon config) {
		config.projectName + "_" + config.packageName + "_" + "_repository_RepositoryFactory_" + id
	}
}
