package co.edu.unal.modev.generator.nodejs.doc

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import co.edu.unal.modev.route.routeDsl.ResourcesContext
import com.google.inject.Inject
import co.edu.unal.modev.layeredApp.layeredAppDsl.ENVIRONMENT_LIST
import co.edu.unal.modev.layeredApp.layeredAppDsl.Config
import co.edu.unal.modev.business.businessDsl.BusinessParameter
import co.edu.unal.modev.route.routeDsl.Route
import co.edu.unal.modev.generator.nodejs.doc.exceptions.RouteParamNotFoundException

class GenerateApiDocResourceContextBusinessTemplate {

	@Inject extension TemplateExtensions

	def generate(App app, ResourcesContext resourcesContext, ConfigCommon configCommon) '''
		
		/**
		 * Exports the API declaration for «resourcesContext.name» following the Swagger specification v1.2
		 * @see https://github.com/wordnik/swagger-spec
		 */
		module.exports.apiDoc = function (req, res) {
		
			var apiDoc = {
				apiVersion: '«app.config.projectConfig.applicationVersion»',
				swaggerVersion: '1.2',
				basePath: "«app.config.getBasePath(app.config.projectConfig.environment)»",
				resourcePath: "«resourcesContext.basePath»",
				produces: [
					"application/json"
				],
				apis: [
					«FOR route: resourcesContext.routes SEPARATOR ","»
					{
						path: "«route.uri»",
						operations: [
							{
								method: "«route.httpVerb»",
								summary: "«route.operation.description»",
								type: "string",
								nickname: "«route.operation.name»",
								parameters: [
									«FOR param: route.operation.parameters SEPARATOR ","»
									{
										name: "«param.name»",
										description: "«param.description»",
										required: "«IF param.required»true«ELSE»false«ENDIF»",
										type: "«param.type.toString»",
										paramType: "«route.getRouteParam(param).param.name»",
										allowMultiple: false,
									}
									«ENDFOR»
								],
								responseMessages: [
									«FOR response: route.responseMessages SEPARATOR ","»
									{
										code: «response.code»,
										message: "«response.message»"
									}
									«ENDFOR»
								]
							}
						]
					}
					«ENDFOR»
				]
			};
			
			«startJavaProtectedRegion(getUniqueId("additionalRoutes", configCommon, resourcesContext))»
			«endJavaProtectedRegion»
			
			res.status(200).json(apiDoc);
		};
		
	'''
	
	private def getRouteParam(Route route, BusinessParameter param){
		for(routeParam: route.parameters){
			if(routeParam.param.name.equals(param.name)){
				return routeParam
			}
		}
		
		throw new RouteParamNotFoundException("The param "+param.name+" was not found")
	}
	
	private def getBasePath(Config config, ENVIRONMENT_LIST environment_LIST){
		
		var basePath = "";
		
		switch environment_LIST{
			case PRODUCTION:
				basePath = config.production.basePath
			case QA:
				basePath = config.qa.basePath
			case TEST:
				basePath = config.test.basePath
			default:
				basePath = config.development.basePath
		}
		
		basePath
	}

	private def getUniqueId(String id, ConfigCommon config, ResourcesContext resourcesContext) {
		config.projectName + "_" + config.packageName + "_" + "_business_api_doc_" + resourcesContext.name + "DocBusiness_" + id
	}
}
