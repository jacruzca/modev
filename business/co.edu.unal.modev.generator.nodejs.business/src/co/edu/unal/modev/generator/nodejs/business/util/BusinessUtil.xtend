package co.edu.unal.modev.generator.nodejs.business.util

import co.edu.unal.modev.business.businessDsl.Business
import co.edu.unal.modev.business.businessDsl.BusinessModule
import co.edu.unal.modev.business.businessDsl.BusinessOperation
import co.edu.unal.modev.business.businessDsl.BusinessParameter
import co.edu.unal.modev.business.businessDsl.SimpleBusinessTypes
import co.edu.unal.modev.dto.dtoDsl.DtoAttribute
import co.edu.unal.modev.dto.dtoDsl.SimpleDtoTypes
import co.edu.unal.modev.generator.nodejs.business.exception.UnsupportedTypeException
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import org.eclipse.emf.ecore.resource.Resource

import static co.edu.unal.modev.business.businessDsl.SimpleBusinessTypes.*

class BusinessUtil {

	def getLayeredApp(Resource resource) {
		return resource.contents.get(0) as App;
	}

	def getBusinessModule(Business business) {
		return business.eContainer as BusinessModule
	}

	public def getDtoAttributeType(DtoAttribute dtoAttribute) {
		if(dtoAttribute.type.dtoType != null) {
			return dtoAttribute.type.dtoType.name
		} else if(dtoAttribute.type.literalType != null && !dtoAttribute.type.literalType.trim.empty) {
			return dtoAttribute.type.literalType
		} else if(dtoAttribute.type.simple != null) {
			return dtoAttribute.type.simple.mapSimpleAttributeType
		} else {
			return "undefined"
		}
	}

	public def mapOperationParamType(BusinessParameter businessParameter) {
		if(businessParameter.type.dtoType != null) {
			return businessParameter.type.dtoType.name
		} else if(businessParameter.type.literalType != null && !businessParameter.type.literalType.trim.empty) {
			return businessParameter.type.literalType
		} else if(businessParameter.type.simple != null) {
			return businessParameter.type.simple.mapSimpleReturnType
		} else {
			return "undefined"
		}
	}

	public def mapReturnType(BusinessOperation businessOperation) {
		var abstractBusinessType = businessOperation.returnType.businessType
		if(abstractBusinessType != null) {
			if(abstractBusinessType.dtoType != null) {
				return abstractBusinessType.dtoType.name
			} else if(abstractBusinessType.literalType != null && !abstractBusinessType.literalType.trim.empty) {
				return abstractBusinessType.literalType
			} else if(abstractBusinessType.simple != null) {
				return abstractBusinessType.simple.mapSimpleReturnType
			}
		} else {
			return "undefined"
		}
	}

	public def mapSimpleReturnType(SimpleBusinessTypes simpleBusinessTypes) {
		var retType = ""

		switch simpleBusinessTypes {
			case BOOLEAN:
				retType = "boolean"
			case DATE:
				retType = "date"
			case NUMBER:
				retType = "integer"
			case DECIMAL:
				retType = "float"
			case STRING:
				retType = "string"
			default:
				retType = ""
		}

		if(retType.empty) {
			throw new UnsupportedTypeException("Type not supported")
		}

		return retType

	}

	public def mapSimpleAttributeType(SimpleDtoTypes simpleDtoTypes) {
		var retType = ""

		switch simpleDtoTypes {
			case BOOLEAN:
				retType = "boolean"
			case DATE:
				retType = "date"
			case NUMBER:
				retType = "integer"
			case DECIMAL:
				retType = "float"
			case STRING:
				retType = "string"
			default:
				retType = ""
		}

		if(retType.empty) {
			throw new UnsupportedTypeException("Type not supported")
		}

		return retType
	}

}
