package co.edu.unal.modev.generator.nodejs.business

import co.edu.unal.modev.business.businessDsl.Business
import co.edu.unal.modev.generator.nodejs.business.util.BusinessUtil
import javax.inject.Inject
import co.edu.unal.modev.business.businessDsl.HTTP_TYPE

class GenerateBusinessTemplate {

	@Inject extension BusinessUtil

	def generate(Business business) '''
		var logger = require("../../../config/logger");
		var constants = require("../../../config/constants");
		var repositoryFactory = require("../../repository/RepositoryFactory").getRepositoryFactory();
		
		// Load configurations according to the selected environment
		var env = process.env.NODE_ENV || 'development';
		var config = require('../../../config/config')[env];
		
		«FOR operation : business.operations»
			
			module.exports.«operation.name» = function(req, res){
				«FOR param: operation.parameters»
				«switch param.httpType{
					case HTTP_TYPE.ROUTE_PARAM:
						'''var «param.name» = req.params.«param.name»;'''
					case HTTP_TYPE.BODY:
						'''var «param.name» = req.body;'''
					case HTTP_TYPE.QUERY:
						'''var «param.name» = req.query.«param.name»;'''
				}»
				«ENDFOR»
			}
			
		«ENDFOR»
		
	'''
}
