package co.edu.unal.modev.generator.nodejs.entity

import co.edu.unal.modev.entity.entityDsl.Entity
import javax.inject.Inject
import co.edu.unal.modev.generator.nodejs.entity.util.EntityUtil

class GenerateEntityTemplate {
	
	@Inject extension EntityUtil
	
	def generate(Entity entity)'''
	
	var logger = require("../../config/logger");
	
	module.exports = function(sequelize, DataTypes) {
		
		var «entity.name» = sequelize.define('«entity.dbTableName»', {
			
			«FOR column: entity.columns»
			«column.name»: {
				type: «column.columnDataType»,
				«IF column.unique»
				unique: true
				«ENDIF»
				«IF column.allowNull»
				allowNull: true
				«ENDIF»
				«IF column.defaultValue != null && !column.defaultValue.empty»
				defaultValue: «column.defaultValue»
				«ENDIF»
				«IF column.comment != null && !column.comment.empty»
				comment: «column.comment»
				«ENDIF»
			}
			«ENDFOR»
			
		}
		
		return «entity.name»;
	}
	'''
	
}