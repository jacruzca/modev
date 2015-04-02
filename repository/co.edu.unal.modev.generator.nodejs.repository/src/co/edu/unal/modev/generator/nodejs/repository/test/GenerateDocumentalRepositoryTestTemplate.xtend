package co.edu.unal.modev.generator.nodejs.repository.test

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.generator.nodejs.repository.util.RepositoryUtil
import co.edu.unal.modev.repository.repositoryDsl.RepositoriesModule
import co.edu.unal.modev.repository.repositoryDsl.Repository
import co.edu.unal.modev.repository.repositoryDsl.RepositoryOperation
import co.edu.unal.modev.repository.repositoryDsl.RepositoryParameter
import java.util.List
import javax.inject.Inject

class GenerateDocumentalRepositoryTestTemplate {

	@Inject extension RepositoryUtil
	@Inject extension TemplateExtensions

	def generate(Repository repository, ConfigCommon configCommon) '''
		«startJavaProtectedRegion(getUniqueId("init", repository, configCommon))»
		var logger = console;
		var mongoose = require('mongoose');
		var Q = require("q");
		var env = process.env.NODE_ENV || 'test';
		var config = require('../../../../config/config')[env];
		
		var chai = require("chai");
		chai.should();
		chai.use(require("chai-as-promised"));
		
		var repositoryFactory = require("../../../../app/repository/RepositoryFactory").getRepositoryFactory();
		var «repository.repositoryVariableName» = null;
		
		var «repository.name.toFirstLower»Data = require('./data/«repository.name»Data');
		
		
		var initialize = function(){
		
			require('../../../../app/model/«repository.document.documentModule.name»/«repository.document.name»').model();
		
			«repository.repositoryVariableName» = repositoryFactory.«repository.repositoryFactoryGetterName»();
		};
		
		«endJavaProtectedRegion»
		
		/**
		 * Unit tests for the repository «repository.name»
		 */
		 
		describe('«repository.name» tests', function(){
		
			«startJavaProtectedRegion(getUniqueId("config", repository, configCommon))»
			before(function(done){
				mongoose.connect('mongodb://'+config.mongo.host+':'+config.mongo.port+'/'+config.mongo.name+'', function (err, res) {
					if (err) throw err;
		
		            initialize();
		
		            done();
		        });
			});
			
			after(function(done){
		        mongoose.connection.db.dropDatabase(function(){
		            mongoose.connection.close(done);
		        });
		    });
			«endJavaProtectedRegion»
			
			«FOR operation : repository.operations»

				/**
				 * Unit test cases for the operation «operation.name»
				 */
				describe('«operation.name» function', function () {
					
					/**
					 * Test case for the normal flow of the operation «operation.name»
					 */
					«startJavaProtectedRegion(getRepositoryOperationUniqueId("body", operation, configCommon))»
					it('should be fulfilled', function(){
		
						«FOR param: operation.parameters»
						var «param.name» = null;
						«ENDFOR»
		
						var promise = «repository.repositoryVariableName».«operation.name»(«operation.parameters.operationParameters»);

						return Q.all([
			                promise.should.be.fulfilled
			            ]);
					});
					
					/**
					 * Test case for the exceptional flow of the operation «operation.name»
					 */
					it('should be rejected', function(){
						
						«FOR param: operation.parameters»
						var «param.name» = null;
						«ENDFOR»
						
						var promise = «repository.repositoryVariableName».«operation.name»(«operation.parameters.operationParameters»);

						return Q.all([
			                promise.should.be.rejected
			            ]);
					});
					«endJavaProtectedRegion»
				});
			«ENDFOR»
		
			«startJavaProtectedRegion(getUniqueId("additional", repository, configCommon))»
			«endJavaProtectedRegion»
		});
	'''

	private def getOperationParameters(List<RepositoryParameter> params) {
		var paramsReturn = "";

		for (param : params) {
			paramsReturn = paramsReturn + param.name + ", "
		}

		//remove the last comma
		if(!paramsReturn.empty) {
			paramsReturn = paramsReturn.substring(0, paramsReturn.length - 2);
		}

		return paramsReturn
	}

	private def getRepositoryOperationUniqueId(String id, RepositoryOperation repositoryOperation, ConfigCommon config) {
		var repository = repositoryOperation.eContainer as Repository

		getUniqueId("_Operation_" + repositoryOperation.name + "_" + id, repository, config)
	}

	private def getUniqueId(String id, Repository repository, ConfigCommon config) {
		var module = repository.repositoryModule as RepositoriesModule

		config.projectName + "_" + config.packageName + "_" + module.name + "_DocumentalRepositoryTest_" + repository.name + "Test_" + id
	}
}
