package co.edu.unal.modev.generator.nodejs.layeredApp.util

import co.edu.unal.modev.common.ConfigCommon
import co.edu.unal.modev.layeredApp.layeredAppDsl.App
import co.edu.unal.modev.layeredApp.layeredAppDsl.Config
import org.eclipse.emf.ecore.resource.Resource

class LayeredAppUtil {

	def getApp(Resource resource) {
		return resource.contents.get(0) as App;
	}

	def getConfigCommon(Config config) {
		new ConfigCommon(config.projectConfig.packageName, config.projectConfig.projectName)
	}

}
