
package co.edu.unal.modev.generator.nodejs.layeredApp

import co.edu.unal.modev.generator.IGeneratorLayeredApp
import co.edu.unal.modev.generator.nodejs.layeredApp.business.GenerateBusinessLayer
import co.edu.unal.modev.generator.nodejs.layeredApp.persistence.GeneratePersistenceLayer
import co.edu.unal.modev.generator.nodejs.layeredApp.route.GenerateRouteLayer
import co.edu.unal.modev.generator.nodejs.layeredApp.structure.GenerateProjectStructure
import com.google.inject.Inject
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

/**
 * Generates code from model files.
 * 
 */
class NodejsGenerator implements IGeneratorLayeredApp {
	
	@Inject private GeneratePersistenceLayer generatePersistenceLayer
	@Inject private GenerateBusinessLayer generateBusinessLayer
	@Inject private GenerateRouteLayer generateRouteLayer
	@Inject private GenerateProjectStructure generateProjectStructure
	
	override doBeginGeneration(Resource resource, JavaIoFileSystemAccess fsa, IProgressMonitor monitor, int percentageToAssign) {
		
		generateProjectStructure.generate(resource, fsa);
		
		generatePersistenceLayer.generate(resource, fsa)
		
		generateBusinessLayer.generate(resource, fsa)
		
		generateRouteLayer.generate(resource, fsa)
		
		
		monitor.subTask("...")
		monitor.worked(percentageToAssign)
		
		
	}
	
	override doGenerateDifferentiation(Resource newResource, Resource oldResource) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override doGenerate(Resource input, IFileSystemAccess fsa) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
