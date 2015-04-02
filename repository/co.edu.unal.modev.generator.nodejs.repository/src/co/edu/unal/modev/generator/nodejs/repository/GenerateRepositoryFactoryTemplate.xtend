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
		
			/**
			 * A factory module for repositories
			 * @module repository/RepositoryFactory
			 */
		
			«startJavaProtectedRegion(getUniqueId("init", configCommon))»
			var logger = console;
			var appReference = null;
			
			«endJavaProtectedRegion»
			
			/**
			 * Initializes the repository factory passing the express app as dependency
			 * @param {Express} app - The express app
			 */
			module.exports.init = function(app) {
			    appReference = app;
			};
			
			/**
			 * Returns the repository factory object with the appropiate methods
			 * for each repository
			 * @returns {object} a repositoryFactory object
			 */
			module.exports.getRepositoryFactory = function() {
				var repositoryFactory = {
					«FOR repository : repositories SEPARATOR ","»
						«IF repository.hasEntity»
							/**
							 * Creates a new «repository.name» module. It corresponds to
							 * the relational entity «repository.entity.name»
							 * @returns {«repository.name»} a «repository.name» module
							 */
							«repository.repositoryFactoryGetterName»: function(){
								return require("./«repository.repositoryModule.name»/«repository.name»").init(appReference.get("models").«repository.entity.name.toFirstUpper»);
								
							}
						«ELSE»
							/**
							 * Creates a new «repository.name» module. It corresponds to
							 * the document «repository.document.name»
							 * @returns {«repository.name»} a «repository.name» module
							 */
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
