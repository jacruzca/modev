package co.edu.unal.modev.generator.nodejs.business.test

import co.edu.unal.modev.business.businessDsl.Business
import co.edu.unal.modev.business.businessDsl.BusinessModule
import co.edu.unal.modev.business.businessDsl.BusinessOperation
import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.generator.nodejs.business.util.BusinessUtil
import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource

class GenerateBusinessTestTemplate {

	@Inject extension BusinessUtil
	@Inject extension TemplateExtensions

	def generate(Business business, Resource resource, ConfigCommon config) '''
		«startJavaProtectedRegion(getUniqueId("init", business, config))»
		
		var logger = require("../../../../config/logger");
		var rewire = require("rewire");
		var Promise = require('mpromise');
		
		var chai = require("chai");
		chai.should();
		
		«endJavaProtectedRegion»
		
		describe('«business.name» tests', function () {
		
		«FOR operation : business.operations»
			
				describe('«operation.name» function', function () {
					
					«startJavaProtectedRegion(getBusinessOperationUniqueId("bodyTest", operation, config))»
					it('should be OK', function(done){
						//import dependencies with rewire. Ready to be mocked
						var «business.name.toFirstLower» = rewire("../../../../app/business/«business.businessModule.name»/«business.name»");
						
						 //set expected values
						 var expectedResult = {
						 	foo: 1
						 };
						 
						 var expectedStatus = 200;
			
			            //mock the request
			            var request = {
			            	
			            };
			            
			            //mock the response
			            var response = {
			                status: function (status) {
			                    status.should.be.equal(expectedStatus);
			                    return this;
			                },
			                json: function (obj) {
			                    obj.should.be.equal(expectedResult);
			                    done();
			                }
			            }
			            
			            //mock persistence methods
			            «business.name.toFirstLower».__set__('repositoryFactory', {
			                
			            });
			            
			            //call the method we want to test
			            «business.name.toFirstLower».«operation.name»(request, response);
					});
					«endJavaProtectedRegion»
			});
		«ENDFOR»
		
		});
	'''

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

		config.projectName + "_" + config.packageName + "_" + module.name + "_BusinessTest_" + business.name + "_" + id
	}
}
