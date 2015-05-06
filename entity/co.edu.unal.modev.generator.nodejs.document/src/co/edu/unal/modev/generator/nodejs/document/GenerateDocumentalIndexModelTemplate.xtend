package co.edu.unal.modev.generator.nodejs.document

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.document.documentDsl.Document
import co.edu.unal.modev.generator.nodejs.document.util.DocumentUtil
import com.google.inject.Inject
import java.util.List

class GenerateDocumentalIndexModelTemplate {

	@Inject extension DocumentUtil
	@Inject extension TemplateExtensions

	def generate(List<Document> documents, ConfigCommon config) '''
		
		«startJavaProtectedRegion(getUniqueId("init", config))»
		var mongoose = require('mongoose');
		var logger = console;
		
		var env = process.env.NODE_ENV || 'development';
		var config = require('../../config/config')[env];
		
		«endJavaProtectedRegion»
		
		//setup mongoDB connection
		
		var connectionString = 'mongodb://'+config.mongo.host+':'+config.mongo.port+'/'+config.mongo.name+'';
		
		if(config.mongo.user.length > 0 && config.mongo.password.length > 0){
			connectionString = 'mongodb://'+config.mongo.user+':'+config.mongo.password+'@'+config.mongo.host+':'+config.mongo.port+'/'+config.mongo.name+'';
		}
		
		mongoose.connect(connectionString, function (err, res) {
		    if (err) throw err;
		    logger.debug('Successful connection to MongoDB');
		});
		
		«startJavaProtectedRegion(getUniqueId("mid", config))»
		«endJavaProtectedRegion»
		
		«FOR document : documents»
			require('./«document.documentModule.name»/«document.name»').model();
		«ENDFOR»
		
		«startJavaProtectedRegion(getUniqueId("end", config))»
		«endJavaProtectedRegion»
	'''

	private def getUniqueId(String id, ConfigCommon config) {
		config.projectName + "_" + config.packageName + "_DocumentalIndexModel_" + "_" + id
	}
}
