package co.edu.unal.modev.generator.nodejs.layeredApp.config

class GenerateConstantsJsTemplate {
	
	def generate()'''
	module.exports = {

		client: {
	        web: "web",
	        mobile: "mobile"
		},
	
		tokenHeader: "Secure-Token",
	
		limit: 1000,
	
		uploadDir: "/home/jhon/environment/workspaces/nodejs-workspace/tramat/files"
	
	}
	'''
	
}