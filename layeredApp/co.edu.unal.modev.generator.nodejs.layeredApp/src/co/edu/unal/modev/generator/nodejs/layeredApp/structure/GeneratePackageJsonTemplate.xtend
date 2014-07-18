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
		        "express": "4.4.3",
		        "body-parser": "1.3.1",
		        "method-override": "2.0.2",
		        "passport": "~0.2.0",
		        "mongoose": "~3.8.12",
		        "mpromise": "~0.5.4",
		        "q": "~2.0.0",
		        "winston": "~0.7.3",
		        "randomstring": "1.0.3",
		        "crypto": "0.0.3",
		        "amqplib": "v0.2.0",
		        "when": "3.2.3"
		    },
		    "devDependencies": {
		        "chai": "~1.9.1",
		        "chai-as-promised": "~4.1.1",
		        "mocha": "~1.18.2",
		        "rewire": "~1.1.2",
		        "nodemon": "~1.0.17"
		    }
		}
	'''

}
