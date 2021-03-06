package co.edu.unal.modev.generator.nodejs.business

import co.edu.unal.modev.business.businessDsl.Business
import co.edu.unal.modev.business.businessDsl.BusinessModule
import co.edu.unal.modev.business.businessDsl.BusinessOperation
import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.generator.nodejs.business.exception.RouteNotFoundException
import co.edu.unal.modev.generator.nodejs.business.util.BusinessUtil
import co.edu.unal.modev.route.routeDsl.HTTP_TYPE
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import co.edu.unal.modev.business.businessDsl.BusinessParameter

class GenerateBusinessTemplate {

	@Inject extension BusinessUtil
	@Inject extension TemplateExtensions

	def generate(Business business, Resource resource, ConfigCommon config) '''
		/**
		* This module represents a set of business methods
		* @module business/«business.businessModule.name»/«business.name»
		*/
		«startJavaProtectedRegion(getUniqueId("init", business, config))»
		
		var logger = require('../../../config/logger');
		var repositoryFactory = require('../../repository/RepositoryFactory').getRepositoryFactory();
		
		// Load configurations according to the selected environment
		var env = process.env.NODE_ENV || 'development';
		var config = require('../../../config/config')[env];
		
		«endJavaProtectedRegion»
		
		«FOR operation : business.operations»
			
			/**
			 * «operation.description»
			«FOR param : operation.parameters»	
				* @param {«param.mapOperationParamType»} (HTTP Type: «operation.getMatchingRouteParam(param, resource).httpType.getName») «param.name» «param.description»
			«ENDFOR»
			«IF operation.returnType != null»
				* @returns {«operation.mapReturnType»} 
			«ENDIF»
			 */
			module.exports.«operation.name» = function(req, res){
				«operation.printHTTPParams(resource)»

				«startJavaProtectedRegion(getBusinessOperationUniqueId("body", operation, config))»

				«endJavaProtectedRegion»
			};
			
		«ENDFOR»
		
	'''
	
	def getMatchingRouteParam(BusinessOperation operation, BusinessParameter businessParameter, Resource resource){
		var route = operation.getRouteForBusinessOperation(resource)
		
		for(param: route.parameters){
			if(param.param.name.equals(businessParameter.name)){
				return param
			}
		}
		
		throw new RouteNotFoundException("Route or param not found")
	}
	
	/**
	 * Returns (if present) the variables corresponding to the HTTP params
	 * Printed in order that the developer has easy access to them
	 */
	private def printHTTPParams(BusinessOperation operation, Resource resource) {
		var res = "";
		try {
			var route = operation.getRouteForBusinessOperation(resource)
			
			var totalBodyParams = route.parameters.filter(r | r.httpType.equals(HTTP_TYPE.BODY)).size
			
			for (param : route.parameters) {
				switch param.httpType {
					case HTTP_TYPE.NAMED:
						res = res + '''
						var «param.param.name» = req.params.«param.param.name»;
						'''
					case HTTP_TYPE.BODY:
						if(totalBodyParams > 1){
							res = res + '''
							var «param.param.name» = req.body.«param.param.name»;
							'''	
						}else{
							res = res + '''
							var «param.param.name» = req.body;
							'''
						}
						
					case HTTP_TYPE.QUERY:
						res = res + '''
						var «param.param.name» = req.query.«param.param.name»;
						'''
				}
			}
		} catch(RouteNotFoundException e) {
			res = '''//this operation has no matching route'''
		}

		res
	}

	/**
	 * Search the route that matches the given business operation
	 */
	private def getRouteForBusinessOperation(BusinessOperation businessOperation, Resource resource) {
		var app = resource.layeredApp
		var routeLayer = app.routeLayer

		for (rModule : routeLayer.routesModules) {
			for (rContext : rModule.resourcesContext) {
				for (route : rContext.routes) {
					if(route.operation.equals(businessOperation)) {
						return route
					}
				}	
			}
		}

		throw new RouteNotFoundException("The route for operation: " + businessOperation.name + " was not found")
	}

	/**
	 * Returns a business operation's uniqueId used in protected regions
	 */
	private def getBusinessOperationUniqueId(String id, BusinessOperation businessOperation, ConfigCommon config) {
		var business = businessOperation.eContainer as Business

		getUniqueId(businessOperation.name + "_" + id, business, config)
	}

	/**
	 * Returns a business' uniqueId used in protected regions
	 */
	private def getUniqueId(String id, Business business, ConfigCommon config) {
		var module = business.businessModule as BusinessModule

		config.projectName + "_" + config.packageName + "_" + module.name + "_Business_" + business.name + "_" + id
	}
}
