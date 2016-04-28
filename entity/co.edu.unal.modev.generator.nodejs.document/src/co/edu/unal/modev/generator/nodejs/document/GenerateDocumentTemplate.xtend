package co.edu.unal.modev.generator.nodejs.document

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.document.documentDsl.CompoundIndex
import co.edu.unal.modev.document.documentDsl.Document
import co.edu.unal.modev.document.documentDsl.DocumentProperty
import co.edu.unal.modev.document.documentDsl.DocumentsModule
import co.edu.unal.modev.document.documentDsl.ORDER_TYPE
import co.edu.unal.modev.document.documentDsl.SimpleTypes
import co.edu.unal.modev.generator.nodejs.document.util.DocumentUtil
import javax.inject.Inject

class GenerateDocumentTemplate {

	@Inject extension DocumentUtil
	@Inject extension TemplateExtensions

	def generate(Document document, ConfigCommon config) '''
		/**
		 * The document module with the mongoose «document.name» schema
		 * @module model/«document.documentModule.name»/«document.name»
		 */

		«startJavaProtectedRegion(getUniqueId("init", document, config))»
		var logger = console;
		
		var mongoose = require('mongoose'),
		Schema = mongoose.Schema;
		
		
		«endJavaProtectedRegion»
		
		«FOR inlineProperty : document.properties.filter(prop|prop.type.inline != null)»
		
			«IF inlineProperty.type.inline != null»

				«FOR inlineSubProperty: inlineProperty.type.inline.properties.filter(prop | prop.type.inline != null)»
					«printSubdocument(inlineSubProperty)»
				«ENDFOR»

			«ENDIF»
		
			«printSubdocument(inlineProperty)»
		«ENDFOR»
		
		/**
		 * «document.name» Schema
		 */
		var «document.schemaName» = new Schema({

			«FOR property : document.properties SEPARATOR ","»
				«IF property.type.inline != null»
					«IF property.many»
						«property.name» : [«property.propertyType»]
					«ELSE»
						«property.name» : «property.propertyType»
					«ENDIF»
				«ELSE»
					«IF property.many»
						«property.name» : [{
					«ELSE»
						«property.name» : {
					«ENDIF»
						type: «property.propertyType»«IF property.unique», unique: true«ENDIF»«IF property.required», required: true«ENDIF»«IF property.index», index: true«ENDIF»
					«IF property.defaultValue != null && !property.defaultValue.trim.empty»
						, default: «property.defaultValue»
					«ENDIF»
					«IF property.many»
						}]
					«ELSE»
						}
					«ENDIF»
				«ENDIF»
			«ENDFOR»
		},{
			«startJavaProtectedRegion(getUniqueId("mainSchemaOptions", document, config))»
			«endJavaProtectedRegion»
		});
		
		«FOR indexes : document.compoundIndexes»
			«document.schemaName».index({«indexes.indexObject»}, {«IF indexes.unique»unique: true«ENDIF»});
		«ENDFOR»
		
		module.exports.model = function(){
		    mongoose.model('«document.name»', «document.schemaName»);
		};
		
		module.exports.schema = «document.schemaName»;
		
		«startJavaProtectedRegion(getUniqueId("additionalMethods", document, config))»
		«endJavaProtectedRegion»
	'''

	private def getIndexObject(CompoundIndex index) {
		var res = "";
		for (attr : index.indexAttributes) {
			res = res + ''' «attr.attribute.name»: «IF attr.type.equals(ORDER_TYPE.ASC)»1«ELSE»-1«ENDIF», '''
		}

		if(!res.empty) {
			res = res.substring(0, res.length - 2);
		}

		res
	}
	
	private def printSubdocument(DocumentProperty inlineProperty)'''
			«var inlineDocument = inlineProperty.type.inline»
			/**
			 * «inlineDocument.name» - SubDoc
			 */
			var «inlineDocument.schemaName» = {

				«FOR property : inlineDocument.properties SEPARATOR ","»
					«IF property.type.inline != null»
						«IF property.many»
							«property.name» : [«property.propertyType»]
						«ELSE»
							«property.name» : «property.propertyType»
						«ENDIF»
					«ELSE»
						«IF property.many»
							«property.name» : [{
						«ELSE»
							«property.name» : {
						«ENDIF»
								type: «property.propertyType»
						«IF property.defaultValue != null && !property.defaultValue.trim.empty»
							, default: «property.defaultValue»
						«ENDIF»
						«IF property.unique»
							, unique: true
						«ENDIF»
						«IF property.required»
							, required: true
						«ENDIF»
						}
						«IF property.many»
						]
						«ENDIF»
					«ENDIF»
				«ENDFOR»
			};
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
			type = "Schema.ObjectId, ref: '" + propertyAbstractType.ref.ref.name + "'"
		} else if(propertyAbstractType.simple != null) {
			if(propertyAbstractType.simple.equals(SimpleTypes.MIXED)){
				type = "Schema.Types.Mixed";
			}else{
				type = propertyAbstractType.simple.literal	
			}
		}

		type
	}

	private def getUniqueId(String id, Document document, ConfigCommon config) {
		var module = document.documentModule as DocumentsModule

		config.projectName + "_" + config.packageName + "_" + module.name + "_Document_" + document.name + "_" + id
	}
}
