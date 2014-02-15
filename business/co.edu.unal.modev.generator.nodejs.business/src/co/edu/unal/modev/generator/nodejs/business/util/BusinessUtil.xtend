package co.edu.unal.modev.generator.nodejs.business.util

import co.edu.unal.modev.business.businessDsl.Business
import co.edu.unal.modev.business.businessDsl.BusinessModule

class BusinessUtil {
	
	final static String REPOSITORY_SUFFIX = "Business"
	
	def getBusinessModule(Business business){
		return business.eContainer as BusinessModule
	}
	
}