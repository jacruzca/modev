package co.edu.unal.modev.generator.nodejs.repository.test

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.document.documentDsl.Document
import co.edu.unal.modev.document.documentDsl.DocumentProperty
import co.edu.unal.modev.document.documentDsl.SimpleTypes
import co.edu.unal.modev.generator.nodejs.repository.util.RepositoryUtil
import co.edu.unal.modev.repository.repositoryDsl.RepositoriesModule
import co.edu.unal.modev.repository.repositoryDsl.Repository
import javax.inject.Inject

class GenerateDocumentDataTemplate {

	@Inject extension RepositoryUtil
	@Inject extension TemplateExtensions

	def generate(Repository repository, ConfigCommon configCommon) '''
		«startJavaProtectedRegion(getUniqueId("init", repository, configCommon))»
		«var document = repository.document as Document»
		var logger = require("../../../../../config/logger");
		«endJavaProtectedRegion»
		
		module.exports.generate = function (id) {
			«FOR inlineProperty : document.properties.filter(prop|prop.type.inline != null)»
				«var inlineDocument = inlineProperty.type.inline»
				var «inlineDocument.name» = {
					«FOR property : inlineDocument.properties SEPARATOR ","»
						«property.name»: «property.propertyValue»
					«ENDFOR»
				};
			«ENDFOR»
			
			«startJavaProtectedRegion(getUniqueId("custom_subdocs", repository, configCommon))»
			«endJavaProtectedRegion»
		    
		    var «document.name» = {
		    	«FOR property : document.properties SEPARATOR ","»
		    		«property.name»: «property.propertyValue»
				«ENDFOR»
		    }
		    
		    «startJavaProtectedRegion(getUniqueId("custom", repository, configCommon))»
			«endJavaProtectedRegion»
		
		    return «document.name»;
		}
		
		«startJavaProtectedRegion(getUniqueId("additional", repository, configCommon))»
		«endJavaProtectedRegion»
	'''

	private def getPropertyValue(DocumentProperty property) {
		var type = "";
		val propertyAbstractType = property.type

		if(propertyAbstractType.inline != null) {
			type = propertyAbstractType.inline.name
		} else if(propertyAbstractType.ref != null) {
			type = "{}"
		} else if(propertyAbstractType.simple != null) {
			if(propertyAbstractType.simple.equals(SimpleTypes.NUMBER)) {
				type = "id"
			} else if(propertyAbstractType.simple.equals(SimpleTypes.BOOLEAN)) {
				type = "true"
			} else if(propertyAbstractType.simple.equals(SimpleTypes.DATE)) {
				type = "new Date()"
			} else {
				type = "'" + property.name + "' + id"
			}
		}

		type
	}

	private def getUniqueId(String id, Repository repository, ConfigCommon config) {
		var module = repository.repositoryModule as RepositoriesModule

		config.projectName + "_" + config.packageName + "_" + module.name + "_DocumentDataTest" + repository.document.name + "Test_" + id
	}
}
