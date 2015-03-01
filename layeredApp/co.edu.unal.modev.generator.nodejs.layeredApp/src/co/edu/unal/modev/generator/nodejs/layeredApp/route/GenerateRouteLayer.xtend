package co.edu.unal.modev.generator.nodejs.layeredApp.route

import co.edu.unal.modev.generator.nodejs.layeredApp.util.LayeredAppUtil
import co.edu.unal.modev.generator.nodejs.layeredApp.util.LocationsUtil
import co.edu.unal.modev.generator.nodejs.route.GenerateRouteTemplate
import co.edu.unal.modev.generator.nodejs.route.GenerateRoutesIndexJsTemplate
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import co.edu.unal.modev.layeredApp.layeredAppDsl.RouteLayer
import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

class GenerateRouteLayer {

	@Inject extension LayeredAppUtil
	@Inject extension LocationsUtil

	@Inject GenerateRoutesIndexJsTemplate generateRoutesIndexJsTemplate
	@Inject GenerateRouteTemplate generateRouteTemplate

	def generate(Resource resource, JavaIoFileSystemAccess fsa) {

		generateRoutes(resource, fsa)

		generateRouteIndexJs(resource, fsa)

	}

	private def generateRoutes(Resource resource, JavaIoFileSystemAccess fsa) {
		var app = resource.app as App
		var routesLayer = app.routeLayer as RouteLayer

		for (routeModule : routesLayer.routesModules) {
			//generate route module
			fsa.generateFile(routeModule.routeModuleLocation, generateRouteTemplate.generate(routeModule))
		}
	}

	private def generateRouteIndexJs(Resource resource, JavaIoFileSystemAccess fsa) {
		var app = resource.app as App
		var routesLayer = app.routeLayer as RouteLayer
		//generate index.js for routes
		fsa.generateFile(routeIndexJsLocation, generateRoutesIndexJsTemplate.generate(routesLayer.routesModules, app.config.configCommon))
	}

}
