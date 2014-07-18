package co.edu.unal.modev.generator.nodejs.doc

import co.edu.unal.modev.business.businessDsl.BusinessOperation
import co.edu.unal.modev.business.businessDsl.BusinessParameter
import co.edu.unal.modev.business.businessDsl.SimpleBusinessTypes
import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.dto.dtoDsl.DtoAttribute
import co.edu.unal.modev.dto.dtoDsl.SimpleDtoTypes
import co.edu.unal.modev.generator.nodejs.doc.exceptions.RouteParamNotFoundException
import co.edu.unal.modev.generator.nodejs.doc.exceptions.UnsupportedTypeException
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import co.edu.unal.modev.layeredApp.layeredAppDsl.Config
import co.edu.unal.modev.layeredApp.layeredAppDsl.ENVIRONMENT_LIST
import co.edu.unal.modev.route.routeDsl.HTTP_TYPE
import co.edu.unal.modev.route.routeDsl.ResourcesContext
import co.edu.unal.modev.route.routeDsl.Route
import com.google.inject.Inject

import static co.edu.unal.modev.business.businessDsl.SimpleBusinessTypes.*
import static co.edu.unal.modev.dto.dtoDsl.SimpleDtoTypes.*
import static co.edu.unal.modev.layeredApp.layeredAppDsl.ENVIRONMENT_LIST.*
import static co.edu.unal.modev.route.routeDsl.HTTP_TYPE.*
import co.edu.unal.modev.route.routeDsl.RoutesModule

class GenerateApiDocResourceContextBusinessTemplate {

	@Inject extension TemplateExtensions

	def generate(App app, ResourcesContext resourcesContext, ConfigCommon configCommon) '''
		«var routesModule = resourcesContext.eContainer as RoutesModule»
		/**
		 * Exports the API declaration for «resourcesContext.name» following the Swagger specification v1.2
		 * @module business/api-doc/«routesModule.name»/«resourcesContext.name»APIDocBusiness
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
				basePath: '«app.config.getBasePath(app.config.projectConfig.environment)»',
				resourcePath: '«resourcesContext.basePath»',
				produces: [
					'application/json'
				],
				apis: [
					«FOR route : resourcesContext.routes SEPARATOR ","»
						//documentation for the route «route.name» with business operation «route.operation.name»
						{
							//the path for this route
							path: "«route.uri»",
							//a set of operations available
							operations: [
								{
									//the http method used for this operation
									method: "«route.httpVerb»",
									//a brief description of the operation
									summary: "«route.operation.description»",
									//the return type of the operation
									type: "«route.operation.mapReturnType»",
									nickname: '«route.operation.name»',
									//the list of parameters the operation is accepting
									parameters: [
										«FOR param : route.operation.parameters SEPARATOR ","»
											//documentation for the parameter «param.name»
											{
												name: '«param.name»',
												description: '«param.description»',
												//if the parameter is mandatory or not
												required: «IF param.required»true«ELSE»false«ENDIF»,
												//the data type of the parameter
												type: '«param.mapOperationParamType»',
												//the type according to the HTTP protocol (e.g. body, query)
												paramType: '«route.getRouteParam(param).httpType.mapHttpType»',
												allowMultiple: false
											}
										«ENDFOR»
									],
									//the corresponding response messages for this operation
									responseMessages: [
										«FOR response : route.responseMessages SEPARATOR ","»
											{
												code: «response.code»,
												message: '«response.message»'
											}
										«ENDFOR»
									]
								}
							]
						}
					«ENDFOR»
				],
				models: {
					«FOR dtoModule : app.businessLayer.dtosModules SEPARATOR ","»
						//the DTO module «dtoModule.name»
						«FOR dto : dtoModule.dtos SEPARATOR ","»
							//the specification of the DTO «dto.name»
							«dto.name»: {
								id: "«dto.name»",
								properties: {
									«FOR attribute : dto.attributes SEPARATOR ","»
										«attribute.name» : {
											type: "«attribute.dtoAttributeType»"
										}
									«ENDFOR»
								}
							}
						«ENDFOR»
					«ENDFOR»
				}
			};
			
			«startJavaProtectedRegion(getUniqueId("additionalRoutes", configCommon, resourcesContext))»
			«endJavaProtectedRegion»
			
			res.status(200).json(apiDoc);
		};
		
	'''

	private def mapHttpType(HTTP_TYPE http_TYPE) {
		switch http_TYPE {
			case BODY:
				return "body"
			case FILE:
				return "form"
			case HEADER:
				return "header"
			case NAMED:
				return "path"
			case QUERY:
				return "query"
			default:
				return "path"
		}
	}

	private def getDtoAttributeType(DtoAttribute dtoAttribute) {
		if(dtoAttribute.type.dtoType != null) {
			return dtoAttribute.type.dtoType.name
		} else if(dtoAttribute.type.literalType != null && !dtoAttribute.type.literalType.trim.empty) {
			return dtoAttribute.type.literalType
		} else if(dtoAttribute.type.simple != null) {
			return dtoAttribute.type.simple.mapSimpleAttributeType
		}

		throw new UnsupportedTypeException("Tipo de dato no soportado")
	}

	private def mapOperationParamType(BusinessParameter businessParameter) {
		if(businessParameter.type.dtoType != null) {
			return businessParameter.type.dtoType.name
		} else if(businessParameter.type.literalType != null && !businessParameter.type.literalType.trim.empty) {
			return businessParameter.type.literalType
		} else if(businessParameter.type.simple != null) {
			return businessParameter.type.simple.mapSimpleReturnType
		}

		throw new UnsupportedTypeException("Tipo de dato no soportado")
	}

	private def mapReturnType(BusinessOperation businessOperation) {
		if(businessOperation.returnType.businessType != null) {
			if(businessOperation.returnType.businessType.dtoType != null) {
				return businessOperation.returnType.businessType.dtoType.name
			} else if(businessOperation.returnType.businessType.literalType != null && !businessOperation.returnType.businessType.literalType.trim.empty) {
				return businessOperation.returnType.businessType.literalType
			} else if(businessOperation.returnType.businessType.simple != null) {
				return businessOperation.returnType.businessType.simple.mapSimpleReturnType
			}
		} else {
			return "undefined"
		}

		throw new UnsupportedTypeException("Tipo de dato no soportado")
	}

	private def mapSimpleReturnType(SimpleBusinessTypes simpleBusinessTypes) {
		switch simpleBusinessTypes {
			case BOOLEAN:
				return "boolean"
			case DATE:
				return "date"
			case NUMBER:
				return "integer"
			case DECIMAL:
				return "float"
			default:
				return "string"
		}
	}

	private def mapSimpleAttributeType(SimpleDtoTypes simpleDtoTypes) {
		switch simpleDtoTypes {
			case BOOLEAN:
				return "boolean"
			case DATE:
				return "date"
			case NUMBER:
				return "integer"
			case DECIMAL:
				return "float"
			default:
				return "string"
		}
	}

	private def getRouteParam(Route route, BusinessParameter param) {
		for (routeParam : route.parameters) {
			if(routeParam.param.name.equals(param.name)) {
				return routeParam
			}
		}

		throw new RouteParamNotFoundException("The param " + param.name + " was not found")
	}

	private def getBasePath(Config config, ENVIRONMENT_LIST environment_LIST) {

		var basePath = "";

		switch environment_LIST {
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
