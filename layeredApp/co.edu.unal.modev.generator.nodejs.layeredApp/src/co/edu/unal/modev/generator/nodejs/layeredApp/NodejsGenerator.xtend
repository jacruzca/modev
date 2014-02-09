
package co.edu.unal.modev.generator.nodejs.layeredApp

import co.edu.unal.modev.generator.IGeneratorLayeredApp
import co.edu.unal.modev.generator.nodejs.layeredApp.persistence.GeneratePersistenceLayer
import com.google.inject.Inject
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.JavaIoFileSystemAccess

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class NodejsGenerator implements IGeneratorLayeredApp {
	
	@Inject
	private GeneratePersistenceLayer generatePersistenceLayer;
	
	override doBeginGeneration(Resource resource, JavaIoFileSystemAccess fsa, IProgressMonitor monitor, int percentageToAssign) {
		
		generatePersistenceLayer.generate(resource, fsa)
		
		
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
