package co.edu.unal.modev.generator.nodejs.business

import co.edu.unal.modev.business.businessDsl.Business
import co.edu.unal.modev.business.businessDsl.BusinessOperation
import co.edu.unal.modev.route.routeDsl.HTTP_TYPE
import co.edu.unal.modev.route.routeDsl.Route
import org.eclipse.emf.ecore.resource.Resource

class GenerateBusinessTemplate {

	def generate(Business business, Resource resource) '''
		var logger = require("../../../config/logger");
		var constants = require("../../../config/constants");
		var repositoryFactory = require("../../repository/RepositoryFactory").getRepositoryFactory();
		
		// Load configurations according to the selected environment
		var env = process.env.NODE_ENV || 'development';
		var config = require('../../../config/config')[env];
		
		«FOR operation : business.operations»
			
			module.exports.«operation.name» = function(req, res){
				«var route = operation.getRouteForBusinessOperation(resource)»
				«FOR param: route.parameters»
				«switch param.httpType{
					case HTTP_TYPE.ROUTE_PARAM:
						'''var «param.param.name» = req.params.«param.param.name»;'''
					case HTTP_TYPE.BODY:
						'''var «param.param.name» = req.body;'''
					case HTTP_TYPE.QUERY:
						'''var «param.param.name» = req.query.«param.param.name»;'''
				}»
				«ENDFOR»
				
				/* PROTECTED REGION ID(«business.name»_«operation.name») ENABLED START */
				
				/* PROTECTED REGION END */
			}
			
		«ENDFOR»
		
	'''
	
	/**
	 * Search the route that matches the given business operation
	 */
	private def getRouteForBusinessOperation(BusinessOperation businessOperation, Resource resource){
		
		var route = null as Route;
		
		for(e: resource.allContents.toIterable.filter(Route).filter(r | r.operation.equals(businessOperation))){
			route = e;
		}
		
		return route;
	}
}
