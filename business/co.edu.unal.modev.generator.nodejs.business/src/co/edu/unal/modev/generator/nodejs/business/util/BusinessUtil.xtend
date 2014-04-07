package co.edu.unal.modev.generator.nodejs.business.util

import co.edu.unal.modev.business.businessDsl.Business
import co.edu.unal.modev.business.businessDsl.BusinessModule
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import org.eclipse.emf.ecore.resource.Resource

class BusinessUtil {

	def getLayeredApp(Resource resource) {
		return resource.contents.get(0) as App;
	}

	def getBusinessModule(Business business) {
		return business.eContainer as BusinessModule
	}

}
