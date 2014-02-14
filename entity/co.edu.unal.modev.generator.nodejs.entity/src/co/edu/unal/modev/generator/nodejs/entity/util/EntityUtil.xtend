package co.edu.unal.modev.generator.nodejs.entity.util

import co.edu.unal.modev.entity.entityDsl.Column
import co.edu.unal.modev.entity.entityDsl.DATATYPE_ENUM
import co.edu.unal.modev.entity.entityDsl.Entity
import co.edu.unal.modev.entity.entityDsl.EntitiesModule

class EntityUtil {

	/**
	 * Returns the table name
	 * @param entity the entity object
	 */
	def getDbTableName(Entity entity) {

		var tableName = entity.name

		if (entity.tableName != null && !entity.tableName.empty) {
			tableName = entity.tableName
		}

		return tableName
	}
	
	def getEntityModule(Entity entity){
		var module = entity.eContainer as EntitiesModule
		return module 
	}

	def getColumnDataType(Column column) {

		var typeStr = ""

		switch column.type {
			case STRING:
				typeStr = column.getTypeStr("STRING", true)
			case INTEGER:
				typeStr = column.getTypeStr("INTEGER")
			case TEXT:
				typeStr = column.getTypeStr("TEXT")
			case BIGINT:
				typeStr = column.getTypeStr("BIGINT", true)
			case FLOAT:
				typeStr = column.getTypeStr("FLOAT", true, true)
			case DECIMAL:
				typeStr = column.getTypeStr("DECIMAL", true, true)
			case DATE:
				typeStr = column.getTypeStr("DATE")
			case BOOLEAN:
				typeStr = column.getTypeStr("BOOLEAN")
			case BLOB:
				typeStr = column.getTypeStr("BLOB")
			default:
				typeStr = ""
		}
	}

	private def getTypeStr(Column column, String type, boolean addLength, boolean addPrecision) {
		var typeStr = "DataTypes." + type
		if (addLength) {
			typeStr = typeStr + column.addLengthAndPrecision(addPrecision)
		}
		return typeStr
	}

	private def getTypeStr(Column column, String type) {
		return getTypeStr(column, type, false, false)
	}

	private def getTypeStr(Column column, String type, boolean addLength) {
		return getTypeStr(column, type, addLength, false)
	}

	private def addLengthAndPrecision(Column column, boolean addPrecision) {
		var lAndP = ""
		if (column.length > 0) {
			if (column.precision > 0) {
				lAndP = "(" + column.length + "," + column.precision + ")"
			} else {
				lAndP = "(" + column.length + ")"
			}
		}

		return lAndP
	}

}
