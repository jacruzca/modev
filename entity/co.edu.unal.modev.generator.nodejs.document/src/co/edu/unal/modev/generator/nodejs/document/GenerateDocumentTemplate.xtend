package co.edu.unal.modev.generator.nodejs.document

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.document.documentDsl.Document
import co.edu.unal.modev.document.documentDsl.DocumentProperty
import co.edu.unal.modev.document.documentDsl.DocumentsModule
import co.edu.unal.modev.generator.nodejs.document.util.DocumentUtil
import javax.inject.Inject

class GenerateDocumentTemplate {

	@Inject extension DocumentUtil
	@Inject extension TemplateExtensions

	def generate(Document document, ConfigCommon config) '''
		
		«startJavaProtectedRegion(getUniqueId("init", document, config))»
		var logger = require("../../../config/logger");
		
		var mongoose = require('mongoose'),
		Schema = mongoose.Schema;
		
		
		«endJavaProtectedRegion»
		
		«FOR inlineProperty: document.properties.filter(prop | prop.type.inline != null)»
			«var inlineDocument = inlineProperty.type.inline»
			/**
			 * «inlineDocument.name» Schema - SubDoc
			 */
			var «inlineDocument.schemaName» = new Schema({
				
				«FOR property : inlineDocument.properties»
					«property.name» : { 
							type: «property.propertyType»
						«IF property.defaultValue != null && !property.defaultValue.trim.empty»
							, default: «property.defaultValue»
						«ENDIF»
						«IF property.unique»
							, unique: true
						«ENDIF»
					},
				«ENDFOR»
			});
		«ENDFOR»
		
		/**
		 * «document.name» Schema
		 */
		var «document.schemaName» = new Schema({
			
			«FOR property : document.properties»
				«property.name» : { 
						type: «property.propertyType»
					«IF property.defaultValue != null && !property.defaultValue.trim.empty»
						, default: «property.defaultValue»
					«ENDIF»
					«IF property.unique»
						, unique: true
					«ENDIF»
					«IF property.index»
						, index: true
					«ENDIF»
				},
			«ENDFOR»
		});
		
		module.exports.model = function(){
		    mongoose.model('«document.name»', «document.schemaName»);
		};
		
		module.exports.schema = «document.schemaName»;
		
		«startJavaProtectedRegion(getUniqueId("additionalMethods", document, config))»
		«endJavaProtectedRegion»
	'''

	private def getSchemaName(Document document) {
		document.name + "Schema"
	}

	private def getPropertyType(DocumentProperty property) {

		var type = "";
		val propertyAbstractType = property.type

		if(propertyAbstractType.inline != null) {
			type = propertyAbstractType.inline.schemaName
		} else if(propertyAbstractType.ref != null) {
			type = "Schema.ObjectId, ref: '" + propertyAbstractType.ref.ref.name+"'"
		} else if(propertyAbstractType.simple != null) {
			type = propertyAbstractType.simple.literal
		}
		
		type
	}
	
	private def getUniqueId(String id, Document document, ConfigCommon config){
		var module = document.documentModule as DocumentsModule
		
		config.projectName+"_"+config.packageName+"_"+module.name+"_Document_"+document.name+"_"+id
	}
}
