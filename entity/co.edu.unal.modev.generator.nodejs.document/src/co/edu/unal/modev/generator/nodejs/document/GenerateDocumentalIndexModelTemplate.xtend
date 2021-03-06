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
		var logger = require("../../config/logger");
		
		var env = process.env.NODE_ENV || 'development';
		var config = require('../../config/config')[env];
		
		«endJavaProtectedRegion»
		
		//setup mongoDB connection
		mongoose.connect('mongodb://'+config.mongo.host+':'+config.mongo.port+'/'+config.mongo.name+'', function (err, res) {
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
