package co.edu.unal.modev.generator.nodejs.route

import co.edu.unal.modev.business.businessDsl.Business
import co.edu.unal.modev.business.businessDsl.BusinessModule
import co.edu.unal.modev.route.routeDsl.RoutesModule
import java.util.ArrayList
import java.util.List

class GenerateRouteTemplate {

	def generate(RoutesModule routesModule) '''
		
		/**
		 * The module representing the «routesModule.name» routes module
		 * @module route/«routesModule.name»
		 */
		
		«FOR business : routesModule.allInvolvedBusiness»
			var «business.name.toFirstLower» = require("../business/«(business.eContainer as BusinessModule).name»/«business.
			name.toFirstUpper»");
		«ENDFOR»
		
		/**
		 * Following are the routes for «routesModule.name»
		 * @param {Express} app the app element from express
		 */
		module.exports = function (app, passport) {

			«FOR routeContext : routesModule.resourcesContext»
			
			/**
			 * Routes for the context «routeContext.name» with basePath "«routeContext.basePath»".
			 * Description: «routeContext.description»
			 */
			
			«FOR route : routeContext.routes»
			«var business = route.operation.eContainer as Business»

			app.«route.httpVerb.toString.toLowerCase»('«route.uri»', «business.name.toFirstLower».«route.operation.name»);

			«ENDFOR»
			«ENDFOR»
		};

	'''

	private def getAllInvolvedBusiness(RoutesModule routesModule) {
		var businessList = new ArrayList<Business>

		for (routeContext : routesModule.resourcesContext) {
			for (route : routeContext.routes) {
				var business = route.operation.eContainer as Business
				if (!businessList.alreadyExistsInList(business)) {
					businessList.add(business)
				}
			}
		}

		return businessList
	}

	private def alreadyExistsInList(List<Business> list, Business business) {
		for (bList : list) {
			if (business.name.equals(bList.name) &&
				(business.eContainer as BusinessModule).name.equals((bList.eContainer as BusinessModule).name)) {
				return true;
			}
		}

		return false;
	}
}
