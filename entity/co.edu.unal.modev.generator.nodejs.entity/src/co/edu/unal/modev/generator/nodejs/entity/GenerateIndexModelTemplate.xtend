package co.edu.unal.modev.generator.nodejs.entity

import co.edu.unal.modev.entity.entityDsl.Entity
import co.edu.unal.modev.generator.nodejs.entity.util.EntityUtil
import com.google.inject.Inject
import java.util.List
import co.edu.unal.modev.entity.entityDsl.HasOneRelation
import co.edu.unal.modev.entity.entityDsl.HasManyRelation
import co.edu.unal.modev.entity.entityDsl.BelongsToRelation

class GenerateIndexModelTemplate {
	
	@Inject extension EntityUtil
	
	def generate(List<Entity> entities)'''
	var Sequelize = require('sequelize');
	var logger = require("../../config/logger");
	
	var env = process.env.NODE_ENV || 'development';
	
	var config = require('../../config/config')[env];
	
	// initialize database connection
	logger.debug('Connecting to engine:'+config.db.dialect+" dbName: "+config.db.name+'...');
	
	var sequelize = new Sequelize(config.db.name, config.db.user, config.db.password, {
		// custom host; default: localhost
		host: config.db.host,
	
		// custom port; default: 3306
		port: config.db.port,
	
		// max concurrent database requests; default: 50
		maxConcurrentQueries: 100,
	
		// the sql dialect of the database
		dialect: config.db.dialect,
	
		// use pooling in order to reduce db connection overload and to increase speed
		// currently only for mysql and postgresql (since v1.5.0)
		pool: { maxConnections: 5, maxIdleTime: 30},
	
		logging: logger.debug
	});
	
	// load models
	var models = [
		«FOR entity: entities»
		{model: "«entity.name.toFirstUpper»", module: "«entity.entityModule.name»"} ,
		«ENDFOR»
	];
	
	models.forEach(function(model) {
	  module.exports[model.model] = sequelize.import(__dirname + '/'+ model.module +'/'+ model.model);
	});
	
	// describe relationships
	(function(m) {
	
	  «FOR entity: entities»
	  	«FOR relation: entity.relations»
	  	«switch (relation) {
	  		HasOneRelation:
	  		'''m.«entity.name.toFirstUpper».hasOne(m.«relation.name.name.toFirstUpper»);'''
	  		HasManyRelation:
	  		'''m.«entity.name.toFirstUpper».hasMany(m.«relation.name.name.toFirstUpper»);'''
	  		BelongsToRelation:
	  		'''m.«entity.name.toFirstUpper».belongsTo(m.«relation.name.name.toFirstUpper»);'''
	  	}»
	  	«ENDFOR»
	  «ENDFOR»
	  
	})(module.exports);
	
	sequelize.sync()
		.error(function(error){
			logger.error(error);
			throw error;
		});
	
	// export connection
	module.exports.sequelize = sequelize;
	
	'''
}