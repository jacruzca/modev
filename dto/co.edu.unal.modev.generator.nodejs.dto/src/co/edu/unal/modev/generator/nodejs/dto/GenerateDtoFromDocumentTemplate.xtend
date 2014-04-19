package co.edu.unal.modev.generator.nodejs.dto

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.common.TemplateExtensions
import co.edu.unal.modev.dto.dtoDsl.Dto
import co.edu.unal.modev.dto.dtoDsl.DtosModule
import co.edu.unal.modev.dtoFromDocument.dtoFromDocumentDsl.DocumentMapper
import co.edu.unal.modev.generator.nodejs.dto.exception.DtosModuleNotFoundException
import javax.inject.Inject

class GenerateDtoFromDocumentTemplate {

	@Inject extension TemplateExtensions

	def generate(Dto dto, ConfigCommon config) '''
		«var document = dto.documentFromDto»
		var logger = require("../../../config/logger");
		
		module.exports.build = function (input) {
			
			«IF document != null»
				
				var «document.name»Rep = {
					«FOR property : document.properties SEPARATOR ","»
						«property.name» : input.«property.name»
					«ENDFOR»
				}
				
				«FOR inlineProperty : document.properties.filter(prop|prop.type.inline != null)»
					«var inlineDocument = inlineProperty.type.inline»
					var «inlineDocument.name»Rep = {};
					if (typeof input.«inlineProperty.name» != 'undefined') {
						var «inlineDocument.name»Rep = {
							«FOR property : inlineDocument.properties SEPARATOR ","»
								«property.name» : input.«inlineProperty.name».«property.name»
							«ENDFOR»
						};
					}
					
					«document.name»Rep.«inlineProperty.name» = «inlineDocument.name»Rep;
					
				«ENDFOR»
				«startJavaProtectedRegion(getUniqueId("customBuild", dto, config))»
				«endJavaProtectedRegion»
				
				return «document.name»Rep;
			«ELSE»
				return input;
			«ENDIF»
		}
		
		«startJavaProtectedRegion(getUniqueId("additionalBuildMethods", dto, config))»
		«endJavaProtectedRegion»
		
		module.exports.buildList = function (inputList) {
		    if (Array.isArray(inputList)) {
		        var arrayResult = [];
		
		        for (var i = 0; i < inputList.length; i++) {
		            var builtInput = module.exports.build(inputList[i]);
		            arrayResult.push(builtInput);
		        }
		        
		        «startJavaProtectedRegion(getUniqueId("customBuildList", dto, config))»
				«endJavaProtectedRegion»
		
		        return arrayResult;
		
		    } else {
		        return module.exports.build(inputList);
		    }
		}
		
		«startJavaProtectedRegion(getUniqueId("additionalBuildListMethods", dto, config))»
		«endJavaProtectedRegion»
	'''

	private def getDocumentFromDto(Dto dto) {
		if(dto.belongsTo != null && dto.belongsTo instanceof DocumentMapper) {
			var documentMapper = dto.belongsTo as DocumentMapper

			return documentMapper.document
		}

		return null;
	}

	/**
	 * finds the module of a document. 
	 * If it is a sub-doc, a DocumentsModuleNotFoundException exception will be thrown
	 */
	def getDtoModule(Dto dto) {
		var module = dto.eContainer
		if(module instanceof DtosModule) {
			return module
		}

		throw new DtosModuleNotFoundException("The module for the dto " + dto.name + " was not found");
	}

	private def getUniqueId(String id, Dto dto, ConfigCommon config) {
		var module = dto.dtoModule as DtosModule

		config.projectName + "_" + config.packageName + "_" + module.name + "_Dto_" + dto.name + "_" + id
	}

}
