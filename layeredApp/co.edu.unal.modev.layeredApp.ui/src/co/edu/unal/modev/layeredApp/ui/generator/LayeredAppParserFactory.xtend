package co.edu.unal.modev.layeredApp.ui.generator

import com.google.inject.Inject
import net.danieldietrich.protectedregions.ModelBuilder
import net.danieldietrich.protectedregions.ParserFactory
import net.danieldietrich.protectedregions.ProtectedRegionParser

/**
 * Use esta clase para crear los factories que sean necesarios
 */
class LayeredAppParserFactory extends ParserFactory  {
	
	@Inject extension ModelBuilder
	
	def ProtectedRegionParser propertiesParser() {
		parser("properties")[
			model[
				comment("#")
				string('"').withEscape("\\")
				string("'").withEscape("\\")
			]
		]
	}
}