package co.edu.unal.modev.generator.nodejs.layeredApp.structure

import co.edu.unal.modev.layeredApp.layeredAppDsl.Config

class GeneratePackageJsonTemplate {

	def generate(Config config) '''
		{
			"name" : "«config.projectConfig.projectName»",
			"description": "«config.projectConfig.projectName»",
			"private": true,
			"keywords" : [
				"express",
				"mysql",
				"passport",
				"sequelize"
			],
			"version": "«config.projectConfig.applicationVersion»",
			"author": "UNAL",
			"scripts": {
				"start": "NODE_ENV=development ./node_modules/.bin/nodemon server.js",
				"test": "NODE_ENV=test ./node_modules/.bin/mocha --reporter spec test/**/*.js"
			},
			"dependencies": {
			    "crypto": "latest",
			    "ejs": "latest",
			    "express": "latest",
			    "passport": "latest",
			    "passport-local": "latest",
			    "sequelize": "latest",
			    "mysql": "latest",
			    "winston": "latest",
			    "randomstring": "latest",
			       "connect-roles": "latest",
			       "csv": "latest",
			       "xtend": "latest"
			},
			"devDependencies": {
				"sqlite3": "latest",
				 "should": "latest",
				 "mocha": "latest",
				 "rewire": "latest",
				 "nodemon": "latest"
			}
		}
	'''

}
