/*
 * generated by Xtext
 */
package co.edu.unal.modev.layeredApp.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.core.runtime.IProgressMonitor

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class JeeGenerator implements IGeneratorLayeredApp {
	
	override doBeginGeneration(Resource resource, JavaIoFileSystemAccess fsa, IProgressMonitor monitor, int percentageToAssign) {
		
		monitor.subTask("...");
		monitor.worked(percentageToAssign/2);
		
		monitor.subTask("...");
		monitor.worked(percentageToAssign/2);
		
		System::out.println("JEE!!!!!!!!!!!!!!!!!!!!!!!!!!");
	}
	
	override doGenerateDifferentiation(Resource newResource, Resource oldResource) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override doGenerate(Resource input, IFileSystemAccess fsa) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}
