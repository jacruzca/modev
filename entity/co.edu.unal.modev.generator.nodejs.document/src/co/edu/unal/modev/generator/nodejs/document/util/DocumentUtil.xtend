package co.edu.unal.modev.generator.nodejs.document.util

import co.edu.unal.modev.document.documentDsl.Document
import co.edu.unal.modev.document.documentDsl.DocumentsModule
import co.edu.unal.modev.generator.nodejs.document.exception.DocumentsModuleNotFoundException

class DocumentUtil {

	/**
	 * finds the module of a document. 
	 * If it is a sub-doc, a DocumentsModuleNotFoundException exception will be thrown
	 */
	def getDocumentModule(Document document) {
		var module = document.eContainer
		if(module instanceof DocumentsModule) {
			return module
		}

		throw new DocumentsModuleNotFoundException("The module for the document " + document.name + " was not found");
	}
}
