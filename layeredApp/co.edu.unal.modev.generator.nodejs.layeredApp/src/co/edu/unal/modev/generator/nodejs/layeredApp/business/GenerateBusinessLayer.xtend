package co.edu.unal.modev.generator.nodejs.layeredApp.business

import co.edu.unal.modev.generator.nodejs.business.GenerateBusinessTemplate
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import co.edu.unal.modev.layeredApp.layeredAppDsl.BusinessLayer
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

class GenerateBusinessLayer {

	@Inject extension LayeredAppUtil
	@Inject extension LocationsUtil

	@Inject GenerateBusinessTemplate generateBusinessTemplate

	def generate(Resource resource, JavaIoFileSystemAccess fsa) {

		generateBusinessClasses(resource, fsa)

	}

	private def generateBusinessClasses(Resource resource, JavaIoFileSystemAccess fsa) {
		var app = resource.app as App
		var businessLayer = app.businessLayer as BusinessLayer

		for (businessModule : businessLayer.businessModules) {
			for (business : businessModule.business) {

				//generate business
				fsa.generateFile(business.businessLocation, generateBusinessTemplate.generate(business, resource, app.config.configCommon))
			}
		}
	}

}
