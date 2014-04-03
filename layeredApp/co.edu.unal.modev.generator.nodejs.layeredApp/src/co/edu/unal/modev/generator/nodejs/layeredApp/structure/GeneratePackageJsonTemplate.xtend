package co.edu.unal.modev.generator.nodejs.layeredApp.structure

import co.edu.unal.modev.layeredApp.layeredAppDsl.Config

class GeneratePackageJsonTemplate {

	def generate(Config config) '''
		{
			"name" : "«config.projectConfig.projectName»",
			"description": "«config.projectConfig.projectName»",
			"private": true,
			"version": "«config.projectConfig.applicationVersion»",
			"author": "UNAL",
			"scripts": {
				"start": "NODE_ENV=development ./node_modules/.bin/nodemon server.js",
				"test": "NODE_ENV=test ./node_modules/.bin/mocha --reporter spec test/**/*.js"
			},
			"dependencies": {
			    "express": "~3.5.1",
			    "passport": "~0.2.0",
			    "passport-local": "~1.0.0",
			    "sequelize": "~1.7.0",
			    "mysql": "~2.1.1",
			    "winston": "~0.7.3",
			},
			"devDependencies": {
				"sqlite3": "~2.2.0",
				 "should": "~3.2.0",
				 "mocha": "~1.18.2",
				 "rewire": "~1.1.2",
				 "nodemon": "~1.0.17"
			}
		}
	'''

}
