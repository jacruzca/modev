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
import co.edu.unal.modev.route.routeDsl.Route
import com.google.inject.Inject

class GenerateApiDocBusinessTemplate {

	@Inject extension TemplateExtensions

	def generate(App app, ConfigCommon configCommon) '''
		/**
		 * Exports the resource listing for the Swagger specification v1.2
		 * @module business/api-doc/APIDocBusiness
		 * @see https://github.com/wordnik/swagger-spec
		 */
		 
		«startJavaProtectedRegion(getUniqueId("init", configCommon))»
		var env = process.env.NODE_ENV || 'development';
		var config = require('../../../config/config')[env];
		«endJavaProtectedRegion»
		
		/**
		 * the apiDoc method export a json object containing the documentation
		 * @param {Request} req the http request
		 * @param {Response} req the http response
		 */
		module.exports.apiDoc = function (req, res) {
		
			var apiDoc = {
				swagger: '2.0',
				info: {
					description: '«app.config.projectConfig.projectDescription»',
					title: '«app.config.projectConfig.projectName»',
					version: '«app.config.projectConfig.applicationVersion»',
					termsOfService: '«app.config.projectConfig.termsOfService»',
					contact: {
						email: '«app.config.projectConfig.contactEmail»',
					},
					"license": {
						"name": '«app.config.projectConfig.licenseName»',
						"url": '«app.config.projectConfig.licenseURL»'
					}
				},
				host: config.app.host + ':' + config.app.inversePort,
				basePath: '«app.config.getBasePath(app.config.projectConfig.environment)»',
				schemes: [
					'http'
				],
				tags: [
					«FOR routeModule : app.routeLayer.routesModules SEPARATOR ","»
						// documentation for the module «routeModule.name»
						«FOR resContext : routeModule.resourcesContext SEPARATOR ","»
							// documentation for the context «resContext.name»
							{
								//the base path of the context
								name: '«resContext.name»',
								//a general description of the context/module
								description: '«resContext.description»'
							}
						«ENDFOR»
					«ENDFOR»
				],
				definitions: {
					«FOR dtoModule : app.businessLayer.dtosModules SEPARATOR ","»
						//the DTO module «dtoModule.name»
						«FOR dto : dtoModule.dtos SEPARATOR ","»
							//the specification of the DTO «dto.name»
							«dto.name»: {
								properties: {
									«FOR attribute : dto.attributes SEPARATOR ","»
										«attribute.name» : {
											«IF attribute.type.dtoType != null»
											"$ref": "#/definitions/«attribute.dtoAttributeType»"
											«ELSE»
											«IF attribute.dtoAttributeType.equals("date")»
											type: "string",
											format: "date"
											«ELSE»
											type: "«attribute.dtoAttributeType»"
											«ENDIF»
											«ENDIF»
										}
									«ENDFOR»
								}
							}
						«ENDFOR»
					«ENDFOR»
				},
				paths: {
					«FOR routeModule : app.routeLayer.routesModules SEPARATOR ","»
						// documentation for the module «routeModule.name»
						«FOR resContext : routeModule.resourcesContext SEPARATOR ","»
							'«resContext.basePath»': {
							«FOR route : resContext.routes SEPARATOR ","»
								'«route.httpVerb.toString.toLowerCase»': {
									tags: [
										'«resContext.name»'
									],
									//a brief description of the operation
									summary: "«route.operation.description»",
									description: "«route.operation.description»",
									operationId: "«route.operation.name»",
									consumes: [
										"application/json"
									],
									produces: [
										"application/json"
									],
									//the list of parameters the operation is accepting
									parameters: [
									«FOR param : route.operation.parameters SEPARATOR ","»
										//documentation for the parameter «param.name»
										{
											//the type according to the HTTP protocol (e.g. body, query)
											in: '«route.getRouteParam(param).httpType.mapHttpType»',
											name: '«param.name»',
											description: '«param.description»',
											//if the parameter is mandatory or not
											required: «IF param.required»true«ELSE»false«ENDIF»,
											«IF route.getRouteParam(param).httpType.equals(HTTP_TYPE.BODY)»
											//the data type of the parameter
											schema: {
												"$ref": "#/definitions/«param.mapOperationParamType»"
											},
											«ELSE»
											//the data type of the parameter
											type: '«param.mapOperationParamType»'
											«ENDIF»
										}
									«ENDFOR»
									],
									//the corresponding response messages for this operation
									responses: {
										«FOR response : route.responseMessages SEPARATOR ","»
											'«response.code»': {
												description: '«response.message»',
												«IF response.code >= 200 && response.code <=299»
													«IF route.operation.many»
													schema: {
														type: 'array',
														items: {
															'$ref': "#/definitions/«route.operation.mapReturnType»"
														}
													}
													«ELSE»
													schema: {
														'$ref': "#/definitions/«route.operation.mapReturnType»"
													}
													«ENDIF»
												«ENDIF»
											}
										«ENDFOR»
									}
								}
							«ENDFOR»
							}
						«ENDFOR»
					«ENDFOR»
				}
			};
			
			«startJavaProtectedRegion(getUniqueId("additionalRoutes", configCommon))»
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
	
	private def getHost(Config config, ENVIRONMENT_LIST environment_LIST) {

		var host = "";

		switch environment_LIST {
			case PRODUCTION:
				host = config.production.host
			case QA:
				host = config.qa.host
			case TEST:
				host = config.test.host
			default:
				host = config.development.host
		}

		host
	}
	
	private def getPort(Config config, ENVIRONMENT_LIST environment_LIST) {

		var host = "";

		switch environment_LIST {
			case PRODUCTION:
				host = String.valueOf(config.production.serverPort)
			case QA:
				host = String.valueOf(config.qa.serverPort)
			case TEST:
				host = String.valueOf(config.test.serverPort)
			default:
				host = String.valueOf(config.development.serverPort)
		}

		host
	}


	private def getUniqueId(String id, ConfigCommon config) {
		config.projectName + "_" + config.packageName + "_" + "_business_api_doc_APIDocBusiness_" + id
	}
}
