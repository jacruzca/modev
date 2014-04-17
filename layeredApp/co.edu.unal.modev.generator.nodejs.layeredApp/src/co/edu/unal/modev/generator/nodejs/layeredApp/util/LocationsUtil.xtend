package co.edu.unal.modev.generator.nodejs.layeredApp.util

import co.edu.unal.modev.business.businessDsl.Business
import co.edu.unal.modev.business.businessDsl.BusinessModule
import co.edu.unal.modev.document.documentDsl.Document
import co.edu.unal.modev.document.documentDsl.DocumentsModule
import co.edu.unal.modev.entity.entityDsl.EntitiesModule
import co.edu.unal.modev.entity.entityDsl.Entity
import co.edu.unal.modev.repository.repositoryDsl.RepositoriesModule
import co.edu.unal.modev.repository.repositoryDsl.Repository
import co.edu.unal.modev.route.routeDsl.RoutesModule

class LocationsUtil {

	final static String PATH_SEPARATOR = "/"
	final static String JS_EXTENSION = ".js"
	final static String JSON_EXTENSION = ".json"

	final static String SERVER = "server"
	final static String APP = "app"
	final static String MODEL = "model"
	final static String CONFIG = "config"
	final static String TEST = "test"
	final static String UNIT = "unit"
	final static String DATA = "data"
	final static String REPOSITORY = "repository"
	final static String BUSINESS = "business"
	final static String ROUTE = "route"
	final static String REPOSITORY_SUFFIX = "Repository"
	final static String REPOSITORY_FACTORY = REPOSITORY_SUFFIX + "Factory"

	def getServerLocation() {
		return SERVER + PATH_SEPARATOR
	}

	def getPackageJsonLocation() {
		return serverLocation + "package" + JSON_EXTENSION
	}

	def getServerJsLocation() {
		return serverLocation + "server" + JS_EXTENSION
	}

	def getAppLocation() {
		return serverLocation + APP + PATH_SEPARATOR
	}

	def getConfigLocation() {
		return serverLocation + CONFIG + PATH_SEPARATOR
	}

	def getConfigJsLocation() {
		return configLocation + "config" + JS_EXTENSION
	}

	def getExpressJsLocation() {
		return configLocation + "express" + JS_EXTENSION
	}

	def getLoggerJsLocation() {
		return configLocation + "logger" + JS_EXTENSION
	}

	def getModelLocation() {
		return appLocation + MODEL + PATH_SEPARATOR
	}

	/**
	 * returns the entity location relative to the project
	 */
	def getEntityLocation(Entity entity) {
		var location = modelLocation as String

		//add module
		var entitiesModule = entity.eContainer as EntitiesModule
		location = location + entitiesModule.name + PATH_SEPARATOR

		//add filename
		location = location + entity.name + JS_EXTENSION

		return location
	}

	/**
	 * returns the document location relative to the project
	 */
	def getDocumentLocation(Document document) {
		var location = modelLocation as String

		//add module
		var documentsModule = document.eContainer as DocumentsModule
		location = location + documentsModule.name + PATH_SEPARATOR

		//add filename
		location = location + document.name + JS_EXTENSION

		return location
	}

	def getRelationalIndexModelLocation() {
		return modelLocation + "indexRelational" + JS_EXTENSION
	}

	def getDocumentalIndexModelLocation() {
		return modelLocation + "indexDocumental" + JS_EXTENSION
	}

	def getRepositoryLocation() {
		return appLocation + REPOSITORY + PATH_SEPARATOR
	}

	/**
	 * returns the repo location relative to the project
	 */
	def getRepositoryLocation(Repository repository) {
		var location = repositoryLocation as String

		//add module
		var repositoriesModule = repository.eContainer as RepositoriesModule
		location = location + repositoriesModule.name + PATH_SEPARATOR

		//add filename
		location = location + repository.name + JS_EXTENSION

		return location
	}

	def getRepositoryFactoryLocation() {
		return repositoryLocation + REPOSITORY_FACTORY + JS_EXTENSION
	}

	def getBusinessLocation() {
		return appLocation + BUSINESS + PATH_SEPARATOR
	}
	
	def getBusinessTestLocation() {
		return unitTestLocation + BUSINESS + PATH_SEPARATOR
	}

	/**
	 * returns the business location relative to the project
	 */
	def getBusinessLocation(Business business) {
		var location = businessLocation as String

		//add module
		var businessModule = business.eContainer as BusinessModule
		location = location + businessModule.name + PATH_SEPARATOR

		//add filename
		location = location + business.name + JS_EXTENSION

		return location
	}
	
	/**
	 * returns the business location relative to the project
	 */
	def getBusinessTestLocation(Business business) {
		var location = businessTestLocation as String

		//add module
		var businessModule = business.eContainer as BusinessModule
		location = location + businessModule.name + PATH_SEPARATOR

		//add filename
		location = location + business.name +"Test"+ JS_EXTENSION

		return location
	}

	def getRouteLocation() {
		return appLocation + ROUTE + PATH_SEPARATOR
	}

	def getRouteModuleLocation(RoutesModule routesModule) {
		return routeLocation + routesModule.name + JS_EXTENSION
	}

	def getRouteIndexJsLocation() {
		return routeLocation + "index" + JS_EXTENSION
	}

	def getUnitTestLocation() {
		return serverLocation + TEST + PATH_SEPARATOR + UNIT + PATH_SEPARATOR
	}

	def getRepositoryUnitTestLocation() {
		return unitTestLocation + REPOSITORY + PATH_SEPARATOR
	}

	/**
	 * returns the repo test location relative to the project
	 */
	def getRepositoryUnitTestLocation(Repository repository) {
		var location = repositoryUnitTestLocation as String

		//add module
		var repositoriesModule = repository.eContainer as RepositoriesModule
		location = location + repositoriesModule.name + PATH_SEPARATOR

		//add filename
		location = location + repository.name + "Test" + JS_EXTENSION

		return location
	}

	/**
	 * returns the repo data test location relative to the project
	 */
	def getRepositoryUnitDataTestLocation(Repository repository) {
		var location = repositoryUnitTestLocation as String

		//add module and the data folder
		var repositoriesModule = repository.eContainer as RepositoriesModule
		location = location + repositoriesModule.name + PATH_SEPARATOR + DATA + PATH_SEPARATOR

		//add filename
		location = location + repository.name + "Data" + JS_EXTENSION

		return location
	}

}
