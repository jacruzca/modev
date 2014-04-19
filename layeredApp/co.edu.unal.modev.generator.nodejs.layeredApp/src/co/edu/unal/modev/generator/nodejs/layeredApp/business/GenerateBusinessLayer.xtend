package co.edu.unal.modev.generator.nodejs.layeredApp.business

import co.edu.unal.modev.generator.nodejs.business.GenerateBusinessTemplate
import co.edu.unal.modev.generator.nodejs.business.test.GenerateBusinessTestTemplate
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import co.edu.unal.modev.layeredApp.layeredAppDsl.BusinessLayer
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import co.edu.unal.modev.generator.nodejs.dto.GenerateDtoFromDocumentTemplate
import co.edu.unal.modev.document.documentDsl.Document
import co.edu.unal.modev.dtoFromDocument.dtoFromDocumentDsl.DocumentMapper

class GenerateBusinessLayer {

	@Inject extension LayeredAppUtil
	@Inject extension LocationsUtil

	@Inject GenerateBusinessTemplate generateBusinessTemplate
	@Inject GenerateBusinessTestTemplate generateBusinessTestTemplate

	@Inject GenerateDtoFromDocumentTemplate generateDtoFromDocumentTemplate

	def generate(Resource resource, JavaIoFileSystemAccess fsa) {

		generateBusinessClasses(resource, fsa)

		generateDtoClasses(resource, fsa)

	}

	private def generateDtoClasses(Resource resource, JavaIoFileSystemAccess fsa) {
		var app = resource.app as App
		var businessLayer = app.businessLayer as BusinessLayer

		for (dtoModule : businessLayer.dtosModules) {
			for (dto : dtoModule.dtos) {

				if(dto.belongsTo instanceof DocumentMapper) {

					//generate dto
					fsa.generateFile(dto.dtoLocation, generateDtoFromDocumentTemplate.generate(dto, app.config.configCommon))
				}
			}
		}
	}

	private def generateBusinessClasses(Resource resource, JavaIoFileSystemAccess fsa) {
		var app = resource.app as App
		var businessLayer = app.businessLayer as BusinessLayer

		for (businessModule : businessLayer.businessModules) {
			for (business : businessModule.business) {

				//generate business
				fsa.generateFile(business.businessLocation, generateBusinessTemplate.generate(business, resource, app.config.configCommon))

				//generate business test
				fsa.generateFile(business.businessTestLocation, generateBusinessTestTemplate.generate(business, resource, app.config.configCommon))
			}
		}
	}

}
