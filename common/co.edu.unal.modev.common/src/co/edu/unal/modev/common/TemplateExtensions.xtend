package co.edu.unal.modev.common

class TemplateExtensions {

	def startJavaProtectedRegion(String uniqueId) '''/* PROTECTED REGION ID(«uniqueId») ENABLED START */'''

	def startXmlProtectedRegion(String uniqueId) '''
		<!-- PROTECTED REGION ID(«uniqueId») ENABLED START -->
	'''

	def startPropertiesProtectedRegion(String uniqueId) '''
		# PROTECTED REGION ID(«uniqueId») ENABLED START #
	'''

	def endJavaProtectedRegion() '''/* PROTECTED REGION END */'''

	def endXmlProtectedRegion() '''
		<!-- PROTECTED REGION END -->
	'''

	def endPropertiesProtectedRegion() '''
		# PROTECTED REGION END #
	'''

	def parseProtectedRegionId(String id) {
		var idNuevo = id.replaceAll("<", "_")

		idNuevo = idNuevo.replaceAll(">", "_")

		idNuevo = idNuevo.replaceAll("-", "_")

		idNuevo = idNuevo.replaceAll(" ", "");

		idNuevo = idNuevo.replaceAll(",", "_");

		idNuevo = idNuevo.replaceAll("\"", "_");

		idNuevo = idNuevo.replaceAll("/", ".");

		idNuevo = idNuevo.replaceAll("\\[", "_");

		idNuevo = idNuevo.replaceAll("\\]", "_");

		return idNuevo
	}

}
