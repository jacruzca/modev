package co.edu.unal.modev.generator.nodejs.entity

import co.edu.unal.modev.entity.entityDsl.Entity
import javax.inject.Inject
import co.edu.unal.modev.generator.nodejs.entity.util.EntityUtil
import co.edu.unal.modev.entity.entityDsl.Column
import co.edu.unal.modev.entity.entityDsl.PrimaryKey

class GenerateEntityTemplate {
	
	@Inject extension EntityUtil
	
	def generate(Entity entity)'''
	
	var logger = require("../../../config/logger");
	
	module.exports = function(sequelize, DataTypes) {
		
		var «entity.name» = sequelize.define('«entity.dbTableName»', {
			
			«FOR column: entity.columns»
			«column.name»: {
				type: «column.columnDataType»,
				«IF column.unique»
				unique: true,
				«ENDIF»
				«IF column.columnIsPK(entity)»
				primaryKey: true,
				«ENDIF»
				«IF column.columnIsAI(entity)»
				autoIncrement: true,
				«ENDIF»
				«IF column.allowNull»
				allowNull: true,
				«ENDIF»
				«IF column.defaultValue != null && !column.defaultValue.empty»
				defaultValue: «column.defaultValue»,
				«ENDIF»
				«IF column.comment != null && !column.comment.empty»
				comment: «column.comment»,
				«ENDIF»
			},
			«ENDFOR»
			
		});
		
		
		return «entity.name»;
	}
	'''
	
	private def columnIsPK(Column column, Entity entity){
		for(pk: entity.primaryKeys){
			if(pk.name.name.equals(column.name)){
				return true;
			}
		}
		
		return false;
	}
	
	private def getColumnPK(Column column, Entity entity){
		for(pk: entity.primaryKeys){
			if(pk.name.name.equals(column.name)){
				return pk
			}
		}
		return null;
	}
	
	private def columnIsAI(Column column, Entity entity){
		var pk = column.getColumnPK(entity) as PrimaryKey
		if(pk != null){
			return pk.autoIncrement	
		}
		
		return false;
	}
	
}