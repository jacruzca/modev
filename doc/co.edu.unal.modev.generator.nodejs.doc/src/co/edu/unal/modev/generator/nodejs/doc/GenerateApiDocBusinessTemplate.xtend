package co.edu.unal.modev.generator.nodejs.doc

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import com.google.inject.Inject

class GenerateApiDocBusinessTemplate {

	@Inject extension TemplateExtensions

	def generate(App app, ConfigCommon configCommon) '''
		/**
		 * Exports the resource listing for the Swagger specification v1.2
		 * @module business/api-doc/APIDocBusiness
		 * @see https://github.com/wordnik/swagger-spec
		 */
		
		/**
		 * the apiDoc method export a json object containing the documentation
		 * @param {Request} req the http request
		 * @param {Response} req the http response
		 */
		module.exports.apiDoc = function (req, res) {
		
			var apiDoc = {
				apiVersion: '«app.config.projectConfig.applicationVersion»',
				swaggerVersion: '1.2',
				apis: [
					«FOR routeModule : app.routeLayer.routesModules»
						«FOR resContext : routeModule.resourcesContext SEPARATOR ","»
							{
								path: '«resContext.basePath»',
								description: '«resContext.description»'
							}
						«ENDFOR»
					«ENDFOR»
				],
				info: {
					title: '«app.config.projectConfig.projectName»',
					description: '«app.config.projectConfig.projectDescription»',
					contact: 'jacruzca@unal.edu.co',
					license: 'Apache 2.0'
				}
			};
			
			«startJavaProtectedRegion(getUniqueId("additionalRoutes", configCommon))»
			«endJavaProtectedRegion»
			
			res.status(200).json(apiDoc);
		};
		
	'''

	private def getUniqueId(String id, ConfigCommon config) {
		config.projectName + "_" + config.packageName + "_" + "_business_api_doc_APIDocBusiness_" + id
	}
}
